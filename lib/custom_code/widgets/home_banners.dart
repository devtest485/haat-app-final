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

import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/banner_api.dart';

/// The cards along the bottom of the home screen, as the platform maintains them.
///
/// The design drew three and the app carried them as pictures, which meant every
/// merchant saw those three for as long as that build was installed: a campaign, a
/// seasonal notice, or taking a card down for a feature that is not ready all cost a
/// release and a store review. They come from `GET /banners` now, in the order the
/// back office set, so the list is the platform's to change.
///
/// ## What it shows while it does not know
///
/// Nothing. A spinner where a banner will be is a worse answer than the space it will
/// occupy — the cards are an aside, not the reason the screen was opened — and a
/// failed fetch leaves the same empty space rather than an error a merchant can do
/// nothing about.
class HomeBanners extends StatefulWidget {
  const HomeBanners({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<HomeBanners> createState() => _HomeBannersState();
}

class _HomeBannersState extends State<HomeBanners> {
  final PageController _pages = PageController();

  /// How long each card holds the screen before the next one slides in.
  ///
  /// The design's carousel moved on its own, and a merchant who never swipes should
  /// still see all of them — the second card is the one asking for a QR stand, which
  /// nobody would find by scrolling past a screen they think is finished.
  static const _dwell = Duration(seconds: 4);

  Timer? _slide;

  List<HomeBanner> _banners = const [];
  int _current = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _slide?.cancel();
    _pages.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final result = await AuthSession.instance.banners.list();
    if (!mounted) return;

    if (result is ApiSuccess<List<HomeBanner>>) {
      setState(() => _banners = result.value);
      _startSliding();
    }
  }

  /// Moves to the next card every few seconds, wrapping at the end.
  ///
  /// Restarted whenever the page changes, which is what gives a swipe its due: a
  /// merchant who has just moved to a card gets the full dwell to read it rather than
  /// whatever was left of the previous one's.
  void _startSliding() {
    _slide?.cancel();

    if (_banners.length < 2) return;

    _slide = Timer.periodic(_dwell, (_) {
      if (!mounted || !_pages.hasClients) return;

      _pages.animateToPage(
        (_current + 1) % _banners.length,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  /// Opens what the card points at, when the app has that screen.
  ///
  /// A route the app does not know is ignored rather than thrown: the back office can
  /// write a card for a screen that ships next week, and a merchant on the older build
  /// should get a card that does nothing rather than a crash.
  void _open(HomeBanner banner) {
    if (banner.actionRoute.isEmpty) return;

    try {
      context.pushNamed(banner.actionRoute);
    } catch (_) {
      // Nothing to do and nothing worth saying.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_banners.isEmpty) return const SizedBox.shrink();

    final language = AuthSession.instance.languageCode;

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 180,
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pages,
              itemCount: _banners.length,
              onPageChanged: (index) {
                setState(() => _current = index);
                _startSliding();
              },
              itemBuilder: (context, index) => _card(_banners[index], language),
            ),
          ),
          if (_banners.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var index = 0; index < _banners.length; index++)
                    Container(
                      width: index == _current ? 16 : 6,
                      height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: index == _current
                            ? FlutterFlowTheme.of(context).primary
                            : FlutterFlowTheme.of(context).alternate,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _card(HomeBanner banner, String language) {
    final subtitle = banner.subtitleIn(language);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () => _open(banner),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: _colour(banner.backgroundColor),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      banner.titleIn(language),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    if (subtitle.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          subtitle,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                      ),
                  ],
                ),
              ),
              if (banner.imageUrl.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Image.network(
                    banner.imageUrl,
                    width: 96,
                    height: 96,
                    fit: BoxFit.contain,
                    // A card whose artwork will not load is still a card with something
                    // to say, so the picture goes and the words stay.
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// `#RRGGBB` as a colour, or the design's green when the back office typed something
  /// else. A card in the wrong shade beats a card that throws while painting.
  Color _colour(String value) {
    final hex = value.replaceAll('#', '').trim();
    final parsed = int.tryParse(hex, radix: 16);

    if (hex.length != 6 || parsed == null) return const Color(0xFF0B6B3A);

    return Color(0xFF000000 | parsed);
  }
}
