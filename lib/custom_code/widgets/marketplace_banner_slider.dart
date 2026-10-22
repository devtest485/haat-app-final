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
import 'dart:ui' show PointerDeviceKind;

import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

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
///
/// Android aur iOS dono par chalne ke liye: * size kabhi infinite nahi hota
/// (Column / ScrollView ke andar bhi safe), * PageController ko frame ke baad
/// dispose karta hai, * JSON ka koi bhi item kharab ho to crash ke bajaye
/// khaali dikhata hai, * text size system ke bade font se bigadta nahi (max
/// 1.2x), * mouse / trackpad se bhi swipe hota hai (simulator me asaan
/// testing).
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
    if (_banners.length != _count) {
      _prepare();
    } else if (widget.autoPlay != oldWidget.autoPlay) {
      _startSliding();
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
  ///
  /// The old controller is disposed AFTER the frame: the PageView is still attached
  /// to it until it rebuilds, and disposing it earlier is what threw
  /// "PageController was used after being disposed".
  void _prepare() {
    final old = _pages;
    _count = _banners.length;
    _pages = _count > 1 ? PageController(initialPage: _count * 1000) : null;
    debugPrint(
        'MarketplaceBannerSlider: slides=$_count autoPlay=${widget.autoPlay}');
    _startSliding();

    if (old != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
    }
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
    try {
      var key = (path ?? '').trim();
      if (key.isEmpty) key = fallback;
      if (!key.startsWith(r'$')) key = '\$.$key';

      return getJsonField(item, key)?.toString().trim() ?? '';
    } catch (_) {
      // Item ka shape alag ho to is hisse ko khaali maan lo, crash mat karo.
      return '';
    }
  }

  String _picture(dynamic item, String? path, String fallback) {
    final value = _read(item, path, fallback);
    if (!value.startsWith('/')) return value;

    var base = '';
    try {
      base = FFDevEnvironmentValues().baseURL;
    } catch (_) {}
    if (base.endsWith('/')) base = base.substring(0, base.length - 1);
    return '$base$value';
  }

  /// Tap par: poora web link ho to browser me, warna app ki screen (route) me.
  /// Console me "MarketplaceBannerSlider tap -> ..." line dikhti hai, jisse pata
  /// chalta hai ke link / route asal me mila ya khaali raha.
  Future<void> _open(String link, String route) async {
    debugPrint('MarketplaceBannerSlider tap -> link="$link" route="$route"');
    if (!mounted) return;

    // 1) Poora web link (https://... ya haat.sd/abc)
    if (link.isNotEmpty && !link.startsWith('/')) {
      var uri = Uri.tryParse(link);
      if (uri != null && !uri.hasScheme) uri = Uri.tryParse('https://$link');
      if (uri != null) {
        for (final mode in [
          LaunchMode.externalApplication,
          LaunchMode.platformDefault,
        ]) {
          try {
            if (await launchUrl(uri, mode: mode)) return;
          } catch (e) {
            debugPrint('MarketplaceBannerSlider: launchUrl ($mode) fail: $e');
          }
        }
      }
    }

    if (!mounted) return;

    // 2) App ke andar ki screen: route naam, ya "/" se shuru hone wala link
    final target =
        route.isNotEmpty ? route : (link.startsWith('/') ? link : '');
    if (target.isEmpty) {
      debugPrint('MarketplaceBannerSlider: is slide me link ya route nahi mila '
          '(linkPath / routePath parameters check karo)');
      return;
    }

    try {
      final router = GoRouter.of(context);
      if (target.startsWith('/')) {
        router.push(target);
      } else {
        router.pushNamed(target);
      }
    } catch (e) {
      debugPrint('MarketplaceBannerSlider: route "$target" nahi khula: $e');
    }
  }

  /// Size kabhi infinite / NaN nahi: pehle diya hua size, phir parent ka, phir fallback.
  double _size(double? given, bool bounded, double max, double fallback) {
    if (given != null && given.isFinite && given > 0) return given;
    if (bounded && max.isFinite) return max;
    return fallback;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screen = MediaQuery.of(context).size;
        final w = _size(widget.width, constraints.hasBoundedWidth,
            constraints.maxWidth, screen.width);
        final h = _size(widget.height, constraints.hasBoundedHeight,
            constraints.maxHeight, screen.height * 0.6);

        final count = _banners.length;
        final Widget body;

        if (count == 0) {
          // Still loading, or nothing live: dark, so the page's white header still reads.
          body = Container(color: _dark);
        } else if (count == 1) {
          body = _page(context, 0);
        } else {
          final pages = _pages ??= PageController(initialPage: count * 1000);
          body = ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            child: PageView.builder(
              controller: pages,
              physics: const PageScrollPhysics(),
              onPageChanged: (_) => _startSliding(),
              itemBuilder: (context, page) =>
                  _page(context, page % _banners.length),
            ),
          );
        }

        return SizedBox(
          width: w,
          height: h,
          child: ClipRect(
            // iOS / Android ke bade system font se layout na bigde.
            child: MediaQuery.withClampedTextScaling(
              minScaleFactor: 1.0,
              maxScaleFactor: 1.2,
              child: body,
            ),
          ),
        );
      },
    );
  }

  Widget _page(BuildContext context, int index) {
    if (_banners.isEmpty) return Container(color: _dark);
    final safeIndex = index.clamp(0, _banners.length - 1);
    final total = _banners.length;

    final item = _banners[safeIndex];
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
                        errorBuilder: (_, __, ___) =>
                            const SizedBox(width: 44, height: 44),
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
                if (total > 1)
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var dot = 0; dot < total; dot++)
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 2.5),
                            color: dot == safeIndex
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
