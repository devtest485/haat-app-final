import '/custom_code/device_identity.dart';
import '/custom_code/api_client.dart';
import '/custom_code/api_result.dart';

/// A session and the tokens that carry it.
class AuthTokens {
  const AuthTokens({
    required this.userId,
    required this.status,
    required this.accessToken,
    required this.refreshToken,
    required this.sessionId,
    required this.deviceId,
    required this.mustChangePassword,
  });

  final String userId;
  final String status;
  final String accessToken;
  final String refreshToken;
  final String sessionId;
  final String deviceId;

  /// True on the first sign-in of an account whose password an employer chose. The app
  /// has to send the user to change it before anything else.
  final bool mustChangePassword;

  factory AuthTokens.fromData(Map<String, dynamic> data) => AuthTokens(
        userId: data['userId'] as String,
        status: data['status'] as String? ?? 'active',
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
        sessionId: data['sessionId'] as String? ?? '',
        deviceId: data['deviceId'] as String? ?? '',
        mustChangePassword: data['mustChangePassword'] == true,
      );
}

/// What registering returns: the number is now awaiting a code.
class RegistrationStarted {
  const RegistrationStarted({
    required this.userId,
    required this.mobileMasked,
    required this.otpExpiresAt,
    required this.devOtpCode,
  });

  final String userId;

  /// Masked for display. The caller knows the number they typed; this is what to put on
  /// screen so a shoulder-surfer does not read it back.
  final String mobileMasked;

  final DateTime? otpExpiresAt;

  /// The code itself, returned **only** by a non-production backend so the flow can be
  /// walked through without an SMS gateway. Null against production, where it goes to
  /// the handset.
  final String? devOtpCode;

  factory RegistrationStarted.fromData(Map<String, dynamic> data) =>
      RegistrationStarted(
        userId: data['userId'] as String,
        mobileMasked: data['mobileMasked'] as String? ?? '',
        otpExpiresAt: DateTime.tryParse(data['otpExpiresAt'] as String? ?? ''),
        devOtpCode: data['devOtpCode'] as String?,
      );
}

/// Whether a handle can be claimed, and if not, why not.
class UsernameCheck {
  const UsernameCheck({
    required this.username,
    required this.available,
    required this.unmet,
  });

  final String username;
  final bool available;

  /// Which format rules the input breaks, so the field can say exactly what is wrong
  /// rather than "invalid". Empty when the only problem is that it is taken.
  final List<String> unmet;

  factory UsernameCheck.fromData(Map<String, dynamic> data) => UsernameCheck(
        username: data['username'] as String? ?? '',
        available: data['available'] == true,
        unmet: (data['unmet'] as List<dynamic>? ?? const [])
            .map((rule) => rule.toString())
            .toList(growable: false),
      );
}

/// Which credentials an account has set so far.
///
/// This is what tells the app where somebody left off, rather than guessing from which
/// screen they last saw.
class CredentialStatus {
  const CredentialStatus({
    required this.username,
    required this.hasPassword,
    required this.hasPasscode,
    required this.mobileVerified,
    required this.mfaEnabled,
    required this.mustChangePassword,
    required this.status,
  });

  final String? username;
  final bool hasPassword;
  final bool hasPasscode;
  final bool mobileVerified;
  final bool mfaEnabled;
  final bool mustChangePassword;
  final String status;

  factory CredentialStatus.fromData(Map<String, dynamic> data) =>
      CredentialStatus(
        username: data['username'] as String?,
        hasPassword: data['hasPassword'] == true,
        hasPasscode: data['hasPasscode'] == true,
        mobileVerified: data['mobileVerified'] == true,
        mfaEnabled: data['mfaEnabled'] == true,
        mustChangePassword: data['mustChangePassword'] == true,
        status: data['status'] as String? ?? 'unknown',
      );
}

/// Who the signed-in account belongs to.
///
/// The number arrives masked and there is no way to ask for it whole. That is the
/// backend's decision and the right one: a screen shows the last four digits so the
/// owner recognises their own account, and nothing on a handset needs more than that.
class UserProfile {
  const UserProfile({
    required this.userId,
    required this.fullName,
    required this.mobileMasked,
    required this.status,
  });

  final String userId;
  final String? fullName;
  final String mobileMasked;

  /// `active`, `suspended`, or `pending_verification`.
  final String status;

  factory UserProfile.fromData(Map<String, dynamic> data) => UserProfile(
        userId: data['userId'] as String? ?? '',
        fullName: data['fullName'] as String?,
        mobileMasked: data['mobileMasked'] as String? ?? '',
        status: data['status'] as String? ?? 'unknown',
      );

  /// What to greet this person with.
  ///
  /// The name if they gave one, then the handle they chose, then the masked number —
  /// which every account has, so this never comes back empty. A screen that says
  /// "Welcome" to a blank space is worse than one that says it to a phone number.
  String displayName(String? username) {
    final name = fullName?.trim();
    if (name != null && name.isNotEmpty) return name;

    final handle = username?.trim();
    if (handle != null && handle.isNotEmpty) return handle;

    return mobileMasked;
  }
}

/// The authentication and onboarding routes.
///
/// One method per endpoint, named for what the user is doing rather than for the verb
/// and path. Nothing here throws: every method returns an [ApiResult].
class AuthApi {
  AuthApi(this._client, this._device);

  final ApiClient _client;
  final DeviceIdentity _device;

  // ── Signing up ──────────────────────────────────────────────────────────────

  /// Starts registration and sends a one-time code to [mobile].
  ///
  /// [idempotencyKey] should be held across retries of the same attempt so a tap on a
  /// bad connection does not send two codes.
  Future<ApiResult<RegistrationStarted>> register({
    required String mobile,
    String? fullName,
    String? email,
    String? idempotencyKey,
  }) =>
      _client.post(
        '/auth/register',
        authenticated: false,
        idempotencyKey: idempotencyKey,
        body: {
          'mobile': mobile,
          if (fullName != null && fullName.isNotEmpty) 'fullName': fullName,
          if (email != null && email.isNotEmpty) 'email': email,
        },
        parse: (envelope) => RegistrationStarted.fromData(envelope.object),
      );

  /// Sends the code again. Rate-limited by the backend, which will say so.
  Future<ApiResult<RegistrationStarted>> resendOtp({required String mobile}) =>
      _client.post(
        '/auth/resend-otp',
        authenticated: false,
        body: {'mobile': mobile},
        parse: (envelope) => RegistrationStarted.fromData(envelope.object),
      );

  /// Proves the number and opens a session.
  Future<ApiResult<AuthTokens>> verifyOtp({
    required String mobile,
    required String code,
  }) async =>
      _client.post(
        '/auth/verify-otp',
        authenticated: false,
        body: {
          'mobile': mobile,
          'code': code,
          ...await _device.context(),
        },
        parse: (envelope) => AuthTokens.fromData(envelope.object),
      );

  // ── Setting credentials, once a session exists ──────────────────────────────

  /// Sets or replaces the password.
  ///
  /// [currentPassword] is required when replacing one — a stolen session must not be
  /// able to lock the owner out of their own account.
  Future<ApiResult<DateTime?>> setPassword({
    required String password,
    String? currentPassword,
  }) =>
      _client.post(
        '/auth/password',
        body: {
          'password': password,
          if (currentPassword != null) 'currentPassword': currentPassword,
        },
        parse: (envelope) => DateTime.tryParse(
            envelope.object['passwordSetAt'] as String? ?? ''),
      );

  /// Sets or replaces the six-digit passcode.
  ///
  /// [password] is required when replacing: a passcode is too weak to authorise its own
  /// change, so the stronger credential has to.
  Future<ApiResult<DateTime?>> setPasscode({
    required String passcode,
    String? password,
  }) =>
      _client.post(
        '/auth/passcode',
        body: {
          'passcode': passcode,
          if (password != null) 'password': password,
        },
        parse: (envelope) => DateTime.tryParse(
            envelope.object['passcodeSetAt'] as String? ?? ''),
      );

  /// Checks a handle before the user commits to it.
  Future<ApiResult<UsernameCheck>> checkUsername(String username) =>
      _client.get(
        '/auth/username/available',
        query: {'username': username},
        parse: (envelope) => UsernameCheck.fromData(envelope.object),
      );

  /// Claims the handle.
  Future<ApiResult<String>> claimUsername(String username) => _client.post(
        '/auth/username',
        body: {'username': username},
        parse: (envelope) => envelope.object['username'] as String? ?? username,
      );

  /// What this account has set up so far.
  Future<ApiResult<CredentialStatus>> credentialStatus() => _client.get(
        '/auth/credentials',
        parse: (envelope) => CredentialStatus.fromData(envelope.object),
      );

  /// Who the signed-in account is.
  ///
  /// The identity comes from the token and never from the request, so there is no id to
  /// pass and no way to ask after somebody else.
  ///
  /// Separate from [credentialStatus], which answers what the account has *set up* —
  /// whether there is a password, a passcode, a handle. This answers who they are, and
  /// the screens that greet a merchant by name need the second, not the first.
  Future<ApiResult<UserProfile>> profile() => _client.get(
        '/auth/me',
        parse: (envelope) => UserProfile.fromData(envelope.object),
      );

  // ── Signing in ──────────────────────────────────────────────────────────────

  /// Signs in with a password.
  ///
  /// Exactly one identifier is sent. A merchant registers with a phone number, so that
  /// is the common case; an employer-created staff account has no phone number and uses
  /// its username. The backend refuses two rather than picking one.
  Future<ApiResult<AuthTokens>> signIn({
    String? mobile,
    String? username,
    String? email,
    required String password,
  }) async =>
      _client.post(
        '/auth/sign-in',
        authenticated: false,
        body: {
          if (mobile != null) 'mobile': mobile,
          if (username != null) 'username': username,
          if (email != null) 'email': email,
          'password': password,
          ...await _device.context(),
        },
        parse: (envelope) => AuthTokens.fromData(envelope.object),
      );

  /// Confirms the six-digit passcode for the session this device already holds.
  ///
  /// Answers `{"verified": true}` — deliberately not a session. Six digits is a
  /// million combinations, which is nothing to a script, so the server will only
  /// let a passcode re-open an app whose session is already valid. Reading that
  /// reply as tokens is what made every unlock fail with "the server sent a reply
  /// we could not read": the reply was fine, the app was asking it for something
  /// the route had never issued.
  Future<ApiResult<bool>> verifyPasscode({required String passcode}) =>
      _client.post(
        '/auth/passcode/verify',
        body: {'passcode': passcode},
        parse: (envelope) => envelope.object['verified'] == true,
      );

  /// Completes a sign-in that asked for a second factor.
  ///
  /// [mfaToken] comes from the `data` of the `MFA_REQUIRED` failure.
  Future<ApiResult<AuthTokens>> verifyMfa({
    required String mfaToken,
    required String code,
  }) async =>
      _client.post(
        '/auth/mfa/verify',
        authenticated: false,
        body: {
          'mfaToken': mfaToken,
          'code': code,
          ...await _device.context(),
        },
        parse: (envelope) => AuthTokens.fromData(envelope.object),
      );

  /// Ends this session on the server.
  Future<ApiResult<bool>> logout() => _client.post(
        '/auth/logout',
        parse: (_) => true,
      );

  // ── Biometrics ──────────────────────────────────────────────────────────────

  /// Registers this device's public key so biometrics can sign in later.
  ///
  /// [publicKey] is the SPKI public half of a P-256 pair generated in the phone's
  /// secure hardware. The private half never leaves it — which is the entire security
  /// property, and the reason this cannot be satisfied with a value made up in Dart.
  Future<ApiResult<bool>> registerBiometric({
    required String deviceId,
    required String publicKey,
  }) =>
      _client.post(
        '/auth/biometric',
        body: {'deviceId': deviceId, 'publicKey': publicKey},
        parse: (_) => true,
      );

  /// Asks for a single-use challenge to sign.
  Future<ApiResult<String>> biometricChallenge() async => _client.post(
        '/auth/biometric/challenge',
        authenticated: false,
        body: {'deviceFingerprint': await _device.fingerprint()},
        parse: (envelope) => envelope.object['challenge'] as String,
      );

  /// Exchanges a signed challenge for a session.
  Future<ApiResult<AuthTokens>> biometricVerify(
          {required String signature}) async =>
      _client.post(
        '/auth/biometric/verify',
        authenticated: false,
        body: {
          'deviceFingerprint': await _device.fingerprint(),
          'signature': signature,
        },
        parse: (envelope) => AuthTokens.fromData(envelope.object),
      );
}
