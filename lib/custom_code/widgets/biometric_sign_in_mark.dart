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

/// The fingerprint mark at the top of the sign-in screen, as the design shows it:
/// the sensor while the prompt is up or can be raised again, a tick once the
/// signature is accepted.
///
/// Only the drawing lives here. Whether it is shown, when the prompt is raised and
/// where a signed-in merchant goes are all the page's own state and actions, so they
/// stay editable in FlutterFlow. It is a custom widget at all for one reason: it sits
/// over the artwork at the top of a full-bleed page, and has to keep clear of the
/// status bar and the notch — which needs a `SafeArea`, and FlutterFlow offers that
/// only for a whole page.
///
/// Tapping it raises the prompt again for somebody who dismissed it.
class BiometricSignInMark extends StatefulWidget {
  const BiometricSignInMark({
    super.key,
    this.width,
    this.height,
    this.done,
    this.onTap,
  });

  final double? width;
  final double? height;

  /// True once the fingerprint was accepted — the mark turns into a tick.
  final bool? done;

  /// Raises the prompt again.
  final Future Function()? onTap;

  @override
  State<BiometricSignInMark> createState() => _BiometricSignInMarkState();
}

class _BiometricSignInMarkState extends State<BiometricSignInMark> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const AlignmentDirectional(0.0, -1.0),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
          child: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              await widget.onTap?.call();
            },
            child: Container(
              width: 110.0,
              height: 110.0,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(26.0),
              ),
              alignment: const AlignmentDirectional(0.0, 0.0),
              child: Icon(
                (widget.done ?? false)
                    ? Icons.check_circle_outline_rounded
                    : Icons.fingerprint_rounded,
                color: const Color(0xFFA6E59D),
                size: 60.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
