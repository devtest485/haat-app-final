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

/// The show / hide mark for the balance: a plain outline eye while the balance is shown,
/// and the same eye with a slash across it when it is hidden. No border or button around
/// it, just the drawing, in [color].
///
/// [closed] switches between the two, and the slash draws itself in or out as a short
/// animation.
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
    duration: const Duration(milliseconds: 260),
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
      _controller.animateTo(target, curve: Curves.easeInOut);
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

  @override
  void paint(Canvas canvas, Size size) {
    final u = size.shortestSide / 24.0;
    canvas.translate((size.width - 24 * u) / 2, (size.height - 24 * u) / 2);
    canvas.scale(u);

    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color
      ..strokeWidth = 1.8;

    // Plain outline eye: an almond with a ring for the iris.
    final eye = Path()
      ..moveTo(1.5, 12)
      ..cubicTo(4.5, 6.2, 8.0, 4.5, 12, 4.5)
      ..cubicTo(16.0, 4.5, 19.5, 6.2, 22.5, 12)
      ..cubicTo(19.5, 17.8, 16.0, 19.5, 12, 19.5)
      ..cubicTo(8.0, 19.5, 4.5, 17.8, 1.5, 12)
      ..close();
    canvas.drawPath(eye, stroke);
    canvas.drawCircle(const Offset(12, 12), 3.4, stroke);

    // The slash crosses the eye when the balance is hidden: it draws itself from the
    // top-left corner down to the bottom-right as [t] goes to 1, and back out again.
    final draw = Curves.easeInOut.transform(t);
    if (draw > 0.01) {
      const from = Offset(3.5, 3.5);
      const to = Offset(20.5, 20.5);
      canvas.drawLine(from, Offset.lerp(from, to, draw)!, stroke);
    }
  }

  @override
  bool shouldRepaint(_EyePainter old) => old.t != t || old.color != color;
}
