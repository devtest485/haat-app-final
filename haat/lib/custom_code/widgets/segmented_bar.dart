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

/// Segmented percentage bar (QR / Tap to Pay / Payment links wali upar ki line).
///
/// FlutterFlow me parameters:
///   width, height   -> double  (default 343 x 10)
///   values          -> List<double>  (jaise [693, 398, 193] ya [54, 31, 15])
///   colors          -> List<Color>   (har value ka color)
///   gap             -> double  (segments ke beech ka fasla, default 2)
class SegmentedBar extends StatelessWidget {
  const SegmentedBar({
    super.key,
    this.width,
    this.height,
    this.values,
    this.colors,
    this.gap,
  });

  final double? width;
  final double? height;
  final List<double>? values;
  final List<Color>? colors;
  final double? gap;

  static const _defaultValues = <double>[54, 31, 15];
  static const _defaultColors = <Color>[
    Color(0xFF000000),
    Color(0xFF60D880),
    Color(0xFFBEBEBE),
  ];

  double _resolve(
      double? given, double bounded, bool hasBounded, double design) {
    if (given != null && given.isFinite) return given;
    if (hasBounded && bounded.isFinite) return bounded;
    return design;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = _resolve(
            width, constraints.maxWidth, constraints.hasBoundedWidth, 343);
        final h = (height != null && height!.isFinite && height! > 0)
            ? height!
            : 10.0;
        final g = (gap != null && gap!.isFinite && gap! >= 0) ? gap! : 2.0;

        final vals =
            (values == null || values!.isEmpty) ? _defaultValues : values!;
        final cols =
            (colors == null || colors!.isEmpty) ? _defaultColors : colors!;

        // Sirf wo segments jin ki value > 0 hai
        final visible = <int>[];
        for (int i = 0; i < vals.length; i++) {
          if (vals[i] > 0) visible.add(i);
        }

        if (visible.isEmpty) {
          return SizedBox(width: w, height: h);
        }

        final total = visible.fold<double>(0, (s, i) => s + vals[i]);
        final available = (w - g * (visible.length - 1)).clamp(0.0, w);
        final radius = Radius.circular(h / 2);

        final children = <Widget>[];
        for (int k = 0; k < visible.length; k++) {
          final i = visible[k];
          final isFirst = k == 0;
          final isLast = k == visible.length - 1;
          final segW = available * (vals[i] / total);

          if (k > 0) children.add(SizedBox(width: g));

          children.add(
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              width: segW,
              height: h,
              decoration: BoxDecoration(
                color: cols[i % cols.length],
                borderRadius: BorderRadius.only(
                  topLeft: isFirst ? radius : Radius.zero,
                  bottomLeft: isFirst ? radius : Radius.zero,
                  topRight: isLast ? radius : Radius.zero,
                  bottomRight: isLast ? radius : Radius.zero,
                ),
              ),
            ),
          );
        }

        return SizedBox(
          width: w,
          height: h,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: children,
          ),
        );
      },
    );
  }
}
