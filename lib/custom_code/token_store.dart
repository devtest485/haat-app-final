import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

/// The signed-in session, held in the platform keystore.
///
/// Not `SharedPreferences`. A refresh token is a long-lived credential that mints
/// access tokens, and preferences are a plain file — readable on a rooted or jailbroken
/// handset, and swept up by some backup tools. The Android Keystore and the iOS Keychain
/// exist for exactly this, and the cost of using them is one dependency.
class TokenStore {
  TokenStore({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              // From flutter_secure_storage 10 the plain-preferences backend is gone
              // and the default is what `encryptedSharedPreferences: true` used to
              // ask for: an AES-GCM body under an RSA-OAEP wrapped key, in the
              // Keystore. Stated rather than omitted, because it is the property this
              // class exists for.
              aOptions: AndroidOptions(),
              iOptions: IOSOptions(
                // Not synced to iCloud, and unreadable until the device has been
                // unlocked once since boot: a token is worth nothing on a locked phone
                // and should not travel between the owner's devices on its own.
                accessibility: KeychainAccessibility.first_unlock_this_device,
              ),
            );

  final FlutterSecureStorage _storage;

  static const _accessKey = 'haat.accessToken';
  static const _refreshKey = 'haat.refreshToken';
  static const _userIdKey = 'haat.userId';
  static const _deviceKey = 'haat.deviceFingerprint';
  static const _deviceIdKey = 'haat.deviceId';
  static const _passcodeSecretKey = 'haat.passcodeDeviceSecret';
  static const _passcodeUserKey = 'haat.passcodeUserId';

  String? _access;
  String? _refresh;
  String? _userId;
  String? _deviceId;
  String? _fingerprint;
  String? _passcodeSecret;
  String? _passcodeUserId;

  /// The current access token, or null when signed out.
  ///
  /// Held in memory as well as in storage because it is read on every request, and a
  /// keystore round trip per call would be paid many times a screen.
  String? get accessToken => _access;

  String? get refreshToken => _refresh;

  String? get userId => _userId;

  /// The server's own id for this handset, from the last sign-in.
  ///
  /// Not the same value as [deviceFingerprint]: the fingerprint is what this install
  /// generated and is recognised by, and this is the row the backend keeps about it.
  /// `POST /auth/biometric` names a device by this id, so enrolling biometrics needs it —
  /// and a sign-in response is the only place it is ever handed out.
  String? get deviceId => _deviceId;

  bool get hasSession => _refresh != null;

  /// The secret that, together with the passcode, signs this handset back in.
  ///
  /// Issued by `POST /auth/passcode/device` to a session that was already open here.
  /// The passcode alone is six digits and never enough to open a session; this is the
  /// half that proves the request comes from a phone the owner has signed in on.
  String? get passcodeSecret => _passcodeSecret;

  /// Whose account [passcodeSecret] belongs to. A second person signing in on the same
  /// phone needs their own, and this is how the session knows the stored one is not it.
  String? get passcodeUserId => _passcodeUserId;

  /// Loads whatever the last run left behind. Call once, at startup.
  Future<void> restore() async {
    _access = await _read(_accessKey);
    _refresh = await _read(_refreshKey);
    _userId = await _read(_userIdKey);
    _deviceId = await _read(_deviceIdKey);
    _fingerprint = await _read(_deviceKey);
    _passcodeSecret = await _read(_passcodeSecretKey);
    _passcodeUserId = await _read(_passcodeUserKey);
  }

  Future<void> savePasscodeSecret({
    required String userId,
    required String secret,
  }) async {
    _passcodeSecret = secret;
    _passcodeUserId = userId;

    await _write(_passcodeSecretKey, secret);
    await _write(_passcodeUserKey, userId);
  }

  /// Forgets the passcode secret — once the server has stopped accepting it, offering
  /// "Login with Passcode" would only ever produce a refusal.
  Future<void> clearPasscodeSecret() async {
    _passcodeSecret = null;
    _passcodeUserId = null;

    await _delete(_passcodeSecretKey);
    await _delete(_passcodeUserKey);
  }

  Future<void> save({
    required String accessToken,
    required String refreshToken,
    required String userId,
    String? deviceId,
  }) async {
    _access = accessToken;
    _refresh = refreshToken;
    _userId = userId;

    await _write(_accessKey, accessToken);
    await _write(_refreshKey, refreshToken);
    await _write(_userIdKey, userId);

    // Only when the sign-in named one. A route that does not return a device id must not
    // blank out the value an earlier sign-in already established.
    if (deviceId != null && deviceId.isNotEmpty) {
      _deviceId = deviceId;
      await _write(_deviceIdKey, deviceId);
    }
  }

  /// Replaces the pair after a refresh.
  ///
  /// The backend rotates the refresh token on every use, so the new one has to be
  /// stored or the next refresh presents a token that has already been spent.
  Future<void> replaceTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    _access = accessToken;
    _refresh = refreshToken;

    await _write(_accessKey, accessToken);
    await _write(_refreshKey, refreshToken);
  }

  /// Ends the session here. The passcode secret survives, like the fingerprint: it is
  /// what lets the owner sign back in with the passcode after signing out.
  Future<void> clear() async {
    _access = null;
    _refresh = null;
    _userId = null;
    _deviceId = null;

    await _delete(_accessKey);
    await _delete(_refreshKey);
    await _delete(_userIdKey);
    await _delete(_deviceIdKey);
  }

  /// A stable identifier for this installation, created once and kept.
  ///
  /// The backend groups sessions by it, so the session list reads "this phone, three
  /// times" instead of three unrelated devices. It deliberately is not a hardware
  /// identifier: those are restricted on both platforms, and a value we generate
  /// ourselves cannot be correlated with the user's other apps. Reinstalling produces a
  /// new one, which is the correct behaviour — the old install's sessions are not this
  /// install's.
  ///
  /// The fingerprint survives [clear] so signing out and back in on the same handset
  /// does not create a second device.
  Future<String> deviceFingerprint() async {
    final remembered = _fingerprint;
    if (remembered != null) return remembered;

    final existing = await _read(_deviceKey);
    if (existing != null && existing.isNotEmpty) return _fingerprint = existing;

    final created = const Uuid().v4();
    await _write(_deviceKey, created);

    // Held in memory as well as written. When the keystore is unavailable the write
    // fails silently, and without this every call would mint a new id — so a single
    // session would register as several devices, and the session list would fill up
    // with phantoms.
    return _fingerprint = created;
  }

  // Every keystore call is guarded. The plugin throws on some Android
  // configurations — a corrupted keystore entry after an OS upgrade is the usual one —
  // and a storage failure must degrade to "signed out", never to a crash on launch.
  Future<String?> _read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (_) {
      return null;
    }
  }

  Future<void> _write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (_) {
      // The in-memory copy still serves this run; the user signs in again next launch.
    }
  }

  Future<void> _delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (_) {
      // Nothing useful to do. The in-memory copy is already gone, which is what
      // signing out means for this run.
    }
  }
}
