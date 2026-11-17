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

/// The top of a brand's store screen: [colorHex] at the top, fading to white, with the
/// HAAT pattern showing through it.
///
/// The colour comes from the back office (`brandColor`, picked from its palette), so a new
/// brand needs no new picture. The pattern is one transparent overlay, `BrandPattern.png`:
/// the pattern's strokes in black at a low opacity, so it shades whatever colour is under it
/// instead of carrying a colour of its own. [colorHex] that is empty or not `#RRGGBB` draws
/// a neutral grey.
class BrandHeaderBackdrop extends StatefulWidget {
  const BrandHeaderBackdrop({
    super.key,
    this.width,
    this.height,
    this.colorHex,
  });

  final double? width;
  final double? height;
  final String? colorHex;

  @override
  State<BrandHeaderBackdrop> createState() => _BrandHeaderBackdropState();
}

class _BrandHeaderBackdropState extends State<BrandHeaderBackdrop> {
  static const Color _fallback = Color(0xFF8C8C8C);

  static Color _parse(String? hex) {
    final digits = (hex ?? '').trim().replaceFirst('#', '');
    if (digits.length != 6) return _fallback;
    final value = int.tryParse(digits, radix: 16);

    return value == null ? _fallback : Color(0xFF000000 | value);
  }

  @override
  Widget build(BuildContext context) {
    final base = _parse(widget.colorHex);

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  base,
                  Color.lerp(base, Colors.white, 0.55)!,
                  Colors.white,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
          Image.asset(
            'assets/images/BrandPattern.png',
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ],
      ),
    );
  }
}
