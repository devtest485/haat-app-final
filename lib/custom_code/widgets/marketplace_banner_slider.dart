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

import 'dart:async';

import 'package:google_fonts/google_fonts.dart';

/// The full-bleed slides at the top of the Marketplace tab.
///
/// Each slide is its picture with, over it: a round logo, the headline, one
/// dot per slide (only when there is more than one) and a button as wide as
/// its words. Any of the logo, headline and button is left out when the slide
/// has none.
///
/// [banners] is the JSON list the page already holds; the paths say where in
/// each item every part is, so the same widget reads whatever shape the list
/// arrives in. A path may be written `$.imageUrl` or just `imageUrl`.
///
/// A tap opens the slide's link in the browser, or else its app screen by
/// route name.
class MarketplaceBannerSlider extends StatefulWidget {
  const MarketplaceBannerSlider({
    super.key,
    this.width,
    this.height,
    this.banners,
    this.imagePath,
    this.logoPath,
    this.titlePath,
    this.buttonPath,
    this.linkPath,
    this.routePath,
    this.contentBottomPadding,
    this.autoPlay,
  });

  final double? width;
  final double? height;
  final List<dynamic>? banners;
  final String? imagePath;
  final String? logoPath;
  final String? titlePath;
  final String? buttonPath;
  final String? linkPath;
  final String? routePath;

  /// Room left under the words, for whatever the page lays over the slides' foot.
  final double? contentBottomPadding;
  final bool? autoPlay;

  @override
  State<MarketplaceBannerSlider> createState() =>
      _MarketplaceBannerSliderState();
}

class _MarketplaceBannerSliderState extends State<MarketplaceBannerSlider> {
  static const _dwell = Duration(seconds: 4);
  static const _dark = Color(0xFF0B0F0D);

  PageController? _pages;
  Timer? _slide;
  int _count = 0;

  List<dynamic> get _banners => widget.banners ?? const [];

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  @override
  void didUpdateWidget(covariant MarketplaceBannerSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_banners.length != _count || widget.autoPlay != oldWidget.autoPlay) {
      _prepare();
    }
  }

  @override
  void dispose() {
    _slide?.cancel();
    _pages?.dispose();
    super.dispose();
  }

  /// A fresh controller whenever the number of slides changes, started far enough in
  /// that the slides wrap both ways.
  void _prepare() {
    _count = _banners.length;
    _pages?.dispose();
    _pages = _count > 1 ? PageController(initialPage: _count * 1000) : null;
    _startSliding();
  }

  /// Moves on every few seconds; restarted on every page change, so a slide just
  /// swiped to gets its full time.
  void _startSliding() {
    _slide?.cancel();
    if (_count < 2 || widget.autoPlay == false) return;

    _slide = Timer.periodic(_dwell, (_) {
      final pages = _pages;
      if (!mounted || pages == null || !pages.hasClients) return;

      pages.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  String _read(dynamic item, String? path, String fallback) {
    var key = (path ?? '').trim();
    if (key.isEmpty) key = fallback;
    if (!key.startsWith(r'$')) key = '\$.$key';

    return getJsonField(item, key)?.toString().trim() ?? '';
  }

  String _picture(dynamic item, String? path, String fallback) {
    final value = _read(item, path, fallback);
    return value.startsWith('/')
        ? '${FFDevEnvironmentValues().baseURL}$value'
        : value;
  }

  Future<void> _open(String link, String route) async {
    if (link.isNotEmpty) {
      await launchURL(link);
    } else if (route.isNotEmpty) {
      // A screen this build doesn't have yet is skipped rather than thrown.
      try {
        context.pushNamed(route);
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget body;

    if (_count == 0) {
      // Still loading, or nothing live: dark, so the page's white header still reads.
      body = Container(color: _dark);
    } else if (_count == 1) {
      body = _page(context, 0);
    } else {
      body = PageView.builder(
        controller: _pages,
        onPageChanged: (_) => _startSliding(),
        itemBuilder: (context, page) => _page(context, page % _count),
      );
    }

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: body,
    );
  }

  Widget _page(BuildContext context, int index) {
    final item = _banners[index];
    final image = _picture(item, widget.imagePath, 'imagePath');
    final logo = _picture(item, widget.logoPath, 'logoPath');
    final title = _read(item, widget.titlePath, 'title');
    final button = _read(item, widget.buttonPath, 'ctaLabel');
    final link = _read(item, widget.linkPath, 'actionUrl');
    final route = _read(item, widget.routePath, 'actionRoute');

    void open() => _open(link, route);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: open,
      child: Stack(
        fit: StackFit.expand,
        children: [
          image.isEmpty
              ? Container(color: _dark)
              : Image.network(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: _dark),
                ),
          // Keeps the header above and the words below readable on any picture.
          const IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.3, 0.45, 0.85],
                  colors: [
                    Color(0x59000000),
                    Color(0x00000000),
                    Color(0x00000000),
                    Color(0xE6000000),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: widget.contentBottomPadding ?? 56,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (logo.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ClipOval(
                      child: Image.network(
                        logo,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                if (title.isNotEmpty)
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      letterSpacing: -0.3,
                    ),
                  ),
                if (_count > 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var dot = 0; dot < _count; dot++)
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 2.5),
                            color: dot == index
                                ? Colors.white
                                : const Color(0x80FFFFFF),
                          ),
                      ],
                    ),
                  ),
                if (button.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Material(
                      color: const Color(0x82000000),
                      shape: const StadiumBorder(
                        side: BorderSide(color: Color(0x45FFFFFF)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: open,
                        child: Container(
                          height: 44,
                          constraints: const BoxConstraints(minWidth: 116),
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          // A Row, not an alignment, so the button hugs its words.
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  button,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the `</>` button on the right!
