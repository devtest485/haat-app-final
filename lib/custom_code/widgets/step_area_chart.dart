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

import 'package:google_fonts/google_fonts.dart';

class StepAreaChart extends StatefulWidget {
  const StepAreaChart({
    super.key,
    this.width,
    this.height,
    this.values,
    this.labels,
    this.selectedIndex,
    this.selectedPeriod,
    this.onPeriodChanged,
    this.onBarSelected,
  });

  final double? width;
  final double? height;
  final List<double>? values;
  final List<String>? labels;
  final int? selectedIndex;
  final String? selectedPeriod;
  final Future Function(String period)? onPeriodChanged;
  final Future Function(int index)? onBarSelected;

  @override
  State<StepAreaChart> createState() => _StepAreaChartState();
}

class _StepAreaChartState extends State<StepAreaChart>
    with SingleTickerProviderStateMixin {
  // Design colors
  static const _bgColor = Color(0xFF000000);
  static const _labelColor = Color(0xFF6E6E6E);
  static const _labelSelectedColor = Color(0xFFFFFFFF);
  static const _pillBg = Color(0xFF2C2C2C);
  static const _pillBorder = Color(0xFF5A5A5A);

  // Layout fractions (375 x 346 design se nikale hue)
  // Sab se unchi value yahan aati hai. Jitna chhota number, utni lambi lines
  // (0.211 = pehle wali height, 0.10 = ab). Aur lambi chahiye to 0.06 try karo.
  static const double _chartTopFrac = 0.10;
  static const double _chartBottomFrac = 0.70; // fill yahan tak fade hota hai
  static const double _labelsTopFrac = 0.60;
  static const double _pillsTopFrac = 0.74;

  static const _defaultValues = <double>[184, 359, 106, 233, 142, 390, 150];
  static const _defaultLabels = <String>[
    'Sat',
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri'
  ];
  static const _periods = <String>['Day', 'Week', 'Month'];

  late int _selectedIndex;
  late String _period;

  /// Line draw animation (0 -> 1). Har baar period / values badalne par restart.
  late final AnimationController _anim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  List<double> get _values => (widget.values == null || widget.values!.isEmpty)
      ? _defaultValues
      : widget.values!;

  List<String> get _labels => (widget.labels == null || widget.labels!.isEmpty)
      ? _defaultLabels
      : widget.labels!;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ?? 5;
    _period = widget.selectedPeriod ?? 'Week';
    // Pehli baar bhi line left se draw hoti hui aaye
    _anim.forward(from: 0);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  static bool _sameList(List<double>? a, List<double>? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null) {
      return (a?.isEmpty ?? true) && (b?.isEmpty ?? true);
    }
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  void didUpdateWidget(covariant StepAreaChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex &&
        widget.selectedIndex != null) {
      _selectedIndex = widget.selectedIndex!;
    }
    if (widget.selectedPeriod != oldWidget.selectedPeriod &&
        widget.selectedPeriod != null) {
      _period = widget.selectedPeriod!;
    }
    // Nayi values aayi (jaise Week -> Month) to animation dobara chalao
    if (!_sameList(widget.values, oldWidget.values)) {
      _anim.forward(from: 0);
    }
  }

  double _resolve(
      double? given, double bounded, bool hasBounded, double design) {
    if (given != null && given.isFinite) return given;
    if (hasBounded && bounded.isFinite) return bounded;
    return design;
  }

  void _selectIndex(int index) {
    final count = _values.length;
    if (count == 0) return;
    final safe = index.clamp(0, count - 1);
    if (safe == _selectedIndex) return;
    setState(() => _selectedIndex = safe);
    widget.onBarSelected?.call(safe);
  }

  void _selectPeriod(String period) {
    if (period == _period) return;
    setState(() => _period = period);
    _anim.forward(from: 0);
    widget.onPeriodChanged?.call(period);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = _resolve(widget.width, constraints.maxWidth,
            constraints.hasBoundedWidth, 375);
        final h = _resolve(widget.height, constraints.maxHeight,
            constraints.hasBoundedHeight, 346);

        final chartTop = h * _chartTopFrac;
        final chartBottom = h * _chartBottomFrac;
        final count = _values.length;
        final colW = w / count;

        return Container(
          width: w,
          height: h,
          color: _bgColor,
          child: Stack(
            children: [
              // Chart (line + gradient fill)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTapDown: (d) => _selectIndex(
                      (d.localPosition.dx / colW).floor().clamp(0, count - 1)),
                  child: AnimatedBuilder(
                    animation: _anim,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _StepAreaPainter(
                          values: _values,
                          topInset: chartTop,
                          bottom: chartBottom,
                          progress:
                              Curves.easeInOutCubic.transform(_anim.value),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Day labels
              Positioned(
                left: 0,
                right: 0,
                top: h * _labelsTopFrac,
                child: Row(
                  children: List.generate(count, (i) {
                    final selected = i == _selectedIndex;
                    final text = i < _labels.length ? _labels[i] : '';
                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _selectIndex(i),
                        child: Center(
                          child: Text(
                            text,
                            maxLines: 1,
                            style: GoogleFonts.outfit(
                              fontSize: 11,
                              fontWeight:
                                  selected ? FontWeight.w800 : FontWeight.w600,
                              color:
                                  selected ? _labelSelectedColor : _labelColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // Day / Week / Month pills
              Positioned(
                left: 0,
                right: 0,
                top: h * _pillsTopFrac,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < _periods.length; i++) ...[
                      if (i > 0) const SizedBox(width: 4),
                      _buildPill(_periods[i]),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPill(String text) {
    final selected = _period == text;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _selectPeriod(text),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.white : _pillBg,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: selected ? Colors.white : _pillBorder,
            width: 1,
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            color: selected ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}

class _StepAreaPainter extends CustomPainter {
  _StepAreaPainter({
    required this.values,
    required this.topInset,
    required this.bottom,
    required this.progress,
  });

  final List<double> values;
  final double topInset;
  final double bottom;

  /// 0 = kuch nahi dikhta, 1 = poori line aur fill.
  final double progress;

  // Figma: Border -> Linear Gradient #00FF89 (100%) se #00FF89 (0% opacity)
  static const _lineTop = Color(0xFF00FF89);
  static const _lineBottom = Color(0x0000FF89);

  // Figma: Fill -> Linear Gradient #00DA76 se #00743F (0% opacity)
  // Upar wali stop ki opacity screenshot me nahi thi, isliye 35% rakhi hai
  // (0x59). Image se match na ho to sirf ye alpha badlo (0x40 = kam, 0x80 = zyada).
  static const _fillTop = Color(0x5900DA76);
  static const _fillBottom = Color(0x0000743F);

  static const _markerColor = Color(0xFF2E9E4F);

  @override
  void paint(Canvas canvas, Size size) {
    final n = values.length;
    if (n == 0) return;

    double maxV = values.reduce((a, b) => a > b ? a : b);
    if (maxV <= 0) maxV = 1;

    final colW = size.width / n;
    double yOf(double v) {
      final clamped = v < 0 ? 0.0 : v;
      return topInset + (1 - clamped / maxV) * (bottom - topInset);
    }

    // Step line: horizontal, phir seedha upar/neeche, phir horizontal ...
    final line = Path()..moveTo(0, yOf(values[0]));
    for (int i = 0; i < n; i++) {
      final y = yOf(values[i]);
      if (i > 0) line.lineTo(i * colW, y);
      line.lineTo((i + 1) * colW, y);
    }

    final gradientRect = Rect.fromLTRB(0, topInset, size.width, bottom);
    final p = progress.clamp(0.0, 1.0);
    if (p <= 0) return;

    // Line ka kitna hissa draw hua aur uski nok (tip) kahan hai
    Path visibleLine = line;
    Offset tip = Offset(size.width, yOf(values[n - 1]));
    if (p < 1) {
      final metrics = line.computeMetrics().toList();
      if (metrics.isEmpty) return;
      final metric = metrics.first;
      final drawLen = metric.length * p;
      visibleLine = metric.extractPath(0, drawLen);
      tip = metric.getTangentForOffset(drawLen)?.position ?? tip;
    }

    // Gradient fill — sirf us x tak jahan tak line pahunchi hai
    final fill = Path.from(line)
      ..lineTo(size.width, bottom)
      ..lineTo(0, bottom)
      ..close();

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [_fillTop, _fillBottom],
      ).createShader(gradientRect);

    canvas.save();
    canvas.clipRect(
        Rect.fromLTRB(0, 0, p < 1 ? tip.dx : size.width, size.height));
    canvas.drawPath(fill, fillPaint);
    canvas.restore();

    // Line (upar bright green, neeche dim green)
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeJoin = StrokeJoin.miter
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [_lineTop, _lineBottom],
      ).createShader(gradientRect);
    canvas.drawPath(visibleLine, linePaint);

    // Chota sa square marker (design me pehle step ke end par hai)
    if (n > 1 && (p >= 1 || tip.dx >= colW)) {
      final markerPaint = Paint()..color = _markerColor;
      canvas.drawRect(
        Rect.fromCenter(
            center: Offset(colW, yOf(values[0])), width: 6, height: 6),
        markerPaint,
      );
    }

    // Draw hote waqt nok par halka glow wala dot (aakhir me fade ho jata hai)
    if (p < 1) {
      final fade = p > 0.9 ? (1 - p) / 0.1 : 1.0;
      final glow = Paint()
        ..color = _lineTop.withValues(alpha: 0.55 * fade)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawCircle(tip, 6, glow);
      canvas.drawCircle(
        tip,
        2.5,
        Paint()..color = const Color(0xFFB8FFD9).withValues(alpha: fade),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StepAreaPainter old) {
    return old.values != values ||
        old.topInset != topInset ||
        old.bottom != bottom ||
        old.progress != progress;
  }
}
