import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../api/api_client.dart';
import '../api/api_result.dart';
import '../api/auth_api.dart';
import 'device_identity.dart';
import 'token_store.dart';

/// Where the app is with respect to being signed in.
enum AuthStatus {
  /// Storage has not been read yet. The splash stays up during this.
  unknown,

  /// No session. The onboarding and sign-in screens are the only ones reachable.
  signedOut,

  /// Signed in, but onboarding is unfinished — no password, no handle yet.
  onboarding,

  /// Signed in and set up.
  signedIn,
}

/// The single source of truth for who is signed in.
///
/// One instance, created in `main` and reachable through [instance]. A screen calls a
/// method here rather than touching [AuthApi] directly, so that saving the tokens,
/// updating the status and notifying the router all happen together — the alternative
/// is a screen that signs in successfully and forgets to persist it.
class AuthSession extends ChangeNotifier {
  AuthSession._({
    required TokenStore tokens,
    required ApiClient client,
    required DeviceIdentity device,
  })  : _tokens = tokens,
        _client = client,
        _device = device,
        api = AuthApi(client, device) {
    _client.onSessionExpired = _onSessionExpired;
  }

  static AuthSession? _instance;

  /// The session for this run of the app. [initialize] must have been awaited.
  static AuthSession get instance {
    final existing = _instance;
    if (existing == null) {
      throw StateError('AuthSession.initialize() must be awaited before use');
    }

    return existing;
  }

  /// Builds the session and restores any tokens the last run left behind.
  ///
  /// [inner] and [storage] exist so a test can supply their own; production passes
  /// neither.
  static Future<AuthSession> initialize({
    http.Client? inner,
    TokenStore? storage,
  }) async {
    final tokens = storage ?? TokenStore();
    await tokens.restore();

    final client = ApiClient(tokens: tokens, inner: inner);
    final session = AuthSession._(
      tokens: tokens,
      client: client,
      device: DeviceIdentity(tokens),
    );

    await session._resolveStartingStatus();
    _instance = session;

    return session;
  }

  final TokenStore _tokens;
  final ApiClient _client;
  final DeviceIdentity _device;

  /// The typed endpoints. Public because screens outside authentication need them too.
  final AuthApi api;

  AuthStatus _status = AuthStatus.unknown;
  CredentialStatus? _credentials;

  /// The number registration is waiting on a code for.
  ///
  /// Held here rather than passed between screens as a route parameter so that "resend
  /// the code" still works after the app has been backgrounded and the route arguments
  /// have gone.
  String? _pendingMobile;

  /// The one-time code, when the backend chose to hand it back.
  ///
  /// A non-production backend returns the code in `devOtpCode` so the sign-up flow can
  /// be walked through without an SMS gateway — see the note on
  /// [RegistrationStarted.devOtpCode]. Production returns null, so this stays null
  /// there and everything downstream of it simply does not happen.
  ///
  /// **This exists only to save typing in development.** It is not a bypass: the code
  /// is still sent to `POST /auth/verify-otp` and still verified by the server, so the
  /// path exercised in development is the path that runs in production.
  ///
  /// See `docs/BEFORE-GOING-LIVE.md`.
  String? _devOtpCode;

  AuthStatus get status => _status;

  bool get isSignedIn =>
      _status == AuthStatus.signedIn || _status == AuthStatus.onboarding;

  String? get userId => _tokens.userId;

  /// What the account has set up, as of the last time it was read.
  CredentialStatus? get credentials => _credentials;

  String? get pendingMobile => _pendingMobile;

  /// See [_devOtpCode]. Null against production.
  String? get devOtpCode => _devOtpCode;

  DeviceIdentity get device => _device;

  /// The language the backend answers in, and the one message text is read in.
  String get languageCode => _client.languageCode;

  set languageCode(String code) {
    _client.languageCode = code;
    notifyListeners();
  }

  // ── Signing up ──────────────────────────────────────────────────────────────

  /// Starts registration. On success the number is remembered for the OTP screen.
  Future<ApiResult<RegistrationStarted>> register({
    required String mobile,
    String? fullName,
    String? idempotencyKey,
  }) async {
    final result = await api.register(
      mobile: mobile,
      fullName: fullName,
      idempotencyKey: idempotencyKey,
    );

    if (result case ApiSuccess<RegistrationStarted>(:final value)) {
      _pendingMobile = mobile;
      _devOtpCode = value.devOtpCode;
      notifyListeners();
    }

    return result;
  }

  Future<ApiResult<RegistrationStarted>> resendOtp({String? mobile}) async {
    final result = await api.resendOtp(mobile: mobile ?? _pendingMobile ?? '');

    // A resend issues a new code, so the old one is no longer the answer.
    if (result case ApiSuccess<RegistrationStarted>(:final value)) {
      _devOtpCode = value.devOtpCode;
      notifyListeners();
    }

    return result;
  }

  /// Verifies the code and adopts the session it returns.
  Future<ApiResult<AuthTokens>> verifyOtp({
    required String code,
    String? mobile,
  }) async {
    final result = await api.verifyOtp(
      mobile: mobile ?? _pendingMobile ?? '',
      code: code,
    );

    if (result case ApiSuccess<AuthTokens>(:final value)) {
      await _adopt(value);
    }

    return result;
  }

  // ── Signing in ──────────────────────────────────────────────────────────────

  /// Signs in with one identifier and a password.
  ///
  /// A `MFA_REQUIRED` failure is returned rather than handled: the screen has to
  /// collect a code, and it needs the `mfaToken` out of the failure's `data` to do it.
  Future<ApiResult<AuthTokens>> signIn({
    String? mobile,
    String? username,
    String? email,
    required String password,
  }) async {
    final result = await api.signIn(
      mobile: mobile,
      username: username,
      email: email,
      password: password,
    );

    if (result case ApiSuccess<AuthTokens>(:final value)) {
      await _adopt(value);
    }

    return result;
  }

  /// Completes a sign-in that needed a second factor.
  Future<ApiResult<AuthTokens>> verifyMfa({
    required String mfaToken,
    required String code,
  }) async {
    final result = await api.verifyMfa(mfaToken: mfaToken, code: code);

    if (result case ApiSuccess<AuthTokens>(:final value)) {
      await _adopt(value);
    }

    return result;
  }

  /// Signs in with the passcode on a device that already has a session.
  Future<ApiResult<AuthTokens>> signInWithPasscode(String passcode) async {
    final result = await api.signInWithPasscode(passcode: passcode);

    if (result case ApiSuccess<AuthTokens>(:final value)) {
      await _adopt(value);
    }

    return result;
  }

  // ── Onboarding steps ────────────────────────────────────────────────────────

  Future<ApiResult<DateTime?>> setPassword(String password) async {
    final result = await api.setPassword(password: password);
    if (result.isSuccess) await refreshCredentials();

    return result;
  }

  Future<ApiResult<DateTime?>> setPasscode(String passcode) async {
    final result = await api.setPasscode(passcode: passcode);
    if (result.isSuccess) await refreshCredentials();

    return result;
  }

  Future<ApiResult<String>> claimUsername(String username) async {
    final result = await api.claimUsername(username);
    if (result.isSuccess) await refreshCredentials();

    return result;
  }

  /// Re-reads which credentials the account has, and updates [status] from it.
  Future<void> refreshCredentials() async {
    if (!_tokens.hasSession) return;

    final result = await api.credentialStatus();

    if (result case ApiSuccess<CredentialStatus>(:final value)) {
      _credentials = value;
      _status = _statusFor(value);
      notifyListeners();
    }
  }

  // ── Ending a session ────────────────────────────────────────────────────────

  /// Signs out here and on the server.
  ///
  /// The local tokens are cleared whatever the server says. A user who taps sign out on
  /// a borrowed phone must end up signed out on that phone even if the network is down;
  /// the server-side session then expires on its own.
  Future<void> signOut() async {
    if (_tokens.hasSession) await api.logout();

    await _tokens.clear();
    _credentials = null;
    _pendingMobile = null;
    _devOtpCode = null;
    _status = AuthStatus.signedOut;
    notifyListeners();
  }

  /// Stores a freshly issued token pair and works out where the user should be.
  Future<void> _adopt(AuthTokens issued) async {
    // The code has been spent, so there is no reason to keep it around.
    _devOtpCode = null;

    await _tokens.save(
      accessToken: issued.accessToken,
      refreshToken: issued.refreshToken,
      userId: issued.userId,
    );

    // Optimistic, so the router can move immediately; refreshCredentials then settles
    // whether onboarding is actually finished.
    _status = AuthStatus.onboarding;
    notifyListeners();

    await refreshCredentials();
  }

  Future<void> _resolveStartingStatus() async {
    if (!_tokens.hasSession) {
      _status = AuthStatus.signedOut;

      return;
    }

    // A stored session is not proof of a live one — the refresh token may have been
    // revoked from another device while the app was closed. Reading the credential
    // status is the cheapest call that finds out, and it fills in what onboarding still
    // needs at the same time.
    await refreshCredentials();

    if (_status == AuthStatus.unknown) {
      // The call did not come back with an answer, which on a cold start with no network
      // is the ordinary case. Trust the stored tokens for now; the first real request
      // will refresh them or sign the user out.
      _status = AuthStatus.signedIn;
    }
  }

  static AuthStatus _statusFor(CredentialStatus credentials) {
    // A handle and a password are what the onboarding flow exists to collect. Until
    // both are set the user has an account they cannot get back into on another
    // device, so they are still onboarding.
    final ready = credentials.hasPassword &&
        (credentials.username?.isNotEmpty ?? false) &&
        !credentials.mustChangePassword;

    return ready ? AuthStatus.signedIn : AuthStatus.onboarding;
  }

  void _onSessionExpired() {
    _credentials = null;
    _status = AuthStatus.signedOut;
    notifyListeners();
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }
}
