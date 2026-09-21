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

/// The business's own logo, which the merchant can tap to change.
///
/// This replaced two copies of a pizza shop's logo that the design had put in the
/// corner of the home screen — a placeholder, bundled into the app and shown to every
/// merchant as though it were theirs.
///
/// ## What it shows
///
/// The logo at `businessLogoUrl` once there is one. Until then, a storefront mark and
/// an add badge — something that is obviously *not* a logo, so a merchant reads it as
/// a place to put one rather than mistaking it for somebody else's.
///
/// ## Why it is a custom widget
///
/// FlutterFlow's image takes a fixed path. This needs an address that changes when the
/// merchant uploads, a fallback when there is none, and a tap that opens the picker —
/// three things the designed image could not do between them.
class BusinessLogoAvatar extends StatefulWidget {
  const BusinessLogoAvatar({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<BusinessLogoAvatar> createState() => _BusinessLogoAvatarState();
}

class _BusinessLogoAvatarState extends State<BusinessLogoAvatar> {
  bool _uploading = false;

  Future<void> _change() async {
    if (_uploading) return;

    setState(() => _uploading = true);
    final problem = await haatPickBusinessLogo();
    if (!mounted) return;
    setState(() => _uploading = false);

    if (problem.isNotEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(problem)));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watched, so an upload finishing elsewhere — or the profile load on the page
    // underneath — redraws this without anyone having to tell it.
    final url = context.watch<FFAppState>().businessLogoUrl;
    final theme = FlutterFlowTheme.of(context);
    final size = widget.width ?? widget.height ?? 56;

    return SizedBox(
      width: size,
      height: size,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: _change,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            ClipOval(
              child: Container(
                width: size,
                height: size,
                color: Colors.white,
                child: url.isEmpty
                    ? Icon(Icons.storefront_outlined,
                        size: size * 0.5, color: Colors.black54)
                    : Image.network(
                        url,
                        fit: BoxFit.cover,
                        // A broken address shows the storefront rather than a broken
                        // image, so a failed load never looks like a failed app.
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.storefront_outlined,
                          size: size * 0.5,
                          color: Colors.black54,
                        ),
                      ),
              ),
            ),
            if (_uploading)
              Positioned.fill(
                child: ClipOval(
                  child: Container(
                    color: Colors.black45,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: size * 0.4,
                      height: size * 0.4,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
              ),
            // The badge says "this can be changed" without a word of copy. Kept once
            // a logo is set, smaller, so the way to change it stays discoverable.
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: size * 0.34,
                height: size * 0.34,
                decoration: BoxDecoration(
                  color: theme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  url.isEmpty ? Icons.add : Icons.edit,
                  size: size * 0.2,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
