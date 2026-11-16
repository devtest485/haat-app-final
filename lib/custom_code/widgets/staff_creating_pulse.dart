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

/// "Creating profile" mark for a new staff member: a solid green disc with the staff
/// initials in black and a plain black ring flush round it, breathing gently until the
/// page moves on. The mark is drawn at the centre of the box.
class StaffCreatingPulse extends StatefulWidget {
  const StaffCreatingPulse({
    super.key,
    this.width,
    this.height,
    this.initials,
  });

  final double? width;
  final double? height;
  final String? initials;

  @override
  State<StaffCreatingPulse> createState() => _StaffCreatingPulseState();
}

class _StaffCreatingPulseState extends State<StaffCreatingPulse>
    with SingleTickerProviderStateMixin {
  static const _disc = Color(0xFF01C552);

  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduceMotion && _loop.isAnimating) {
      _loop.stop();
    } else if (!reduceMotion && !_loop.isAnimating) {
      _loop.repeat(reverse: true);
    }

    final theme = FlutterFlowTheme.of(context);

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fallback = MediaQuery.sizeOf(context).width;
          final w =
              constraints.maxWidth.isFinite ? constraints.maxWidth : fallback;
          final h = constraints.maxHeight.isFinite ? constraints.maxHeight : w;
          final size = w < h ? w : h;
          final disc = size * 0.34;

          return Center(
            child: AnimatedBuilder(
              animation: _loop,
              builder: (context, child) => Transform.scale(
                scale: 1 + 0.04 * Curves.easeInOut.transform(_loop.value),
                child: child,
              ),
              child: Container(
                width: disc,
                height: disc,
                // The border is drawn inside the disc's own edge, so the ring sits
                // directly on the green with no gap.
                decoration: BoxDecoration(
                  color: _disc,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 3),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.initials ?? '',
                  maxLines: 1,
                  style: theme.bodyMedium.override(
                    font: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontStyle: theme.bodyMedium.fontStyle,
                    ),
                    color: Colors.black,
                    fontSize: disc * 0.4,
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w500,
                    fontStyle: theme.bodyMedium.fontStyle,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
