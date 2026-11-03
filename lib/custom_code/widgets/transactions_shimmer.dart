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
import 'dart:ui' as ui;

/// The transactions list while it loads.
///
/// Laid out like the real list — day groups of two, two and one rows, each a date
/// label over a white card, with the same gaps — so nothing jumps when the data
/// arrives. A highlight sweeps across each row a moment after the row above it, and
/// every row is a little fainter than the one before, so the list trails off.
class TransactionsShimmer extends StatefulWidget {
  const TransactionsShimmer({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<TransactionsShimmer> createState() => _TransactionsShimmerState();
}

class _TransactionsShimmerState extends State<TransactionsShimmer>
    with SingleTickerProviderStateMixin {
  // Rows per day group, top to bottom.
  static const _groups = [2, 2, 1];

  static const _base = Color(0xFFDDDDDD);
  static const _highlight = Color(0xFFF5F5F5);

  // How long the highlight takes to cross one row, and how far behind the row above
  // each row starts (as a share of the cycle).
  static const _cycle = Duration(milliseconds: 900);
  static const _stagger = 0.1;

  late final AnimationController _controller =
      AnimationController(vsync: this, duration: _cycle)..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _rowCount => _groups.fold(0, (sum, rows) => sum + rows);

  // 1.0 for the first row down to 0.5 for the last — fainter, never gone.
  double _opacity(int index) =>
      1.0 - 0.5 * index / (_rowCount > 1 ? _rowCount - 1 : 1);

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final card = FlutterFlowTheme.of(context).primaryText;

    var row = 0;
    final groups = <Widget>[];
    for (var g = 0; g < _groups.length; g++) {
      final first = row;
      final rows = List.generate(_groups[g], (i) => first + i);
      row += _groups[g];

      groups.add(Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date label, sitting on the page like the real one.
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4.0),
            child: _Shimmering(
              controller: _controller,
              offset: first * _stagger,
              animate: !reduceMotion,
              opacity: _opacity(first),
              // Full width, so the band crosses it at the same pace as the rows.
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: _Bar(width: g == 0 ? 84.0 : 68.0, height: 12.0),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(
              color: card,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final i in rows)
                  _Shimmering(
                    controller: _controller,
                    offset: i * _stagger,
                    animate: !reduceMotion,
                    opacity: _opacity(i),
                    // Vary the widths a little so the rows don't read as a grid
                    // of identical stripes.
                    child: _ShimmerRow(
                      titleWidth: 72.0 + (i * 37 % 4) * 14.0,
                      subtitleWidth: 54.0 + (i % 2) * 12.0,
                      amountWidth: 112.0 + (i * 53 % 3) * 18.0,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ));
    }

    return Semantics(
      label: 'Loading transactions',
      child: SizedBox(
        width: widget.width ?? double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: groups.divide(const SizedBox(height: 20.0)),
        ),
      ),
    );
  }
}

/// Paints [child]'s shapes with a tilted band of light sliding left to right
/// across them.
///
/// Only the child's own pixels are tinted (srcATop), so a row's bars shimmer while
/// the white card behind them stays white. The band is sized in pixels rather
/// than as a share of the child, so it looks and moves the same on every row.
class _Shimmering extends StatelessWidget {
  // Width of the band of light, and how far it leans off vertical.
  static const _band = 150.0;
  static const _tilt = 20 * math.pi / 180;

  const _Shimmering({
    required this.controller,
    required this.offset,
    required this.animate,
    required this.opacity,
    required this.child,
  });

  final AnimationController controller;
  final double offset;
  final bool animate;
  final double opacity;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: AnimatedBuilder(
        animation: controller,
        child: child,
        builder: (context, child) {
          final t = animate ? (controller.value - offset) % 1.0 : 0.0;

          return ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              // The band's centre travels from well left of the row to well past
              // it, so it starts and ends out of sight and rests between passes.
              final from = -_band * 1.5;
              final to = bounds.width + _band * 1.5;
              final centre = Offset(from + (to - from) * t, bounds.height / 2);
              // The gradient runs across the band; tilting that direction down by
              // [_tilt] leans the band itself over like "/".
              final half = Offset(math.cos(_tilt), math.sin(_tilt)) * (_band / 2);

              return ui.Gradient.linear(
                centre - half,
                centre + half,
                const [
                  _TransactionsShimmerState._base,
                  _TransactionsShimmerState._highlight,
                  _TransactionsShimmerState._base,
                ],
                const [0.0, 0.5, 1.0],
              );
            },
            child: child,
          );
        },
      ),
    );
  }
}

class _ShimmerRow extends StatelessWidget {
  const _ShimmerRow({
    required this.titleWidth,
    required this.subtitleWidth,
    required this.amountWidth,
  });

  final double titleWidth;
  final double subtitleWidth;
  final double amountWidth;

  @override
  Widget build(BuildContext context) {
    // Laid out like TransactionsWidget, a little taller so the placeholders read
    // clearly at a glance.
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(5.0, 10.0, 5.0, 10.0),
      child: Row(
        children: [
          Container(
            width: 36.0,
            height: 36.0,
            decoration: const BoxDecoration(
              color: _TransactionsShimmerState._base,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: SizedBox(
              height: 44.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Bar(width: titleWidth, height: 14.0),
                  const SizedBox(height: 10.0),
                  _Bar(width: subtitleWidth, height: 12.0),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12.0),
          _Bar(width: amountWidth, height: 14.0),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: _TransactionsShimmerState._base,
          borderRadius: BorderRadius.circular(height / 2),
        ),
      );
}
