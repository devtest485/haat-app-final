import 'dart:io' show Platform;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '/custom_code/token_store.dart';

/// Describes this handset to the backend.
///
/// Sent with every sign-in so the session list is something a person can recognise and
/// act on: "Pixel 8 · last used 10 minutes ago" is a row somebody can decide to revoke.
/// "session 01a0664b…" is not.
class DeviceIdentity {
  DeviceIdentity(this._tokens);

  final TokenStore _tokens;

  String? _label;

  /// The stable per-installation id the backend groups sessions by.
  Future<String> fingerprint() => _tokens.deviceFingerprint();

  /// The fields every sign-in route accepts, ready to spread into a request body.
  Future<Map<String, dynamic>> context() async => {
        'deviceFingerprint': await fingerprint(),
        'deviceLabel': await label(),
        'platform': platform,
      };

  /// `android`, `ios`, `web`, or the platform name — matching what the backend stores.
  String get platform {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';

    return Platform.operatingSystem;
  }

  /// A name the owner would recognise, read once and remembered.
  Future<String> label() async {
    final cached = _label;
    if (cached != null) return cached;

    return _label = await _readLabel();
  }

  Future<String> _readLabel() async {
    // Device info is a plugin call across a platform channel and can fail — an
    // unsupported platform, a permission oddity. A generic label is a perfectly good
    // answer; failing a sign-in over the name of the phone would not be.
    try {
      final info = DeviceInfoPlugin();

      if (kIsWeb) return 'Browser';

      if (Platform.isAndroid) {
        final android = await info.androidInfo;
        final name = '${android.manufacturer} ${android.model}'.trim();

        return name.isEmpty ? 'Android device' : _titleCase(name);
      }

      if (Platform.isIOS) {
        final ios = await info.iosInfo;

        return ios.utsname.machine.isEmpty ? 'iPhone' : ios.name;
      }

      return _titleCase(Platform.operatingSystem);
    } catch (_) {
      return 'Unknown device';
    }
  }

  /// Manufacturers report themselves inconsistently — "samsung", "Xiaomi", "HUAWEI" —
  /// and the label is shown to a user, so it gets normalised.
  static String _titleCase(String value) => value
      .split(' ')
      .where((word) => word.isNotEmpty)
      .map((word) => word.length == 1
          ? word.toUpperCase()
          : '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}
