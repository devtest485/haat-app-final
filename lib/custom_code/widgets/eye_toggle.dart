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

/// The show / hide mark for the balance: an open eye while the balance is shown, and when
/// it is hidden the lid closes over it into a thick curved line with a row of lashes
/// underneath. No border or button around it, just the drawing, in [color].
///
/// [closed] switches between the two, and the change plays as a short animation.
class EyeToggle extends StatefulWidget {
  const EyeToggle({
    super.key,
    this.width,
    this.height,
    this.closed,
    this.color,
  });

  final double? width;
  final double? height;
  final bool? closed;
  final Color? color;

  @override
  State<EyeToggle> createState() => _EyeToggleState();
}

class _EyeToggleState extends State<EyeToggle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
    value: widget.closed == true ? 1.0 : 0.0,
  );

  @override
  void didUpdateWidget(EyeToggle old) {
    super.didUpdateWidget(old);
    if (widget.closed == old.closed) return;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final target = widget.closed == true ? 1.0 : 0.0;
    if (reduceMotion) {
      _controller.value = target;
    } else {
      _controller.animateTo(target, curve: Curves.easeInOutCubic);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final side = widget.width ?? widget.height ?? 28.0;
    return SizedBox(
      width: widget.width ?? side,
      height: widget.height ?? side,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _EyePainter(
            t: _controller.value,
            color: widget.color ?? Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Draws the eye on a 24 x 24 grid scaled to the box. [t] is 0 for open, 1 for closed.
class _EyePainter extends CustomPainter {
  _EyePainter({required this.t, required this.color});

  final double t;
  final Color color;

  static double _lerp(double a, double b, double v) => a + (b - a) * v;

  @override
  void paint(Canvas canvas, Size size) {
    final u = size.shortestSide / 24.0;
    canvas.translate((size.width - 24 * u) / 2, (size.height - 24 * u) / 2);
    canvas.scale(u);

    // How far the lid has come down; the lashes grow in the second half.
    final lid = Curves.easeInOut.transform(t);
    final lashes =
        Curves.easeOut.transform(((t - 0.45) / 0.55).clamp(0.0, 1.0));

    const left = Offset(2.0, 11.0);
    const right = Offset(22.0, 11.0);
    // The control point of each lid's curve: the upper one swings from above the eye
    // to below it, the lower one comes up to meet it.
    final upperY = _lerp(0.0, 22.0, lid);
    const lowerY = 22.0;

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color
      ..strokeWidth = _lerp(1.9, 3.2, lid);

    final upper = Path()
      ..moveTo(left.dx, left.dy)
      ..quadraticBezierTo(12, upperY, right.dx, right.dy);
    final lower = Path()
      ..moveTo(left.dx, left.dy)
      ..quadraticBezierTo(12, lowerY, right.dx, right.dy);

    // The pupil fades as the lid comes down over it.
    final pupil = 1 - lid;
    if (pupil > 0.01) {
      canvas.drawCircle(
        const Offset(12, 11),
        _lerp(0.0, 3.2, pupil),
        Paint()..color = color.withValues(alpha: pupil),
      );
    }

    canvas.drawPath(upper, stroke);
    // Open, the lower lid completes the eye; closed, it is the same line as the upper
    // one, so it is only drawn while the eye is still open.
    if (lid < 0.999) canvas.drawPath(lower, stroke);

    // Lashes: five short strokes hanging from the closed lid, fanning outwards.
    if (lashes > 0.01) {
      final lash = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 2.2
        ..color = color.withValues(alpha: 0.55 * lashes);
      for (var i = 0; i < 5; i++) {
        final f = i / 4.0; // 0..1 along the lid
        final x = _lerp(5.0, 19.0, f);
        // A point on the lid's curve (quadratic bezier, control y = upperY).
        final p = _lerp(0.0, 1.0, (x - 2.0) / 20.0);
        final y = (1 - p) * (1 - p) * left.dy +
            2 * (1 - p) * p * upperY +
            p * p * right.dy;
        final angle = _lerp(-0.5, 0.5, f); // radians from straight down
        final length = 4.2 * lashes;
        final from = Offset(x, y + 1.4);
        final to = Offset(
          from.dx - length * math.sin(angle),
          from.dy + length * math.cos(angle),
        );
        canvas.drawLine(from, to, lash);
      }
    }
  }

  @override
  bool shouldRepaint(_EyePainter old) => old.t != t || old.color != color;
}
