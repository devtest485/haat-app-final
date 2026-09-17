import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
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

  /// FlutterFlow owns this file and writes it from the Dev Environments UI, where
  /// the value is named `baseURL`. Reading that name rather than our own is what
  /// keeps the app pointed at the real backend across an export.
  static const String _configKey = 'baseURL';

  /// The name this file used before it was reconciled with FlutterFlow's. Read as a
  /// fallback so a build carrying the older asset still resolves.
  static const String _legacyConfigKey = 'apiBaseUrl';
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

  /// True once a base URL has been read from the environment file.
  ///
  /// False means the build fell back to [_developmentDefault], which is worth knowing:
  /// a release build pointed at the developer's own machine reaches nobody.
  static bool get isConfigured => _configured;

  static bool _configured = false;

  static Future<void>? _loading;

  /// Reads the configured base URL, once.
  ///
  /// Safe to call from anywhere, as often as you like: concurrent callers share a
  /// single read of the asset instead of each opening it. Every request awaits this,
  /// so the app reaches the configured server whether or not startup got to it first
  /// — FlutterFlow regenerates `main.dart`, and a base URL that depended on an edit
  /// surviving that would quietly revert to localhost on the next export.
  static Future<void> load() => _loading ??= _read();

  /// Which server a build talks to is the first thing worth checking when nothing
  /// works, so the answer is announced rather than inferred. An environment file that
  /// has lost its `apiBaseUrl` key falls back to localhost **silently** otherwise —
  /// and a phone talking to its own localhost looks exactly like a backend that is down.
  static Future<void> _read() async {
    final configured = await _fromAssets();

    _configured = configured != null;
    _baseUrl = configured ?? _developmentDefault;

    debugPrint(
      _configured
          ? 'ApiConfig: $_baseUrl'
          : 'ApiConfig: $_baseUrl — no "$_configKey" in $_configPath, using the local fallback',
    );
  }

  static Future<String?> _fromAssets() async {
    try {
      final decoded = json.decode(await rootBundle.loadString(_configPath));
      if (decoded is! Map) return null;

      final configured = decoded[_configKey] ?? decoded[_legacyConfigKey];
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
