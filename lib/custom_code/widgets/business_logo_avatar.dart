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

// For `context.watch`, which FlutterFlow's pages get through their own imports and a
// custom widget has to ask for.
import 'package:provider/provider.dart';

/// HAAT's green, used for the badge that says the mark can be changed.
///
/// Written out rather than taken from the theme: this app's `primary` is
/// `0x4CFFFFFF` — a translucent white — and `alternate` is the same green at nine
/// per cent, so neither reads as the brand's green.
const _haatGreen = Color(0xFF00DA76);

/// What a business looks like before it has a logo of its own.
///
/// The brand's company mark, inside the same circle an uploaded logo gets, set in
/// from the edge so it reads as a mark rather than a cropped picture. It is drawn on
/// white because the artwork is green on transparency — on the brand's own green it
/// would disappear.
Widget _defaultMark(double size) => Padding(
      padding: EdgeInsets.all(size * 0.22),
      child: Image.asset(
        'assets/images/button_company_icon.png',
        fit: BoxFit.contain,
      ),
    );

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
    final size = widget.width ?? widget.height ?? 56;

    // Sized to the shorter side of whatever slot it is given, so the mark is always
    // a circle. The slot on the home screen is wider than it is tall — it held two
    // overlapping logos in the design — and asking for a square larger than its
    // height got one axis clamped and the other not: an oval.
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final available = [
            constraints.maxWidth,
            constraints.maxHeight,
          ].where((side) => side.isFinite);

          final side = available.isEmpty
              ? size
              : available.reduce((a, b) => a < b ? a : b);

          return _mark(context, url, side);
        },
      ),
    );
  }

  Widget _mark(BuildContext context, String url, double size) {
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
                      ? _defaultMark(size)
                      : Image.network(
                          url,
                          fit: BoxFit.cover,
                          // A broken address shows the default mark rather than a
                          // broken image, so a failed load never looks like a
                          // failed app.
                          errorBuilder: (_, __, ___) => _defaultMark(size),
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
                    // White on the badge, not the theme's `primary` — which in this
                    // app is a translucent white and left the badge a grey smudge on
                    // whatever was behind it.
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12, width: 1),
                  ),
                  child: Icon(
                    url.isEmpty ? Icons.add : Icons.edit,
                    size: size * 0.2,
                    color: _haatGreen,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
