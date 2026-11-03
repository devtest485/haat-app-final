import 'dart:async';

import 'package:flutter/material.dart';

import '/components/no_internet_widget.dart';
import '/custom_code/connection_status.dart';
import '/flutter_flow/nav/nav.dart';

/// Puts the no-internet screen over whatever page is open while HAAT cannot be
/// reached, and takes it away again when it can.
///
/// The screen goes into the navigator's overlay rather than around the app, so
/// FlutterFlow keeps `main.dart`. The page underneath is kept as it was — a half-typed
/// amount is still there when the connection comes back.
class ConnectionGate {
  ConnectionGate._();

  static final _status = ConnectionStatus.instance;
  static OverlayEntry? _entry;
  static bool _started = false;

  /// Starts watching. Called once, from the app's start-up action.
  static void start() {
    if (_started) return;
    _started = true;
    _status.offline.addListener(_changed);
    _status.start();
  }

  static void _changed() => _status.offline.value ? _show() : _hide();

  static void _show() {
    if (_entry != null) return;

    final overlay = appNavigatorKey.currentState?.overlay;
    if (overlay == null) {
      // The first frame is not up yet: try again once it is.
      Timer(Duration(milliseconds: 300), () {
        if (_status.offline.value) _show();
      });
      return;
    }

    // A keyboard left open under the screen would push it around.
    FocusManager.instance.primaryFocus?.unfocus();
    _entry = OverlayEntry(
      builder: (_) => Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: NoInternetWidget(onRetry: () async {
            await _status.check();
          }),
        ),
      ),
    );
    overlay.insert(_entry!);
  }

  static void _hide() {
    _entry?.remove();
    _entry = null;
  }
}
