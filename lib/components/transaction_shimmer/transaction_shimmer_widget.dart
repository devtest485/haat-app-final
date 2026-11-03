import '/flutter_flow/flutter_flow_util.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'transaction_shimmer_model.dart';
export 'transaction_shimmer_model.dart';

/// One line of the transactions list while it loads.
///
/// Laid out like `TransactionsWidget` — icon circle, title over subtitle, amount on
/// the right, hairline under it — so nothing jumps when the real rows arrive. A band
/// of light sweeps across the shapes; [index] starts each row a moment after the one
/// above it and varies the bar widths so a stack of them doesn't read as a grid.
class TransactionShimmerWidget extends StatefulWidget {
  const TransactionShimmerWidget({
    super.key,
    this.index = 0,
    this.showDivider = true,
  });

  final int index;
  final bool showDivider;

  @override
  State<TransactionShimmerWidget> createState() =>
      _TransactionShimmerWidgetState();
}

class _TransactionShimmerWidgetState extends State<TransactionShimmerWidget>
    with SingleTickerProviderStateMixin {
  static const _base = Color(0xFFE6E6E6);
  static const _highlight = Color(0xFFF7F7F7);

  // Width of the band of light, and how far it leans off vertical.
  static const _band = 150.0;
  static const _tilt = 20 * math.pi / 180;

  late TransactionShimmerModel _model;

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TransactionShimmerModel());
  }

  @override
  void dispose() {
    _controller.dispose();
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animate = !MediaQuery.disableAnimationsOf(context);
    final i = widget.index;

    return Semantics(
      label: 'Loading transaction',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final t = animate ? (_controller.value - i * 0.12) % 1.0 : 0.0;

              // Only the bars and circle take the light (srcATop); the card behind
              // them stays white.
              return ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (bounds) {
                  // The band starts and ends out of sight, so it rests between
                  // passes.
                  final from = -_band * 1.5;
                  final to = bounds.width + _band * 1.5;
                  final centre =
                      Offset(from + (to - from) * t, bounds.height / 2);
                  final half =
                      Offset(math.cos(_tilt), math.sin(_tilt)) * (_band / 2);

                  return ui.Gradient.linear(
                    centre - half,
                    centre + half,
                    const [_base, _highlight, _base],
                    const [0.0, 0.5, 1.0],
                  );
                },
                child: child,
              );
            },
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(5.0, 8.0, 5.0, 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 32.0,
                    height: 32.0,
                    decoration: BoxDecoration(
                      color: _base,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    // Same height as a title line over a subtitle line.
                    child: SizedBox(
                      height: 40.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _bar(width: 120.0 + (i * 37 % 3) * 18.0, height: 12.0),
                          _bar(width: 84.0 + (i % 2) * 14.0, height: 10.0),
                        ].divide(SizedBox(height: 8.0)),
                      ),
                    ),
                  ),
                  _bar(width: 76.0 + (i * 53 % 3) * 10.0, height: 24.0),
                ].divide(SizedBox(width: 12.0)),
              ),
            ),
          ),
          if (widget.showDivider)
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: Color(0x14000000),
            ),
        ],
      ),
    );
  }

  Widget _bar({required double width, required double height}) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: _base,
          borderRadius: BorderRadius.circular(height / 2),
        ),
      );
}
