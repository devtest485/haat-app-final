import 'dart:async';

import 'package:flutter/widgets.dart';

import '/custom_code/api_client.dart';
import '/custom_code/token_store.dart';

/// Whether HAAT has been put under maintenance, and until when.
///
/// [MaintenanceStatus.instance.info] is what the maintenance screen follows.
class MaintenanceInfo {
  const MaintenanceInfo(
      {this.active = false, this.endsAt, this.skew = Duration.zero});

  /// Whether the app should be showing the maintenance screen.
  final bool active;

  /// When it ends by itself, in the server's time; null for one held until it is ended.
  final DateTime? endsAt;

  /// The server's clock minus this phone's, so a countdown is right on a phone whose
  /// clock is not.
  final Duration skew;

  /// Time left on this phone's clock, or null when there is no end to count to.
  Duration? remaining(DateTime now) {
    final end = endsAt;
    if (end == null) return null;
    final left = end.difference(now.add(skew));

    return left.isNegative ? Duration.zero : left;
  }
}

/// Asks the server whether the app is under maintenance.
///
/// No sign-in is needed — a merchant who is locked out must still be told why — so this
/// works from the first frame. Asked every [_every] while the app is open and as soon as
/// it comes back to the foreground. A failed ask keeps the last answer: no connection is
/// the no-internet screen's business, and flipping to "not under maintenance" because a
/// request timed out would let people back into an app that is being worked on.
class MaintenanceStatus {
  MaintenanceStatus._();

  static final MaintenanceStatus instance = MaintenanceStatus._();

  final ValueNotifier<MaintenanceInfo> info =
      ValueNotifier(const MaintenanceInfo());

  static const Duration _every = Duration(seconds: 20);

  Timer? _timer;
  AppLifecycleListener? _lifecycle;
  Future<void>? _checking;

  /// Starts watching. Safe to call more than once.
  void start() {
    if (_timer != null) return;

    _timer = Timer.periodic(_every, (_) => check());
    _lifecycle = AppLifecycleListener(
      onResume: () {
        check();
        _timer ??= Timer.periodic(_every, (_) => check());
      },
      // Nobody is looking at the app, so there is nothing to keep up to date.
      onPause: () {
        _timer?.cancel();
        _timer = null;
      },
    );
    check();
  }

  /// Asks now. Calls that land while an ask is running share it.
  Future<void> check() =>
      _checking ??= _ask().whenComplete(() => _checking = null);

  Future<void> _ask() async {
    final client = ApiClient(tokens: TokenStore());
    try {
      final result = await client.get<Map<String, dynamic>>(
        '/app/maintenance',
        authenticated: false,
        parse: (envelope) => envelope.object,
      );
      final data = result.valueOrNull;
      if (data == null) return;

      final ends = data['endsAt'] is String
          ? DateTime.tryParse(data['endsAt'] as String)
          : null;
      final server = data['serverTime'] is String
          ? DateTime.tryParse(data['serverTime'] as String)
          : null;
      final next = MaintenanceInfo(
        active: data['active'] == true,
        endsAt: ends,
        skew:
            server == null ? Duration.zero : server.difference(DateTime.now()),
      );

      final now = info.value;
      if (now.active != next.active || now.endsAt != next.endsAt)
        info.value = next;
    } catch (_) {
      // Keeps the last answer; see above.
    } finally {
      client.close();
    }
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _lifecycle?.dispose();
    _lifecycle = null;
  }
}
