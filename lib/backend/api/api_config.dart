import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;

/// Where the backend lives, and how patient we are with it.
///
/// The base URL is read from `assets/environment_values/environment.json` so a build
/// can be pointed at a different server without touching Dart. When the file says
/// nothing, [_developmentDefault] applies — and "localhost" is deliberately not that
/// default, because on a phone or an Android emulator localhost is the handset itself,
/// which is the single most common way a first run appears to hang.
class ApiConfig {
  ApiConfig._();

  static const String _configKey = 'apiBaseUrl';
  static const String _configPath = 'assets/environment_values/environment.json';

  static String? _baseUrl;

  /// How long a single request may take before we call it unreachable.
  ///
  /// Sign-in deliberately does slow work — the password hash is scrypt, which is
  /// expensive on purpose — so this is well above what a page load would need.
  static const Duration timeout = Duration(seconds: 30);

  /// The base URL, without a trailing slash.
  ///
  /// [load] must have run first; it does, from `main`.
  static String get baseUrl => _baseUrl ?? _developmentDefault;

  /// Reads the configured base URL once, at startup.
  static Future<void> load() async {
    _baseUrl = await _fromAssets() ?? _developmentDefault;
  }

  static Future<String?> _fromAssets() async {
    try {
      final decoded = json.decode(await rootBundle.loadString(_configPath));
      if (decoded is! Map) return null;

      final configured = decoded[_configKey];
      if (configured is! String || configured.trim().isEmpty) return null;

      return _withoutTrailingSlash(configured.trim());
    } catch (_) {
      // A missing or malformed file is not worth failing a launch over; the
      // development default is a working answer.
      return null;
    }
  }

  /// The address of a backend running on the developer's own machine.
  ///
  /// Each platform reaches that machine by a different name, which is why this is not
  /// one constant:
  ///
  /// - The Android emulator maps `10.0.2.2` to the host. `localhost` is the emulated
  ///   handset, where nothing is listening.
  /// - The iOS simulator shares the host's network stack, so `localhost` is correct.
  /// - A real device on the same Wi-Fi needs the machine's LAN address, which no
  ///   default can guess — set `apiBaseUrl` in the environment file for that.
  static String get _developmentDefault {
    const port = 3000;
    const path = '/api/v1';

    if (kIsWeb) return 'http://localhost:$port$path';
    if (Platform.isAndroid) return 'http://10.0.2.2:$port$path';

    return 'http://localhost:$port$path';
  }

  static String _withoutTrailingSlash(String url) =>
      url.endsWith('/') ? url.substring(0, url.length - 1) : url;
}
