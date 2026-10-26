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
  int _currentPageIndex = 0;

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

  void _prepare() {
    final old = _pages;
    _count = _banners.length;
    final initialPage = _count > 1 ? _count * 1000 : 0;
    _currentPageIndex = 0;
    _pages = _count > 1 ? PageController(initialPage: initialPage) : null;

    _startSliding();

    if (old != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
    }
  }

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

  String _read(dynamic item, String? path, List<String> fallbackKeys) {
    if (item == null) return '';

    // 1. JSON Path query
    final rawPath = (path ?? '').trim();
    if (rawPath.isNotEmpty) {
      try {
        final jsonPath = rawPath.startsWith(r'$') ? rawPath : '\$.$rawPath';
        final val = getJsonField(item, jsonPath)?.toString().trim();
        if (val != null &&
            val.isNotEmpty &&
            val != 'null' &&
            val != 'undefined') {
          return val;
        }
      } catch (_) {}
    }

    // 2. Direct map fallback keys
    if (item is Map) {
      for (final key in fallbackKeys) {
        if (item.containsKey(key) && item[key] != null) {
          final val = item[key].toString().trim();
          if (val.isNotEmpty && val != 'null' && val != 'undefined') {
            return val;
          }
        }
      }
    }

    return '';
  }

  String _picture(dynamic item, String? path, List<String> fallbackKeys) {
    final value = _read(item, path, fallbackKeys);
    if (value.isEmpty) return '';
    if (!value.startsWith('/')) return value;

    var base = '';
    try {
      base = FFDevEnvironmentValues().baseURL;
    } catch (_) {}
    if (base.endsWith('/')) base = base.substring(0, base.length - 1);
    return '$base$value';
  }

  Future<void> _open(String link, String route) async {
    debugPrint('MarketplaceBannerSlider tap -> link="$link" route="$route"');
    if (!mounted) return;

    // 1. Open via openBannerLink action (handles RequestNFC sheet & standard routes)
    try {
      await openBannerLink(context, link, route);
      return;
    } catch (e) {
      debugPrint('MarketplaceBannerSlider: openBannerLink delegated: $e');
    }

    if (!mounted) return;

    // 2. Direct browser link fallback
    if (link.isNotEmpty && link != 'null' && !link.startsWith('/')) {
      var uri = Uri.tryParse(link.contains('://') ? link : 'https://$link');
      if (uri != null) {
        for (final mode in [
          LaunchMode.externalApplication,
          LaunchMode.platformDefault,
        ]) {
          try {
            if (await launchUrl(uri, mode: mode)) return;
          } catch (_) {}
        }
      }
    }

    if (!mounted) return;

    // 3. Named route fallback
    final target = route.isNotEmpty && route != 'null'
        ? route
        : (link.startsWith('/') ? link : '');
    if (target.isEmpty) return;

    try {
      if (target.startsWith('/')) {
        context.push(target);
      } else {
        context.pushNamed(target);
      }
    } catch (_) {
      try {
        final path = target.startsWith('/') ? target : '/$target';
        context.push(path);
      } catch (err) {
        debugPrint('MarketplaceBannerSlider: route failed for "$target": $err');
      }
    }
  }

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
          body = Container(color: _dark);
        } else if (count == 1) {
          body = _page(context, 0);
        } else {
          final initialPage = count * 1000;
          final pages = _pages ??= PageController(initialPage: initialPage);

          body = NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification) {
                // User drag / thumb scroll shuru ho to auto-slide pause karein
                _slide?.cancel();
              } else if (notification is ScrollEndNotification) {
                // Drag khatam hone ke baad auto-slide dobara start karein
                _startSliding();
              }
              return false;
            },
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.unknown,
                },
              ),
              child: PageView.builder(
                controller: pages,
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                onPageChanged: (page) {
                  final safe = (page % count + count) % count;
                  if (mounted && safe != _currentPageIndex) {
                    setState(() => _currentPageIndex = safe);
                  }
                  _startSliding();
                },
                itemBuilder: (context, page) {
                  final safeIndex = (page % count + count) % count;
                  return _page(context, safeIndex);
                },
              ),
            ),
          );
        }

        return SizedBox(
          width: w,
          height: h,
          child: ClipRect(
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
    final total = _banners.length;
    final safeIndex = (index % total + total) % total;

    final item = _banners[safeIndex];
    final image = _picture(item, widget.imagePath, [
      'imagePath',
      'image_path',
      'imageUrl',
      'image_url',
      'image',
      'picture',
    ]);
    final logo = _picture(item, widget.logoPath, [
      'logoPath',
      'logo_path',
      'logoUrl',
      'logo_url',
      'logo',
    ]);
    final title = _read(item, widget.titlePath, [
      'title',
      'titleEn',
      'headline',
      'name',
    ]);
    final button = _read(item, widget.buttonPath, [
      'ctaLabel',
      'cta_label',
      'cta',
      'button',
      'buttonText',
      'label',
    ]);
    final link = _read(item, widget.linkPath, [
      'actionUrl',
      'action_url',
      'linkUrl',
      'link_url',
      'url',
      'link',
    ]);
    final route = _read(item, widget.routePath, [
      'actionRoute',
      'action_route',
      'route',
      'targetRoute',
      'screen',
    ]);

    void open() => _open(link, route);

    // Navigation sirf button se hoga (poore banner par tap se nahi)
    return Stack(
      fit: StackFit.expand,
      children: [
        image.isEmpty
            ? Container(color: _dark)
            : Image.network(
                image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: _dark),
              ),
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
                          decoration: BoxDecoration(
                            color: dot == _currentPageIndex
                                ? Colors.white
                                : const Color(0x80FFFFFF),
                            // Square dots (circle nahi)
                            borderRadius: BorderRadius.zero,
                          ),
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
                      splashColor: Colors.white24,
                      highlightColor: Colors.white10,
                      child: Container(
                        height: 44,
                        constraints: const BoxConstraints(minWidth: 116),
                        padding: const EdgeInsets.symmetric(horizontal: 22),
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
    );
  }
}
