import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/components/no_internet_widget.dart';
import '/custom_code/connection_status.dart';
import '/custom_code/maintenance_screen.dart';
import '/custom_code/maintenance_status.dart';
import '/flutter_flow/nav/nav.dart';

/// Puts a full-screen notice over whatever page is open when the app cannot be used:
/// the no-internet screen while HAAT cannot be reached, and the maintenance screen while
/// the back office has the app under maintenance. Each goes away again by itself.
///
/// The screens go into the navigator's overlay rather than around the app, so
/// FlutterFlow keeps `main.dart`. The page underneath is kept as it was — a half-typed
/// amount is still there when the connection comes back.
///
/// Both cover the whole screen, status bar and navigation bar included, and swallow the
/// back button: there is nowhere to go back to from a notice that says the app cannot
/// be used. No internet is laid over maintenance when both apply, since without a
/// connection maintenance cannot even be asked.
class ConnectionGate {
  ConnectionGate._();

  static final _status = ConnectionStatus.instance;
  static final _maintenance = MaintenanceStatus.instance;
  static OverlayEntry? _entry;
  static OverlayEntry? _maintenanceEntry;
  static bool _started = false;

  /// Starts watching. Called once, from the app's start-up action.
  static void start() {
    if (_started) return;
    _started = true;
    _status.offline.addListener(_changed);
    _maintenance.info.addListener(_maintenanceChanged);
    _status.start();
    _maintenance.start();
  }

  static void _changed() => _status.offline.value ? _show() : _hide();

  static void _maintenanceChanged() =>
      _maintenance.info.value.active ? _showMaintenance() : _hideMaintenance();

  /// Wraps a notice so it fills the screen and owns the back button.
  static Widget _cover(Widget child) => BackButtonListener(
        // Handled, so the page underneath is neither popped nor the app closed.
        onBackButtonPressed: () async => true,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: Color(0xFFF4F4F6),
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: Material(
            type: MaterialType.canvas,
            color: const Color(0xFFF4F4F6),
            child: SizedBox.expand(child: child),
          ),
        ),
      );

  /// The navigator's overlay, or null — in which case [again] is tried once the first
  /// frame is up, if [still] holds by then.
  static OverlayState? _overlay(void Function() again, bool Function() still) {
    final overlay = appNavigatorKey.currentState?.overlay;
    if (overlay == null) {
      Timer(const Duration(milliseconds: 300), () {
        if (still()) again();
      });
    }

    return overlay;
  }

  static void _show() {
    if (_entry != null) return;

    final overlay = _overlay(_show, () => _status.offline.value);
    if (overlay == null) return;

    // A keyboard left open under the screen would push it around.
    FocusManager.instance.primaryFocus?.unfocus();
    _entry = OverlayEntry(
      builder: (_) => _cover(
        NoInternetWidget(onRetry: () async {
          await _status.check();
        }),
      ),
    );
    overlay.insert(_entry!);
  }

  static void _hide() {
    _entry?.remove();
    _entry = null;
  }

  static void _showMaintenance() {
    if (_maintenanceEntry != null) return;

    final overlay =
        _overlay(_showMaintenance, () => _maintenance.info.value.active);
    if (overlay == null) return;

    FocusManager.instance.primaryFocus?.unfocus();
    _maintenanceEntry =
        OverlayEntry(builder: (_) => _cover(const MaintenanceScreen()));
    // Under the no-internet screen when that is up too.
    if (_entry != null) {
      overlay.insert(_maintenanceEntry!, below: _entry);
    } else {
      overlay.insert(_maintenanceEntry!);
    }
  }

  static void _hideMaintenance() {
    _maintenanceEntry?.remove();
    _maintenanceEntry = null;
  }
}
