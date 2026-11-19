import 'dart:async';
import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/custom_code/maintenance_status.dart';
import '/flutter_flow/flutter_flow_theme.dart';

/// The screen that replaces the app while it is under maintenance.
///
/// Drawn over whatever page is open by [ConnectionGate], with the back button turned off.
/// When the window has an end it counts down to it, and asks the server again the moment
/// it reaches zero so the app comes back without the person doing anything.
class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  final _status = MaintenanceStatus.instance;
  Timer? _tick;
  bool _checking = false;
  bool _askedAtZero = false;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final left = _status.info.value.remaining(DateTime.now());
      if (left != null && left == Duration.zero && !_askedAtZero) {
        // The window has run out on the server's clock; ask rather than assume.
        _askedAtZero = true;
        _status.check().whenComplete(() => _askedAtZero = false);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  Future<void> _retry() async {
    if (_checking) return;
    setState(() => _checking = true);
    await _status.check();
    if (mounted) setState(() => _checking = false);
  }

  /// `24:10`, or `1h 05m` once there is an hour or more, or `2d 3h` for a day or more.
  String _clock(Duration left) {
    String two(int n) => n.toString().padLeft(2, '0');
    if (left.inDays >= 1) return '${left.inDays}d ${left.inHours % 24}h';
    if (left.inHours >= 1)
      return '${left.inHours}h ${two(left.inMinutes % 60)}m';

    return '${two(left.inMinutes)}:${two(left.inSeconds % 60)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final info = _status.info.value;
    final left = info.remaining(DateTime.now());

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: theme.secondaryBackground,
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/under Maintance.png',
                width: 190,
                cacheWidth: 380,
                fit: BoxFit.contain,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Text(
                  'Under maintenance',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: -0.2,
                    height: 1.2,
                    color: theme.primaryBackground,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Text(
                    left == null
                        ? "We're making HAAT better. Please check back in a little while."
                        : "We're making HAAT better. It will be back on its own — no need to do anything.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      height: 1.5,
                      color: const Color(0xFF484848),
                    ),
                  ),
                ),
              ),
              if (left != null)
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: const Color(0xFFE3E5E9)),
                    ),
                    child: Text(
                      left == Duration.zero
                          ? 'Back any moment'
                          : 'Back in about ${_clock(left)}',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: theme.primaryBackground,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: _retry,
                  child: Container(
                    width: 180,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _checking
                          ? const Color(0xFF484848)
                          : theme.primaryBackground,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      _checking ? 'Checking…' : 'Check again',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: theme.primaryText,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
