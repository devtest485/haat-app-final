import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';

import '/custom_code/api_config.dart';

/// Whether the phone can reach HAAT at all.
///
/// Decided by opening a connection to the API's own host, not by asking the phone
/// whether Wi-Fi is on: Wi-Fi with no internet behind it is still no internet, and the
/// server is the only thing the app needs to reach.
///
/// Checked every [_every] while the app is open, as soon as it comes back to the
/// foreground, and whenever a request fails for want of a network.
class ConnectionStatus {
  ConnectionStatus._();

  static final ConnectionStatus instance = ConnectionStatus._();

  /// True while the server cannot be reached. The no-internet screen follows this.
  final ValueNotifier<bool> offline = ValueNotifier(false);

  static const Duration _every = Duration(seconds: 10);
  static const Duration _probeTimeout = Duration(seconds: 5);

  Timer? _timer;
  AppLifecycleListener? _lifecycle;
  Future<bool>? _checking;

  /// Starts watching. Safe to call more than once.
  void start() {
    if (_timer != null) return;

    _timer = Timer.periodic(_every, (_) => check());
    _lifecycle = AppLifecycleListener(
      onResume: () {
        check();
        _timer ??= Timer.periodic(_every, (_) => check());
      },
      // No reason to knock on the server while nobody is looking at the app.
      onPause: () {
        _timer?.cancel();
        _timer = null;
      },
    );
    check();
  }

  /// A request could not get through. One failed call is not proof — a train goes
  /// through a tunnel — so the server is tried once more before the screen changes.
  void reportUnreachable() => check();

  /// A response arrived, so the network is clearly there.
  void reportReachable() => offline.value = false;

  /// Tries the server now and updates [offline]. Returns true when it answered.
  ///
  /// Calls that land while a check is running share it rather than starting another.
  Future<bool> check() =>
      _checking ??= _probe().whenComplete(() => _checking = null);

  Future<bool> _probe() async {
    await ApiConfig.load();

    final uri = Uri.parse(ApiConfig.baseUrl);
    final port = uri.hasPort ? uri.port : (uri.scheme == 'https' ? 443 : 80);

    try {
      final socket =
          await Socket.connect(uri.host, port, timeout: _probeTimeout);
      socket.destroy();
      offline.value = false;

      return true;
    } catch (_) {
      offline.value = true;

      return false;
    }
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _lifecycle?.dispose();
    _lifecycle = null;
  }
}
