// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// For `context.watch`, which FlutterFlow's pages get through their own imports and a
// custom widget has to ask for.
import 'package:provider/provider.dart';

/// The same default the home screen shows before a logo exists: the brand's company
/// mark on white, inside the circle an uploaded logo would fill. See
/// [BusinessLogoAvatar] for why it is drawn on white.
Widget _defaultMark(double size) => Padding(
      padding: EdgeInsets.all(size * 0.22),
      child: Image.asset(
        'assets/images/button_company_icon.png',
        fit: BoxFit.contain,
      ),
    );

/// The business's logo, shown and nothing more.
///
/// The same picture as [BusinessLogoAvatar] without the tap: this is used where
/// nobody is signed in, and a picker that opened there could only fail — a logo
/// belongs to a business, and uploading one needs a session.
///
/// It stands where the design put a pizza shop's logo, which was bundled into the
/// app and shown on the sign-in screen of every merchant who had never sold a pizza.
///
/// `businessLogoUrl` is deliberately not persisted, so on a cold start this is the
/// storefront mark rather than the last merchant's logo — which is the right answer
/// on a handset that has changed hands.
class BusinessLogoMark extends StatelessWidget {
  const BusinessLogoMark({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final url = context.watch<FFAppState>().businessLogoUrl;
    final size = width ?? height ?? 120;

    return SizedBox(
      width: size,
      height: size,
      child: ClipOval(
        child: Container(
          width: size,
          height: size,
          color: Colors.white,
          child: url.isEmpty
              ? _defaultMark(size)
              : Image.network(
                  url,
                  fit: BoxFit.cover,
                  // A broken address shows the default mark rather than a broken
                  // image, so a failed load never looks like a failed app.
                  errorBuilder: (_, __, ___) => _defaultMark(size),
                ),
        ),
      ),
    );
  }
}
