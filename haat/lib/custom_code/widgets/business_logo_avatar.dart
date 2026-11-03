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

/// What a business looks like before it has a logo of its own.
///
/// The brand's company mark, inside the same circle an uploaded logo gets, set in
/// from the edge so it reads as a mark rather than a cropped picture. It is drawn on
/// white because the artwork is green on transparency — on the brand's own green it
/// would disappear.
Widget _defaultMark(double size) => Padding(
      padding: EdgeInsets.all(size * 0.10),
      child: Image.asset(
        'assets/images/button_company_icon.png',
        fit: BoxFit.contain,
      ),
    );

/// The business's logo, from App State businessLogoUrl, with a storefront
/// placeholder until there is one.
///
/// Tapping it opens the picker and uploads the choice through
/// haatPickBusinessLogo.
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
    // Logo ke ird-gird safed ring ki motai.
    final ringWidth = size * 0.03;
    // Badge (pencil wala circle) ka size aur uska mota black border.
    final badgeSize = size * 0.34;
    final badgeBorder = size * 0.03;

    return SizedBox(
      width: size,
      height: size,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: _change,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Logo + safed ring.
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.white, width: ringWidth),
              ),
              child: ClipOval(
                child: Container(
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
            // Badge: safed circle, mota black border, andar black pencil.
            // Logo set hone ke baad bhi rehta hai taake badalne ka raasta nazar aaye.
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: badgeSize,
                height: badgeSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: badgeBorder,
                  ),
                ),
                child: Icon(
                  url.isEmpty ? Icons.add : Icons.edit,
                  size: size * 0.2,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
