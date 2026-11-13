// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math' as math;

/// Tap to Pay status mark: a black disc with the contactless glyph inside four
/// green rings that pulse outward while the phone waits for a card.
///
/// [phase] is `waiting` (default), `paid` (disc turns green, a check pops in,
/// the rings flash once) or `rejected` (disc turns red, shakes, a cross shows
/// and the rings go red). The mark is always drawn at the centre of its box,
/// and the outer rings may run past the box edges.
class TapToPayPulse extends StatefulWidget {
  const TapToPayPulse({
    super.key,
    this.width,
    this.height,
    this.phase,
  });

  final double? width;
  final double? height;
  final String? phase;

  @override
  State<TapToPayPulse> createState() => _TapToPayPulseState();
}

class _TapToPayPulseState extends State<TapToPayPulse>
    with TickerProviderStateMixin {
  static const _green = Color(0xFF00DA76);
  static const _paid = Color(0xFF01C552);
  static const _error = Color(0xFFFF3128);

  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2000),
  )..repeat();

  late final AnimationController _outcome = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  );

  String get _phase {
    final phase = (widget.phase ?? '').trim();
    return phase == 'paid' || phase == 'rejected' ? phase : 'waiting';
  }

  @override
  void initState() {
    super.initState();
    if (_phase != 'waiting') _outcome.value = 1;
  }

  @override
  void didUpdateWidget(covariant TapToPayPulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    final was = (oldWidget.phase ?? '').trim();
    if (was == (widget.phase ?? '').trim()) return;
    if (_phase == 'waiting') {
      _outcome.value = 0;
      if (!_loop.isAnimating) _loop.repeat();
    } else {
      _outcome.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _loop.dispose();
    _outcome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion && _loop.isAnimating) _loop.stop();

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;
          // 92 px disc on a 375 pt phone, a little more on larger ones.
          final unit = (width / 450).clamp(0.8, 1.15);

          return AnimatedBuilder(
            animation: Listenable.merge([_loop, _outcome]),
            builder: (context, _) {
              final phase = _phase;
              final t = _outcome.value;
              final discColor = phase == 'waiting'
                  ? Colors.black
                  : Color.lerp(Colors.black, phase == 'paid' ? _paid : _error,
                      _ease(t / 0.09))!;

              // Breathe while waiting; pop on paid; shake on rejected.
              var discScale = 1.0 + 0.03 * _wave(_loop.value);
              var shake = 0.0;
              if (phase == 'paid') {
                discScale = t < 0.13
                    ? 1.0 + 0.16 * Curves.easeOutBack.transform(t / 0.13)
                    : 1.16 - 0.08 * _ease((t - 0.13) / 0.13);
              } else if (phase == 'rejected') {
                final s = ((t - 0.33) / 0.2).clamp(0.0, 1.0);
                shake = s == 0 || s == 1
                    ? 0
                    : math.sin(s * math.pi * 6) * 6 * (1 - s) * unit;
                discScale = 1.0;
              }

              final disc = 110 * unit;
              final glyphOpacity =
                  phase == 'waiting' ? 1.0 : 1 - _ease(t / 0.07);
              final markScale = phase == 'waiting'
                  ? 0.0
                  : Curves.easeOutBack
                      .transform(((t - 0.05) / 0.2).clamp(0.0, 1.0));

              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _RingsPainter(
                        unit: unit,
                        loop: reduceMotion ? 0.0 : _loop.value,
                        phase: phase,
                        outcome: t,
                        green: _green,
                        error: _error,
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(shake, 0),
                    child: Transform.scale(
                      scale: discScale,
                      child: Container(
                        width: disc,
                        height: disc,
                        decoration: BoxDecoration(
                          color: discColor,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: glyphOpacity.clamp(0.0, 1.0),
                              child: Icon(
                                Icons.contactless_outlined,
                                color: _green,
                                size: 44 * unit,
                              ),
                            ),
                            if (phase != 'waiting')
                              Transform.scale(
                                scale: markScale,
                                child: Icon(
                                  phase == 'paid'
                                      ? Icons.check_rounded
                                      : Icons.close_rounded,
                                  color: phase == 'paid'
                                      ? const Color(0xFF111111)
                                      : Colors.white,
                                  size: 46 * unit,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  static double _ease(double v) =>
      Curves.easeOutCubic.transform(v.clamp(0.0, 1.0));

  /// 0 → 1 → 0 over one loop.
  static double _wave(double v) => (1 - math.cos(v * 2 * math.pi)) / 2;
}

class _RingsPainter extends CustomPainter {
  _RingsPainter({
    required this.unit,
    required this.loop,
    required this.phase,
    required this.outcome,
    required this.green,
    required this.error,
  });

  final double unit;
  final double loop;
  final String phase;
  final double outcome;
  final Color green;
  final Color error;

  static const _diameters = [180.0, 340.0, 510.0, 700.0];

  @override
  void paint(Canvas canvas, Size size) {
    final centre = size.center(Offset.zero);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var i = 0; i < _diameters.length; i++) {
      // Each ring lights up a beat after the one inside it.
      double glow;
      double grow;
      if (phase == 'waiting') {
        final local = (loop - (0.2 + 0.1 * i)) % 1.0;
        glow = local < 0.12
            ? Curves.easeOut.transform(local / 0.12)
            : local < 0.34
                ? 1 - Curves.easeInOut.transform((local - 0.12) / 0.22)
                : 0.0;
        grow = 1 + 0.04 * glow;
      } else {
        final local = ((outcome - (0.07 + 0.07 * i)) / 0.35).clamp(0.0, 1.0);
        glow = local < 0.3
            ? Curves.easeOut.transform(local / 0.3)
            : 1 - Curves.easeInOut.transform((local - 0.3) / 0.7);
        grow = 1 + 0.06 * glow;
      }

      final colour = phase == 'rejected'
          ? Color.lerp(green, error, (outcome / 0.25).clamp(0.0, 1.0))!
          : green;
      stroke.color = colour.withOpacity(0.12 + 0.18 * glow);
      canvas.drawCircle(centre, _diameters[i] / 2 * unit * grow, stroke);
    }

    // A soft wave leaves the disc each loop while waiting.
    if (phase == 'waiting') {
      final r0 = 55 * unit;
      final r1 = _diameters.last / 2 * unit;
      final p = Curves.easeOut.transform(loop);
      stroke
        ..strokeWidth = 1.5
        ..color = green.withOpacity(0.28 * (1 - p));
      canvas.drawCircle(centre, r0 + (r1 - r0) * p, stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _RingsPainter old) =>
      old.loop != loop ||
      old.outcome != outcome ||
      old.phase != phase ||
      old.unit != unit;
}
