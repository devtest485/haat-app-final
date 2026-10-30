import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '/custom_code/api_client.dart';
import '/custom_code/api_envelope.dart';
import '/custom_code/kyc_api.dart';
import '/custom_code/api_result.dart';
import '/custom_code/auth_api.dart';
import '/custom_code/banner_api.dart';
import '/custom_code/biometric_key_store.dart';
import '/custom_code/device_identity.dart';
import '/custom_code/organization_api.dart';
import '/custom_code/payout_api.dart';
import '/custom_code/token_store.dart';
import '/custom_code/business_summary_api.dart';
import '/custom_code/store_profile_api.dart';
import '/custom_code/transaction_api.dart';
import '/custom_code/wallet_api.dart';

/// What a biometric sign-in attempt came to.
///
/// Three outcomes rather than a boolean, because the two failures are not alike: a
/// dismissed prompt means offer the passcode, and a server refusal means show what the
/// server said.
sealed class BiometricSignIn {
  const BiometricSignIn();
}

/// Signed in. The session has already been adopted.
final class BiometricSignedIn extends BiometricSignIn {
  const BiometricSignedIn(this.tokens);

  final AuthTokens tokens;
}

/// No signature came back. [BiometricUnavailable.cancelled] is the ordinary case.
final class BiometricPromptRefused extends BiometricSignIn {
  const BiometricPromptRefused(this.reason);

  final BiometricUnavailable reason;
}

/// The server has no usable enrolment for this handset, so there was nothing to sign.
///
/// Separate from [BiometricSignatureRefused] because the two need opposite handling: this
/// one means the option should stop being offered, and it happens before the owner has
/// been asked for anything — so on a prompt the screen raised by itself, there is nothing
/// worth interrupting them about.
final class BiometricNotEnrolled extends BiometricSignIn {
  const BiometricNotEnrolled(this.result);

  final ApiResult<AuthTokens> result;
}

/// The owner authenticated, and the server would not accept the signature anyway.
///
/// Always worth saying out loud, however the prompt was raised. Somebody who has just put
/// their finger on the sensor and watched nothing happen has no way to tell a refused
/// signature from a broken reader — and the usual cause is a stale challenge, which
/// trying again fixes.
final class BiometricSignatureRefused extends BiometricSignIn {
  const BiometricSignatureRefused(this.result);

  final ApiResult<AuthTokens> result;
}

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

  /// Identity verification. Shares the client, so it shares the session and its refresh.
  late final KycApi kyc = KycApi(_client);

  /// The merchant's business, and the option lists its setup screens render. Shares
  /// the client for the same reason.
  late final OrganizationApi organizations = OrganizationApi(_client);

  /// The cards on the home screen, which the platform maintains rather than the app.
  late final BannerApi banners = BannerApi(_client);

  /// What has moved through the business's account.
  late final TransactionApi transactions = TransactionApi(_client);

  /// The figures on the Profile tab.
  late final StoreProfileApi storeProfile = StoreProfileApi(_client);

  /// What the business took in, for the My Business tab.
  late final BusinessSummaryApi businessSummary = BusinessSummaryApi(_client);

  /// What the business holds, bank by bank.
  late final WalletApi wallet = WalletApi(_client);

  /// Money the business sends from its wallet to its own bank account.
  late final PayoutApi payouts = PayoutApi(_client);

  /// The device key behind biometric sign-in. Held here so the screens that offer it and
  /// the screen that enrols it are talking to the same thing.
  final BiometricKeyStore biometrics = BiometricKeyStore();

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

  /// Whether the sign-in screen stands between this session and the app.
  ///
  /// Reopening the app always asks who is holding the phone, whether the owner
  /// signed out or simply closed it: the same sign-in screen, with the fingerprint,
  /// the password and the passcode. What the stored session buys is that the
  /// passcode there only *unlocks* it (`POST /auth/passcode/verify`) — a check the
  /// server makes against a session it already issued.
  ///
  /// True on the run that opened onto stored tokens for an account that finished
  /// onboarding, and false once any of the three has been given. An account still
  /// in onboarding is not locked: it may have no password yet, and the onboarding
  /// screens are where it has to go anyway.
  ///
  /// **A cold start with no network does not lock.** [_credentials] is null then,
  /// because the call that reads them did not come back, and nothing on the sign-in
  /// screen can be checked without the server either — so locking would shut the
  /// owner out of their own app with no way through. The stored tokens are trusted
  /// for that run, which is the same bargain [_resolveStartingStatus] already makes.
  bool get lockedOnReopen =>
      _restoredSession &&
      _credentials != null &&
      _status == AuthStatus.signedIn;

  /// Whether "Login with Passcode" can work on the sign-in screen right now: this
  /// handset holds a passcode secret, or the app is locked over a session whose
  /// account has a passcode, which the passcode can unlock.
  bool get canUsePasscode =>
      hasPasscodeSignIn ||
      (lockedOnReopen && (_credentials?.hasPasscode ?? false));

  /// Whether this run opened onto tokens the last one left behind.
  bool _restoredSession = false;

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

  /// Answers the passcode lock on a device that already has a session.
  ///
  /// Not a sign-in: the session is the one the last run left behind, and the
  /// passcode only settles whether the person holding the phone is its owner. So
  /// nothing is adopted — [_restoredSession] is cleared, which is the whole of
  /// what [lockedByPasscode] was waiting for.
  Future<ApiResult<bool>> unlockWithPasscode(String passcode) async {
    final result = await api.verifyPasscode(passcode: passcode);

    if (result case ApiSuccess<bool>(value: true)) {
      _restoredSession = false;
    }

    return result;
  }

  /// Whether "Login with Passcode" can work here: this handset was bound while signed in.
  bool get hasPasscodeSignIn => _tokens.passcodeSecret != null;

  /// Signs in with the passcode, after a sign-out, on a handset that was bound for it.
  ///
  /// The passcode is never enough by itself — six digits is nothing to a script. It goes
  /// with the secret the server issued to a session that was open on this phone, so a
  /// stranger who knows the digits still needs this handset, and a copied secret still
  /// needs the digits. Wrong digits count towards the same lockout as a wrong password.
  Future<ApiResult<AuthTokens>> signInWithPasscode(String passcode) async {
    final result = await api.signInWithPasscode(
      deviceSecret: _tokens.passcodeSecret ?? '',
      passcode: passcode,
    );

    if (result case ApiSuccess<AuthTokens>(:final value)) {
      await _adopt(value);
    } else if (result.errorCode == ApiErrorCode.passcodeDeviceNotBound) {
      // The server no longer recognises this handset's secret — the device was revoked,
      // or another binding replaced it. Stop offering an option that cannot succeed.
      await _tokens.clearPasscodeSecret();
      notifyListeners();
    }

    return result;
  }

  /// Asks the server for this handset's passcode secret, and keeps it.
  ///
  /// Quiet on failure: passcode sign-in is a convenience, and the owner has just signed
  /// in or set a passcode successfully — nothing about that should be reported as broken
  /// because this extra step did not come back.
  Future<void> _bindPasscodeDevice() async {
    final userId = _tokens.userId;
    if (userId == null) return;

    final result = await api.bindPasscodeDevice();

    if (result case ApiSuccess<String>(:final value)) {
      await _tokens.savePasscodeSecret(userId: userId, secret: value);
      notifyListeners();
    }
  }

  /// Binds passcode sign-in when the account has a passcode and this handset does not
  /// yet hold that account's secret.
  Future<void> _ensurePasscodeBinding() async {
    if (!(_credentials?.hasPasscode ?? false)) return;
    if (_tokens.passcodeSecret != null &&
        _tokens.passcodeUserId == _tokens.userId) {
      return;
    }

    await _bindPasscodeDevice();
  }

  /// Whether this handset holds a device key, so biometric sign-in is worth offering.
  ///
  /// Asked of the phone rather than remembered in a flag: the key can be destroyed
  /// without the app being told — the owner adds a fingerprint, or clears the app's
  /// data — and a remembered "yes" would then offer an option that cannot work.
  Future<bool> hasBiometricKey() => biometrics.hasKey();

  /// Signs in by having the device key sign a challenge the server issued.
  ///
  /// Three steps, and none of them can be skipped from the app: the server picks the
  /// challenge, the phone's secure hardware refuses to sign until the sensor confirms
  /// the owner, and the server checks the signature against the public half it stored
  /// at enrolment. What the app does is carry values between them.
  ///
  /// A refused prompt and a refused signature are separate outcomes, because they need
  /// opposite responses: somebody who dismissed the sheet wants the passcode, and only a
  /// server refusal has a message worth putting on screen.
  Future<BiometricSignIn> signInWithBiometrics() async {
    final challenge = await api.biometricChallenge();

    // A 404 here is the ordinary answer on a device the server has no key for. The app
    // asked because this handset held one locally, and the two can drift apart — after a
    // reinstall, or once the device has been revoked from another phone.
    if (challenge is! ApiSuccess<String>) {
      return BiometricNotEnrolled(_recast(challenge));
    }

    final signed = await biometrics.sign(challenge.value);

    if (signed is! BiometricSigned) {
      return BiometricPromptRefused(
        signed is BiometricSignRefused
            ? signed.reason
            : BiometricUnavailable.platformError,
      );
    }

    final result = await api.biometricVerify(signature: signed.signature);

    if (result case ApiSuccess<AuthTokens>(:final value)) {
      await _adopt(value);

      return BiometricSignedIn(value);
    }

    return BiometricSignatureRefused(result);
  }

  /// Re-types a failed challenge as a failed sign-in.
  ///
  /// The two calls carry different payloads and the same failure shapes, and the screen
  /// only ever wants the message — so the envelope is moved across rather than the
  /// caller being made to handle two result types for one attempt.
  static ApiResult<AuthTokens> _recast(ApiResult<String> failure) =>
      switch (failure) {
        ApiFailure<String>(:final envelope) => ApiFailure<AuthTokens>(envelope),
        ApiUnreachable<String>(
          :final cause,
          :final message,
          :final messageAr
        ) =>
          ApiUnreachable<AuthTokens>(
            cause,
            message: message,
            messageAr: messageAr,
          ),
        // Unreachable: only failures are passed here, and a success carries a value
        // that has nowhere to go in an AuthTokens result.
        ApiSuccess<String>() =>
          throw StateError('A successful challenge is not a failed sign-in'),
      };

  /// Enrols this device's key and registers its public half.
  ///
  /// Both halves or neither: a key the server never accepted is not biometric sign-in,
  /// so a rejected registration destroys the key it just made rather than leaving one
  /// behind that will only ever produce rejected signatures.
  Future<BiometricEnrolment> enableBiometrics() async {
    final unavailable = await biometrics.availability();
    if (unavailable != null) return BiometricRefused(unavailable);

    // The server names a device by the id it issued at sign-in, not by the fingerprint
    // this install generated. A session restored from before that id was stored has no
    // way to name itself, and signing in again is the only thing that fixes it.
    final deviceId = _tokens.deviceId;

    if (deviceId == null || deviceId.isEmpty) {
      return const BiometricRefused(
        BiometricUnavailable.platformError,
        detail: 'This session predates device identification; sign in again.',
      );
    }

    final enrolment = await biometrics.enrol();
    if (enrolment is! BiometricEnrolled) return enrolment;

    final registered = await api.registerBiometric(
      deviceId: deviceId,
      publicKey: enrolment.publicKey,
    );

    if (!registered.isSuccess) {
      await biometrics.remove();

      return const BiometricRefused(BiometricUnavailable.platformError);
    }

    return enrolment;
  }

  // ── Onboarding steps ────────────────────────────────────────────────────────

  Future<ApiResult<DateTime?>> setPassword(String password) async {
    final result = await api.setPassword(password: password);
    if (result.isSuccess) await refreshCredentials();

    return result;
  }

  /// Sets the passcode, or replaces it — replacing needs [password], because a
  /// passcode someone watched being typed must not be enough to change it.
  Future<ApiResult<DateTime?>> setPasscode(
    String passcode, {
    String? password,
  }) async {
    final result =
        await api.setPasscode(passcode: passcode, password: password);
    if (result.isSuccess) {
      await refreshCredentials();
      // A new passcode is the moment passcode sign-in becomes possible on this handset.
      await _bindPasscodeDevice();
    }

    return result;
  }

  Future<ApiResult<String>> claimUsername(String username) async {
    final result = await api.claimUsername(username);
    if (result.isSuccess) await refreshCredentials();

    return result;
  }

  /// Re-reads who the signed-in account is.
  ///
  /// Returns the profile so the caller can put it wherever the screens read from —
  /// App State, in this app's case, which is written by `haatLoadProfile` rather than
  /// here. This class is deliberately free of FlutterFlow: it is ported Dart that the
  /// tests exercise without a widget tree, and reaching for `FFAppState` here would
  /// drag the framework into every one of them.
  ///
  /// Null on failure, and nothing is disturbed. A greeting is not worth an error in
  /// front of somebody who has just signed in.
  Future<UserProfile?> refreshProfile() async {
    if (!_tokens.hasSession) return null;

    final result = await api.profile();

    if (result case ApiSuccess<UserProfile>(:final value)) {
      _profile = value;
      notifyListeners();

      return value;
    }

    return null;
  }

  /// The signed-in account, or null before the first successful read.
  UserProfile? get profile => _profile;

  /// The handle this account chose, if it has one. For building a greeting.
  String? get username => _credentials?.username;

  UserProfile? _profile;

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

  // ── The business ────────────────────────────────────────────────────────────

  /// Registers the business this account will trade as, and adopts the reach it grants.
  ///
  /// The token refresh is the part worth naming. `POST /organizations` makes this
  /// account the business's owner, which is a set of permissions the token in hand was
  /// minted without — and nothing about that token *fails*, so the reactive refresh
  /// never fires. The next call would simply be refused for a reason the merchant did
  /// nothing to cause. Asking for a new one here closes that window.
  ///
  /// ## Names and handles
  ///
  /// No two businesses share a name — the server refuses a second "Flow Bakery",
  /// whatever its case or spacing, and that refusal is returned as it is for the screen
  /// to show under the name field. Only the merchant can choose another name.
  ///
  /// The handle is different. It is built from the name, so "Flow Bakery" and
  /// "Flow-Bakery!" ask for the same one. That is a clash in a technical detail the
  /// merchant never chose and never sees, so it is not theirs to resolve: the handle is
  /// retried once with a short suffix, and the name they typed is kept as typed.
  Future<ApiResult<String>> createOrganization({
    required String name,
    String? category,
  }) async {
    var result = await organizations.create(
      name: name,
      slug: handleFor(name),
      category: category,
    );

    // A taken handle is retried; a taken *name* is not. Both come back as `CONFLICT`,
    // told apart by the field the server names: the name is the merchant's own choice
    // and only they can pick another, so it goes straight back to the screen.
    if (result is ApiFailure<String> &&
        result.errorCode == 'CONFLICT' &&
        result.data['field'] == 'slug') {
      final suffix = DateTime.now().millisecondsSinceEpoch.toRadixString(36);

      result = await organizations.create(
        name: name,
        slug: '${handleFor(name)}-${suffix.substring(suffix.length - 4)}',
        category: category,
      );
    }

    if (result is ApiSuccess<String>) {
      await _client.refreshSession();
      await refreshCredentials();
    }

    return result;
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
    _profile = null;
    _pendingMobile = null;
    _devOtpCode = null;
    // The option lists are the same for everyone, but the next person to sign in on
    // this handset should not inherit anything this one fetched.
    organizations.forget();
    _status = AuthStatus.signedOut;
    notifyListeners();
  }

  /// Stores a freshly issued token pair and works out where the user should be.
  Future<void> _adopt(AuthTokens issued) async {
    // The code has been spent, so there is no reason to keep it around.
    _devOtpCode = null;

    // Whatever got us here — a code, a password, a fingerprint, the passcode
    // itself — the session is this run's now and the lock has been answered.
    _restoredSession = false;

    await _tokens.save(
      accessToken: issued.accessToken,
      refreshToken: issued.refreshToken,
      userId: issued.userId,
      deviceId: issued.deviceId,
    );

    // Optimistic, so the router can move immediately; refreshCredentials then settles
    // whether onboarding is actually finished.
    _status = AuthStatus.onboarding;
    notifyListeners();

    await refreshCredentials();

    // An account that set its passcode on another phone, or before this was built, has
    // no secret here yet. Signing in is the proof the binding needs.
    await _ensurePasscodeBinding();
  }

  Future<void> _resolveStartingStatus() async {
    if (!_tokens.hasSession) {
      _status = AuthStatus.signedOut;

      return;
    }

    // Opened onto a session from a previous run, which is the case the passcode
    // guards. Cleared by `_adopt` if the merchant signs in properly instead.
    _restoredSession = true;

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
    _profile = null;
    _status = AuthStatus.signedOut;
    notifyListeners();
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }
}
