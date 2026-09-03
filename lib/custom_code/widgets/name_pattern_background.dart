// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:google_fonts/google_fonts.dart';

class NamePatternBackground extends StatefulWidget {
  const NamePatternBackground({
    super.key,
    this.width,
    this.height,
    this.name,
    this.fallbackName,
    this.textColor,
    this.backgroundColor,
    this.fadeColor,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.rotationDegrees,
    this.lineSpacing,
    this.wordSpacing,
    this.rowShift,
    this.mirrorAlternate,
    this.lowercase,
    this.fadeStart,
    this.fadeEnd,
    this.animate,
    this.secondsPerWord,
    this.patternHeight,
    this.showContent,
    this.titlePrefix,
    this.titleSuffix,
    this.subtitle,
    this.buttonLabel,
    this.onButtonTap,
  });

  final double? width;
  final double? height;

  /// UsernamePage se aaya user ka naam (page ka `userName` param).
  final String? name;

  /// Naam na mile to yeh dikhta hai.
  final String? fallbackName;

  /// Pattern ke text ka rang (design: theme Tertiary = #00DA76).
  final Color? textColor;

  /// Pattern ke peeche ka rang (design: #0A0F0C).
  final Color? backgroundColor;

  /// Neeche wale fade ka rang (design me pure black).
  final Color? fadeColor;

  /// Null ho to width ka 0.155 (375px par ~58px, asset jitna).
  final double? fontSize;

  /// 100 se 900 tak (default 800 — asset jitna mota).
  final int? fontWeight;

  /// Google Font ka naam (default 'Kufam' — pattern ke HTML wala font).
  final String? fontFamily;

  final double? rotationDegrees;

  /// Row pitch, font size ka multiplier.
  final double? lineSpacing;

  /// Do words ke darmiyan gap, font size ka multiplier.
  final double? wordSpacing;

  /// Har agli row kitni daaye shift ho, font size ka multiplier.
  final double? rowShift;

  /// Alternate word ulta (mirror) likha jaye ya nahi.
  final bool? mirrorAlternate;

  /// Naam chhote letters me (design me lowercase hai).
  final bool? lowercase;

  /// Fade kahan se shuru ho (0-1, pattern block ki height ka hissa).
  final double? fadeStart;

  /// Fade kahan mukammal black ho jaye (0-1).
  final double? fadeEnd;

  /// Pattern move kare (default: nahi, static rehta hai).
  final bool? animate;

  /// Move on ho to ek word ka safar kitne second me.
  final double? secondsPerWord;

  /// Pattern block ki height — null ho to page height ka 65.4% (design).
  final double? patternHeight;

  /// Title, subtitle aur button dikhane hain (default: haan). Off karne par
  /// sirf background pattern banta hai.
  final bool? showContent;

  /// Title ka naam se pehle wala hissa.
  final String? titlePrefix;

  /// Title ka naam ke baad wala hissa.
  final String? titleSuffix;

  final String? subtitle;
  final String? buttonLabel;

  /// Button dabane par kya karna hai (page se action pass hoti hai).
  final Future Function()? onButtonTap;

  // Asset/design se naapi gayi default values.
  static const String kFallbackName = 'haat';
  static const String kFontFamily = 'Kufam';
  static const Color kTextColor = Color(0xFF00DA76);
  static const Color kBackgroundColor = Color(0xFF0A0F0C);
  static const double kFontSizeFactor = 0.155;
  static const int kFontWeight = 800;
  static const double kRotationDegrees = 19.4;
  static const double kLineSpacing = 0.87;
  static const double kWordSpacing = 0.23;
  static const double kRowShift = 0.30;
  static const double kFadeStart = 0.3644;
  static const double kFadeEnd = 0.8343;
  static const double kSecondsPerWord = 9.0;

  static const double kPatternFraction = 0.654; // 531 / 812
  static const double kTextMaxWidth = 326.0;
  static const double kButtonMaxWidth = 327.0;
  static const double kSidePadding = 24.0;
  static const double kTitleSubtitleGap = 14.0;
  static const double kTextToButtonGap = 56.0;
  static const double kBottomGap = 44.0;
  static const double kButtonHeight = 50.0;

  static const String kTitlePrefix = 'Great one ';
  static const String kTitleSuffix = ', your user account created.';
  static const String kSubtitle =
      'Your business account and digital store has been successfully created';
  static const String kButtonLabel = 'Finish';

  @override
  State<NamePatternBackground> createState() => _NamePatternBackgroundState();
}

class _NamePatternBackgroundState extends State<NamePatternBackground>
    with SingleTickerProviderStateMixin {
  static const Map<int, FontWeight> _weights = {
    100: FontWeight.w100,
    200: FontWeight.w200,
    300: FontWeight.w300,
    400: FontWeight.w400,
    500: FontWeight.w500,
    600: FontWeight.w600,
    700: FontWeight.w700,
    800: FontWeight.w800,
    900: FontWeight.w900,
  };

  /// Sirf letters, numbers aur space rehne dete hain — baqi (@, #, $, !,
  /// emoji, symbols waghera) hata dete hain taake pattern ya title me
  /// koi ajeeb character na dikhe.
  static final RegExp _specialCharsPattern =
      RegExp(r'[^\p{L}\p{N}\s]', unicode: true);

  static String _sanitize(String input) {
    return input.replaceAll(_specialCharsPattern, '').trim();
  }

  late AnimationController _controller;

  /// Jab tak Google Font poori tarah load (download/cache) nahi ho jata,
  /// pattern text nahi dikhate — is se "pehle chota font phir bada font"
  /// wala jump (FOUC) khatam ho jata hai. Sirf background + fade dikhta
  /// rehta hai is dauran, aur font ready hote hi ek hi size me text aata
  /// hai.
  bool _fontReady = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _loopDuration);
    if (widget.animate ?? false) {
      _controller.repeat();
    }
    _preloadFont();
  }

  @override
  void didUpdateWidget(NamePatternBackground old) {
    super.didUpdateWidget(old);
    if (old.secondsPerWord != widget.secondsPerWord) {
      _controller.duration = _loopDuration;
    }
    final shouldRun = widget.animate ?? false;
    if (shouldRun && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!shouldRun && _controller.isAnimating) {
      _controller.stop();
    }
    // Font family badal jaye (rare case) to dobara preload karo.
    if (old.fontFamily != widget.fontFamily ||
        old.fontWeight != widget.fontWeight) {
      _fontReady = false;
      _preloadFont();
    }
  }

  /// Target font ko explicitly fetch/cache karta hai aur jab tak wo
  /// mukammal load na ho jaye tab tak wait karta hai. FlutterFlow me
  /// asset-bundled font available ho to wo turant milta hai (koi jump
  /// nahi), warna network se download hone tak text hide rehta hai.
  Future<void> _preloadFont() async {
    final family = (widget.fontFamily ?? '').trim().isEmpty
        ? NamePatternBackground.kFontFamily
        : widget.fontFamily!.trim();
    final weight =
        _weights[widget.fontWeight ?? NamePatternBackground.kFontWeight] ??
            FontWeight.w800;

    try {
      // Isse font request trigger hoti hai (agar pehle se cached/loaded
      // nahi hai) — GoogleFonts.pendingFonts() ise track karta hai.
      GoogleFonts.getFont(family, fontWeight: weight);
      await GoogleFonts.pendingFonts();
    } catch (_) {
      // Font load fail ho (no internet waghera) to bhi aage barh jao,
      // fallback font se hi sahi, hamesha ke liye hidden nahi rehna.
    }

    if (mounted) {
      setState(() => _fontReady = true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Loop do word ka hai — is se mirror ki tarteeb waisi hi rehti hai.
  Duration get _loopDuration {
    final perWord =
        widget.secondsPerWord ?? NamePatternBackground.kSecondsPerWord;
    final seconds = perWord.isFinite && perWord > 0
        ? perWord
        : NamePatternBackground.kSecondsPerWord;
    return Duration(milliseconds: (seconds * 2 * 1000).round());
  }

  /// Naam chunne ki tarteeb: param → fallbackName → 'haat'. Har hissa
  /// pehle special-character-free hota hai (@ hatane ke sath sath baqi
  /// symbols/emoji bhi).
  String get _name {
    final given = _sanitize((widget.name ?? '').replaceAll('@', ''));
    if (given.isNotEmpty) return given;
    final fallback = _sanitize((widget.fallbackName ?? '').replaceAll('@', ''));
    if (fallback.isNotEmpty) return fallback;
    return NamePatternBackground.kFallbackName;
  }

  /// Pattern ka font. `GoogleFonts.getFont` naam se font leta hai, is liye
  /// google_fonts ke kisi bhi version par chalta hai. Font na mile to normal
  /// font par gir jata hai — layout waisa hi rehta hai.
  TextStyle _patternStyle(double size, FontWeight weight) {
    final family = (widget.fontFamily ?? '').trim().isEmpty
        ? NamePatternBackground.kFontFamily
        : widget.fontFamily!.trim();
    final color = widget.textColor ?? NamePatternBackground.kTextColor;
    try {
      return GoogleFonts.getFont(
        family,
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: 1.0,
      );
    } catch (_) {
      return TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: 1.0,
      );
    }
  }

  /// Pehli finite value: diya gaya size → constraint → screen.
  double _resolveSize(double? given, double constraint, double screen) {
    if (given != null && given.isFinite && given > 0) return given;
    if (constraint.isFinite && constraint > 0) return constraint;
    return screen;
  }

  @override
  Widget build(BuildContext context) {
    final name = _name;
    final word = (widget.lowercase ?? true) ? name.toLowerCase() : name;
    final weight =
        _weights[widget.fontWeight ?? NamePatternBackground.kFontWeight] ??
            FontWeight.w800;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screen = MediaQuery.sizeOf(context);
        // width/height me double.infinity bhi aa sakti hai (FlutterFlow me aam
        // hai), is liye pehle constraints, phir screen par gir jao.
        final boxWidth =
            _resolveSize(widget.width, constraints.maxWidth, screen.width);
        final boxHeight =
            _resolveSize(widget.height, constraints.maxHeight, screen.height);
        final patternBox = widget.patternHeight ??
            boxHeight * NamePatternBackground.kPatternFraction;
        final size =
            widget.fontSize ?? boxWidth * NamePatternBackground.kFontSizeFactor;

        return SizedBox(
          width: boxWidth,
          height: boxHeight,
          child: Stack(
            children: [
              // Background: user ke naam ka diagonal pattern.
              Positioned(
                top: 0.0,
                left: 0.0,
                right: 0.0,
                height: patternBox,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) => CustomPaint(
                    size: Size(boxWidth, patternBox),
                    painter: _NamePatternPainter(
                      // Font ready hone tak khali string bhejte hain —
                      // sirf background + fade dikhta hai, koi size-jump
                      // wala flash nahi hota.
                      word: _fontReady ? word : '',
                      style: _patternStyle(size, weight),
                      backgroundColor: widget.backgroundColor ??
                          NamePatternBackground.kBackgroundColor,
                      fadeColor: widget.fadeColor ?? Colors.black,
                      angle: (widget.rotationDegrees ??
                              NamePatternBackground.kRotationDegrees) *
                          math.pi /
                          180.0,
                      rowPitch: size *
                          (widget.lineSpacing ??
                              NamePatternBackground.kLineSpacing),
                      wordGap: size *
                          (widget.wordSpacing ??
                              NamePatternBackground.kWordSpacing),
                      shiftPerRow: size *
                          (widget.rowShift ?? NamePatternBackground.kRowShift),
                      mirror: widget.mirrorAlternate ?? true,
                      fadeStart:
                          widget.fadeStart ?? NamePatternBackground.kFadeStart,
                      fadeEnd: widget.fadeEnd ?? NamePatternBackground.kFadeEnd,
                      phase: _controller.value,
                    ),
                  ),
                ),
              ),
              if (widget.showContent ?? true)
                Positioned.fill(child: _buildContent(context, name)),
            ],
          ),
        );
      },
    );
  }

  /// Title + subtitle + button — design ke mutabiq neeche se anchor.
  Widget _buildContent(BuildContext context, String name) {
    final titleStyle = FlutterFlowTheme.of(context).bodyMedium.override(
          font: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          ),
          color: FlutterFlowTheme.of(context).primaryText,
          fontSize: 24.0,
          letterSpacing: -0.24,
          fontWeight: FontWeight.w500,
          lineHeight: 1.13,
        );

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(child: SizedBox.shrink()),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            NamePatternBackground.kSidePadding,
            0.0,
            NamePatternBackground.kSidePadding,
            0.0,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: NamePatternBackground.kTextMaxWidth,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    textScaler: MediaQuery.of(context).textScaler,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: titleStyle,
                      children: [
                        TextSpan(
                          text: widget.titlePrefix ??
                              NamePatternBackground.kTitlePrefix,
                        ),
                        TextSpan(text: name),
                        TextSpan(
                          text: widget.titleSuffix ??
                              NamePatternBackground.kTitleSuffix,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: NamePatternBackground.kTitleSubtitleGap),
                  Text(
                    widget.subtitle ?? NamePatternBackground.kSubtitle,
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.normal,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: Color(0xFFEBEBEB),
                          fontSize: 13.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.normal,
                          lineHeight: 1.54,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: NamePatternBackground.kTextToButtonGap),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            NamePatternBackground.kSidePadding,
            0.0,
            NamePatternBackground.kSidePadding,
            0.0,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: NamePatternBackground.kButtonMaxWidth,
              ),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  await widget.onButtonTap?.call();
                },
                child: Container(
                  width: double.infinity,
                  height: NamePatternBackground.kButtonHeight,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryText,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 18.4,
                        color: Color(0x0F000000),
                        offset: Offset(0.0, 7.0),
                      )
                    ],
                    borderRadius: BorderRadius.circular(106.67),
                  ),
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Text(
                    widget.buttonLabel ?? NamePatternBackground.kButtonLabel,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w600,
                          lineHeight: 1.44,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: NamePatternBackground.kBottomGap),
      ],
    );
  }
}

/// Naam ko tirchhi rows me repeat karta hai. Tarteeb: background fill →
/// rotate kar ke words → upar se black fade.
class _NamePatternPainter extends CustomPainter {
  _NamePatternPainter({
    required this.word,
    required this.style,
    required this.backgroundColor,
    required this.fadeColor,
    required this.angle,
    required this.rowPitch,
    required this.wordGap,
    required this.shiftPerRow,
    required this.mirror,
    required this.fadeStart,
    required this.fadeEnd,
    required this.phase,
  });

  final String word;
  final TextStyle style;
  final Color backgroundColor;
  final Color fadeColor;
  final double angle;
  final double rowPitch;
  final double wordGap;
  final double shiftPerRow;
  final bool mirror;
  final double fadeStart;
  final double fadeEnd;

  /// 0 se 1 — do word ka safar, is liye loop me jhatka nahi lagta.
  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final bounds = Offset.zero & size;
    canvas.clipRect(bounds);
    canvas.drawRect(bounds, Paint()..color = backgroundColor);

    if (word.isNotEmpty && rowPitch > 0) {
      final painter = TextPainter(
        text: TextSpan(text: word, style: style),
        textDirection: ui.TextDirection.ltr,
        maxLines: 1,
      )..layout();

      final wordWidth = painter.width;
      final slot = wordWidth + wordGap;

      if (slot > 0) {
        // Rotated frame me poora block cover karne ke liye kitna chalna hai.
        final cos = math.cos(angle).abs();
        final sin = math.sin(angle).abs();
        final halfAlong = (size.width * cos + size.height * sin) / 2 + slot;
        final halfAcross =
            (size.width * sin + size.height * cos) / 2 + rowPitch;

        final rows = (2 * halfAcross / rowPitch).ceil();
        final columns = (2 * halfAlong / slot).ceil() + 4;
        final drift = phase * 2 * slot;

        canvas.save();
        canvas.translate(size.width / 2, size.height / 2);
        canvas.rotate(angle);

        for (var row = 0; row <= rows; row++) {
          final across = -halfAcross + row * rowPitch;
          // Do slot ka modulo — is se checkerboard ki parity nahi tootti.
          final offset = (row * shiftPerRow + drift) % (2 * slot);

          for (var column = 0; column <= columns; column++) {
            final along = -halfAlong - 2 * slot + offset + column * slot;
            final flipped = mirror && (row + column) % 2 != 0;

            if (flipped) {
              canvas.save();
              canvas.translate(along + wordWidth / 2, across);
              canvas.scale(-1.0, 1.0);
              painter.paint(canvas, Offset(-wordWidth / 2, 0.0));
              canvas.restore();
            } else {
              painter.paint(canvas, Offset(along, across));
            }
          }
        }

        canvas.restore();
      }

      painter.dispose();
    }

    // CSS wala gradient: shuru me transparent, neeche pura black.
    final start = fadeStart.clamp(0.0, 1.0);
    final end = fadeEnd.clamp(start, 1.0);
    if (end > 0.0) {
      final fade = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [fadeColor.withAlpha(0), fadeColor.withAlpha(255)],
        stops: [start, end],
      ).createShader(bounds);
      canvas.drawRect(bounds, Paint()..shader = fade);
    }
  }

  @override
  bool shouldRepaint(_NamePatternPainter old) =>
      old.word != word ||
      old.style != style ||
      old.backgroundColor != backgroundColor ||
      old.fadeColor != fadeColor ||
      old.angle != angle ||
      old.rowPitch != rowPitch ||
      old.wordGap != wordGap ||
      old.shiftPerRow != shiftPerRow ||
      old.mirror != mirror ||
      old.fadeStart != fadeStart ||
      old.fadeEnd != fadeEnd ||
      old.phase != phase;
}
