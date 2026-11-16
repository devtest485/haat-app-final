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

import '/custom_code/pay_request_flow.dart';

/// The payment request's QR, the business's logo in its middle.
///
/// While the request is still being made it looks like a QR being generated: dots
/// appear gently, row by row from the top to the bottom, and the sweep loops until the
/// response arrives. When the request arrives the real QR is revealed from the top to
/// the bottom, the dots resolving into it. Built with a request already present, the
/// QR is shown at once.
class PayRequestQr extends StatefulWidget {
  const PayRequestQr({
    super.key,
    this.width,
    this.height,
    this.request,
  });

  final double? width;
  final double? height;
  final dynamic request;

  @override
  State<PayRequestQr> createState() => _PayRequestQrState();
}

enum _QrPhase { waiting, revealing, shown }

class _PayRequestQrState extends State<PayRequestQr>
    with TickerProviderStateMixin {
  // One sweep, a short hold and a fade, then round again.
  static const _loopDuration = Duration(milliseconds: 3000);
  static const _revealDuration = Duration(milliseconds: 700);

  late final AnimationController _loop;
  late final AnimationController _reveal;
  late _QrPhase _phase;
  bool _reduced = false;

  bool get _hasLink => payRequestField(widget.request, 'link').isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loop = AnimationController(vsync: this, duration: _loopDuration);
    _reveal = AnimationController(vsync: this, duration: _revealDuration);
    _phase = _hasLink ? _QrPhase.shown : _QrPhase.waiting;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduced = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    _syncLoop();
  }

  @override
  void didUpdateWidget(covariant PayRequestQr oldWidget) {
    super.didUpdateWidget(oldWidget);
    final hasLink = _hasLink;
    if (_phase == _QrPhase.waiting && hasLink) {
      if (_reduced) {
        _phase = _QrPhase.shown;
      } else {
        _phase = _QrPhase.revealing;
        _loop.stop();
        _reveal.forward(from: 0).whenComplete(() {
          if (mounted && _phase == _QrPhase.revealing) {
            setState(() => _phase = _QrPhase.shown);
          }
        });
      }
    } else if (_phase != _QrPhase.waiting && !hasLink) {
      _reveal.stop();
      _phase = _QrPhase.waiting;
    }
    _syncLoop();
  }

  void _syncLoop() {
    final shouldRun = _phase == _QrPhase.waiting && !_reduced;
    if (shouldRun && !_loop.isAnimating) {
      _loop.repeat();
    } else if (!shouldRun && _loop.isAnimating) {
      _loop.stop();
    }
  }

  @override
  void dispose() {
    _loop.dispose();
    _reveal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.width ?? 173;
    switch (_phase) {
      case _QrPhase.shown:
        return PayRequestQrView(request: widget.request, size: size);
      case _QrPhase.waiting:
        return RepaintBoundary(
          child: Semantics(
            label: 'Generating payment QR code',
            child: AnimatedBuilder(
              animation: _loop,
              builder: (context, _) => CustomPaint(
                size: Size.square(size),
                painter: _QrDotsPainter(
                  t: _reduced ? _QrDotsPainter.staticT : _loop.value,
                ),
              ),
            ),
          ),
        );
      case _QrPhase.revealing:
        // The dots settle to a full pattern while the real QR is wiped in over them,
        // from the top to the bottom, behind a soft edge.
        final qr = PayRequestQrView(request: widget.request, size: size);
        return RepaintBoundary(
          child: AnimatedBuilder(
            animation: _reveal,
            builder: (context, _) {
              final e = _reveal.value;
              final edge = Curves.easeInOutCubic.transform(e);
              return SizedBox.square(
                dimension: size,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CustomPaint(
                      painter: _QrDotsPainter(
                        t: _loop.value,
                        fill: (e / 0.3).clamp(0.0, 1.0),
                      ),
                    ),
                    ShaderMask(
                      blendMode: BlendMode.dstIn,
                      shaderCallback: (bounds) {
                        const soft = 0.22;
                        final y1 = (edge * (1 + soft)).clamp(0.0, 1.0);
                        final y0 = (edge * (1 + soft) - soft).clamp(0.0, 1.0);
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: const [
                            Color(0xFFFFFFFF),
                            Color(0xFFFFFFFF),
                            Color(0x00FFFFFF),
                            Color(0x00FFFFFF),
                          ],
                          stops: [0.0, y0, y1, 1.0],
                        ).createShader(bounds);
                      },
                      child: qr,
                    ),
                  ],
                ),
              );
            },
          ),
        );
    }
  }
}

/// A plain field of small dots, not a QR: the dots appear row by row from the top as [t]
/// goes round 0..1, softly, while the request is being made. Nothing in it looks like a
/// code, so only the real QR is ever shown as one.
class _QrDotsPainter extends CustomPainter {
  const _QrDotsPainter({required this.t, this.fill = 0});

  /// A moment in the loop when every row is shown, for the still placeholder.
  static const staticT = 0.8;

  static const _n = 29;
  static const _sweepEnd = 0.733; // ~2.2 s of the 3 s loop
  static const _rowSpan = 0.26; // how long one row takes to come in
  static const _fadeStart = 0.9;
  static const _ink = Color(0xFF111111);
  static const _logoFraction = 0.3; // as the real QR's logo

  final double t;

  /// 0..1: rows brought to full whatever [t] says (the dots settling before a reveal).
  final double fill;

  double _rowValue(int row) {
    final start = row / (_n - 1) * (_sweepEnd - _rowSpan);
    final a =
        Curves.easeOut.transform(((t - start) / _rowSpan).clamp(0.0, 1.0));
    final out = t > _fadeStart
        ? 1 - Curves.easeInOut.transform((t - _fadeStart) / (1 - _fadeStart))
        : 1.0;
    final v = a * out;
    return v > fill ? v : fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.width / _n;
    canvas.drawRect(Offset.zero & size, Paint()..color = Colors.white);

    final mid = size.center(Offset.zero);
    // The logo's spot stays clear, as on the real QR.
    final clear = size.width * _logoFraction / 2 + 6 + c * 0.8;
    final dot = Paint();
    for (var y = 0; y < _n; y++) {
      final v = _rowValue(y);
      if (v <= 0.01) continue;
      dot.color = _ink.withValues(alpha: 0.5 * v);
      final r = c * (0.1 + 0.16 * v);
      for (var x = 0; x < _n; x++) {
        final centre = Offset((x + 0.5) * c, (y + 0.5) * c);
        if ((centre - mid).distance < clear) continue;
        canvas.drawCircle(centre, r, dot);
      }
    }
  }

  @override
  bool shouldRepaint(_QrDotsPainter old) => old.t != t || old.fill != fill;
}
