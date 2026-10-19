import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// The Marketplace tab's colours, as the design drew them.
class MarketColors {
  static const ink = Color(0xFF111111);
  static const canvas = Color(0xFFF4F4F4);
  static const link = Color(0xFF00713D);
  static const visit = Color(0xFF005A3B);
  static const tile = Color(0xFFF2F2F7);
  static const hairline = Color(0xFFF0F0F0);
  static const muted = Color(0x85000000);
  static const night = Color(0xFF0E1311);
}

String marketText(String language, String en, String ar) =>
    language == 'ar' ? ar : en;

/// The shelves a merchant can narrow the marketplace to.
enum MarketCategory {
  forYou,
  telecom,
  education,
  giftCards,
  esim,
  international
}

extension MarketCategoryDetails on MarketCategory {
  String label(String language) => switch (this) {
        MarketCategory.forYou => marketText(language, 'For You', 'لك'),
        MarketCategory.telecom => marketText(language, 'Telecom', 'الاتصالات'),
        MarketCategory.education =>
          marketText(language, 'Education', 'التعليم'),
        MarketCategory.giftCards =>
          marketText(language, 'Gift Cards', 'بطاقات الهدايا'),
        MarketCategory.esim => marketText(language, 'E-SIM', 'شريحة إلكترونية'),
        MarketCategory.international =>
          marketText(language, 'International', 'دولي'),
      };

  IconData get icon => switch (this) {
        MarketCategory.forYou => Icons.star_border_rounded,
        MarketCategory.telecom => Icons.cell_tower_rounded,
        MarketCategory.education => Icons.school_outlined,
        MarketCategory.giftCards => Icons.card_giftcard_rounded,
        MarketCategory.esim => Icons.sim_card_outlined,
        MarketCategory.international => Icons.public_rounded,
      };
}

/// Somebody a merchant can pay or buy from inside the marketplace.
class MarketProvider {
  const MarketProvider({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.shortName,
    required this.shortNameAr,
    required this.blurb,
    required this.blurbAr,
    required this.color,
    required this.foreground,
    this.mark,
    this.icon,
    this.ringed = false,
    this.categories = const {},
  });

  final String id;
  final String name;
  final String nameAr;

  /// The name under a round logo, where a whole one does not fit.
  final String shortName;
  final String shortNameAr;

  final String blurb;
  final String blurbAr;

  /// The logo's ground and what is drawn on it, until the real logo is in the app.
  final Color color;
  final Color foreground;
  final String? mark;
  final IconData? icon;

  /// A white logo on a white page needs an edge to be seen.
  final bool ringed;

  final Set<MarketCategory> categories;

  /// Where the real logo goes: drop the file in and it is used, no code change.
  String get asset => 'assets/images/mk_$id.png';

  String nameIn(String language) => marketText(language, name, nameAr);
  String shortNameIn(String language) =>
      marketText(language, shortName, shortNameAr);
  String blurbIn(String language) => marketText(language, blurb, blurbAr);
}

/// A shop with its own card under "Explore Top Brands".
class MarketBrand {
  const MarketBrand({
    required this.id,
    required this.logo,
    required this.blurb,
    required this.blurbAr,
    required this.coverColor,
  });

  final String id;
  final MarketProvider logo;
  final String blurb;
  final String blurbAr;

  /// The cover's colour until a cover picture is in the app.
  final Color coverColor;

  String get cover => 'assets/images/mk_cover_$id.png';

  String blurbIn(String language) => marketText(language, blurb, blurbAr);
}

const _bills = 'Pay your Postpaid or prepaid bills';
const _billsAr = 'ادفع فواتيرك الآجلة أو المسبقة';

const _mtn = MarketProvider(
  id: 'mtn',
  name: 'MTN Sudan',
  nameAr: 'إم تي إن السودان',
  shortName: 'MTN',
  shortNameAr: 'إم تي إن',
  blurb: _bills,
  blurbAr: _billsAr,
  color: Color(0xFFFFCB05),
  foreground: Color(0xFF111111),
  mark: 'MTN',
  categories: {MarketCategory.telecom, MarketCategory.esim},
);

const _sudani = MarketProvider(
  id: 'sudani',
  name: 'Sudani',
  nameAr: 'سوداني',
  shortName: 'Sudani',
  shortNameAr: 'سوداني',
  blurb: _bills,
  blurbAr: _billsAr,
  color: Color(0xFF1E4FA1),
  foreground: Colors.white,
  mark: 'S',
  categories: {MarketCategory.telecom},
);

const _zain = MarketProvider(
  id: 'zain',
  name: 'Zain Telecom',
  nameAr: 'زين',
  shortName: 'Zain',
  shortNameAr: 'زين',
  blurb: _bills,
  blurbAr: _billsAr,
  color: Color(0xFF7B5EA7),
  foreground: Colors.white,
  mark: 'zain',
  categories: {
    MarketCategory.telecom,
    MarketCategory.esim,
    MarketCategory.international,
  },
);

const _canar = MarketProvider(
  id: 'canar',
  name: 'Canar Telecom',
  nameAr: 'كنار للاتصالات',
  shortName: 'Canar',
  shortNameAr: 'كنار',
  blurb: _bills,
  blurbAr: _billsAr,
  color: Color(0xFF1A1A1A),
  foreground: Colors.white,
  mark: 'C',
  categories: {MarketCategory.telecom},
);

const _tirhal = MarketProvider(
  id: 'tirhal',
  name: 'Tirhal Travel',
  nameAr: 'ترحال للسفر',
  shortName: 'Tirhal',
  shortNameAr: 'ترحال',
  blurb: 'Book bus tickets between cities',
  blurbAr: 'احجز تذاكر الحافلات بين المدن',
  color: Colors.white,
  foreground: Color(0xFFD32F2F),
  mark: 'Tirhal',
  ringed: true,
);

const _government = MarketProvider(
  id: 'government',
  name: 'Government services',
  nameAr: 'الخدمات الحكومية',
  shortName: 'Government',
  shortNameAr: 'حكومية',
  blurb: 'Pay government fees and services',
  blurbAr: 'ادفع الرسوم والخدمات الحكومية',
  color: Color(0xFF00DA76),
  foreground: Colors.white,
  icon: Icons.account_balance_rounded,
);

const _electricity = MarketProvider(
  id: 'electricity',
  name: 'Electricity',
  nameAr: 'الكهرباء',
  shortName: 'Electricity',
  shortNameAr: 'الكهرباء',
  blurb: 'Buy prepaid electricity units',
  blurbAr: 'اشترِ وحدات الكهرباء المسبقة',
  color: Colors.white,
  foreground: Color(0xFFF59E0B),
  icon: Icons.bolt_rounded,
  ringed: true,
);

const _go = MarketProvider(
  id: 'go',
  name: 'GO',
  nameAr: 'جو',
  shortName: 'GO',
  shortNameAr: 'جو',
  blurb: 'Top up your GO wallet',
  blurbAr: 'اشحن محفظة جو',
  color: Color(0xFF00A651),
  foreground: Colors.white,
  mark: 'GO',
);

const _cyberGaming = MarketProvider(
  id: 'cyber',
  name: 'Cyber Gaming Store',
  nameAr: 'متجر سايبر للألعاب',
  shortName: 'Cyber',
  shortNameAr: 'سايبر',
  blurb: 'Game cards, consoles and accessories',
  blurbAr: 'بطاقات الألعاب والأجهزة والإكسسوارات',
  color: Color(0xFF2346D8),
  foreground: Colors.white,
  icon: Icons.sports_esports_rounded,
  categories: {MarketCategory.giftCards},
);

const _ikmDigital = MarketProvider(
  id: 'ikm',
  name: 'IKM Digital',
  nameAr: 'آي كي إم ديجيتال',
  shortName: 'IKM',
  shortNameAr: 'آي كي إم',
  blurb: 'Digital vouchers and software keys',
  blurbAr: 'قسائم رقمية ومفاتيح برامج',
  color: Color(0xFF16181D),
  foreground: Colors.white,
  mark: 'IKM',
  categories: {MarketCategory.giftCards},
);

/// The eight round logos under "Picked For You", in the design's order.
const pickedForYou = [
  _mtn,
  _sudani,
  _zain,
  _canar,
  _government,
  _electricity,
  _tirhal,
  _go,
];

/// Everything the See all screen lists, telecoms first as the design has them.
const marketProviders = [
  _mtn,
  _sudani,
  _zain,
  _canar,
  _tirhal,
  _government,
  _electricity,
  _go,
  _cyberGaming,
  _ikmDigital,
];

const topBrands = [
  MarketBrand(
    id: 'cyber',
    logo: _cyberGaming,
    blurb: 'Explore new gaming adventures, accessories & gift cards',
    blurbAr: 'اكتشف مغامرات ألعاب جديدة وإكسسوارات وبطاقات هدايا',
    coverColor: Color(0xFF1D2B53),
  ),
  MarketBrand(
    id: 'mtn',
    logo: _mtn,
    blurb: 'Bundles, top-ups and home internet in one place',
    blurbAr: 'الباقات والشحن وإنترنت المنزل في مكان واحد',
    coverColor: Color(0xFFFFCB05),
  ),
  MarketBrand(
    id: 'ikm',
    logo: _ikmDigital,
    blurb: 'Software keys and digital vouchers, delivered instantly',
    blurbAr: 'مفاتيح برامج وقسائم رقمية تصلك فوراً',
    coverColor: Color(0xFF2A2D35),
  ),
  MarketBrand(
    id: 'tirhal',
    logo: _tirhal,
    blurb: 'Bus trips across Sudan, booked in minutes',
    blurbAr: 'رحلات الحافلات في أنحاء السودان تُحجز في دقائق',
    coverColor: Color(0xFFC62828),
  ),
];

/// A slide the app carries itself, shown while the back office has none live — so the
/// tab opens on the design's pictures rather than an empty panel.
class MarketHeroDefault {
  const MarketHeroDefault({
    required this.asset,
    required this.name,
    required this.nameAr,
    required this.title,
    required this.titleAr,
    required this.cta,
    required this.ctaAr,
  });

  /// `assets/images/mk_hero_N.png` — the photograph alone; the words are drawn over it.
  final String asset;

  /// Who the slide is for, said by the "coming soon" note its button raises.
  final String name;
  final String nameAr;

  final String title;
  final String titleAr;
  final String cta;
  final String ctaAr;
}

const marketHeroDefaults = [
  MarketHeroDefault(
    asset: 'assets/images/mk_hero_1.png',
    name: 'Tarco Travels',
    nameAr: 'تاركو للسفر',
    title: 'Enjoy 5% Cashback on Tarco Travels',
    titleAr: 'استرد 5% نقداً مع تاركو للسفر',
    cta: 'Purchase',
    ctaAr: 'شراء',
  ),
  MarketHeroDefault(
    asset: 'assets/images/mk_hero_2.png',
    name: 'SyberPay',
    nameAr: 'سايبرباي',
    title: 'No Fees, Instant transfer to SyberPay wallet',
    titleAr: 'بلا رسوم، تحويل فوري إلى محفظة سايبرباي',
    cta: 'Transfer',
    ctaAr: 'تحويل',
  ),
  MarketHeroDefault(
    asset: 'assets/images/mk_hero_3.png',
    name: 'SyberPay',
    nameAr: 'سايبرباي',
    title: 'No Fees, Instant transfer to SyberPay wallet',
    titleAr: 'بلا رسوم، تحويل فوري إلى محفظة سايبرباي',
    cta: 'Transfer',
    ctaAr: 'تحويل',
  ),
];

/// Which of the marketplace's pictures are actually in the app.
///
/// Logos and covers are drawn from `assets/images/mk_*.png` when the file is there and
/// from the brand's colour and mark when it is not — asked once of the asset manifest,
/// rather than by trying each file and failing, which would cost a failed load on every
/// rebuild and fill the log with "Unable to load asset".
class MarketAssets {
  static final available = ValueNotifier<Set<String>>(const {});
  static bool _asked = false;

  static Future<void> ensureLoaded() async {
    if (_asked) return;
    _asked = true;

    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      available.value = manifest
          .listAssets()
          .where((path) => path.startsWith('assets/images/mk_'))
          .toSet();
    } catch (_) {
      // Every logo keeps its drawn mark; nothing is lost but the pictures.
    }
  }
}

/// A provider's round logo: the real one when the app has it, the drawn mark when not.
class MarketLogo extends StatelessWidget {
  const MarketLogo(
    this.provider, {
    super.key,
    this.size = 56,
    this.edge,
  });

  final MarketProvider provider;
  final double size;

  /// Drawn around the logo, over the ring a white logo gets anyway.
  final BorderSide? edge;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: MarketAssets.available,
      builder: (context, available, _) {
        final pictured = available.contains(provider.asset);

        // The real logos carry their own ring where they need one.
        final border = edge ??
            (provider.ringed && !pictured
                ? const BorderSide(color: Color(0xFFE6E6E6))
                : BorderSide.none);

        return Container(
          width: size,
          height: size,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: pictured ? Colors.white : provider.color,
            shape: BoxShape.circle,
            border: Border.fromBorderSide(border),
          ),
          child: pictured
              ? Image.asset(
                  provider.asset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _mark(),
                )
              : _mark(),
        );
      },
    );
  }

  Widget _mark() {
    if (provider.icon != null) {
      return Icon(provider.icon, size: size * 0.46, color: provider.foreground);
    }

    final mark = provider.mark ?? provider.shortName.characters.first;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(size * 0.12),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            mark,
            maxLines: 1,
            style: GoogleFonts.inter(
              fontSize: size * (mark.length > 3 ? 0.24 : 0.3),
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
              color: provider.foreground,
            ),
          ),
        ),
      ),
    );
  }
}

/// A brand's card: cover, logo over its edge, two lines about it, and the way in.
class MarketBrandCard extends StatelessWidget {
  const MarketBrandCard({
    super.key,
    required this.brand,
    required this.language,
    required this.onTap,
  });

  final MarketBrand brand;
  final String language;
  final VoidCallback onTap;

  static const width = 152.0;
  static const height = 170.0;
  static const _coverHeight = 59.0;
  static const _logo = 42.0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: MarketColors.hairline),
        borderRadius: BorderRadius.circular(4),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: _coverHeight + _logo / 2,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: _coverHeight,
                      child: _cover(),
                    ),
                    PositionedDirectional(
                      start: 10,
                      top: _coverHeight - _logo / 2,
                      child: MarketLogo(
                        brand.logo,
                        size: _logo,
                        edge: const BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 6, 10, 0),
                child: Text(
                  brand.logo.nameIn(language),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: MarketColors.ink,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 3, 10, 0),
                child: Text(
                  brand.blurbIn(language),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    height: 1.35,
                    color: MarketColors.muted,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      marketText(language, 'Visit', 'زيارة'),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: MarketColors.visit,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.north_east_rounded,
                      size: 12,
                      color: MarketColors.visit,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cover() {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: MarketAssets.available,
      builder: (context, available, _) {
        final ground = ColoredBox(color: brand.coverColor);

        if (!available.contains(brand.cover)) return ground;

        return Image.asset(
          brand.cover,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => ground,
        );
      },
    );
  }
}

/// What a tap on a provider does until its own screen exists: says so, plainly.
void showMarketSoon(
  BuildContext context,
  String name,
  String language, {
  double bottom = 16,
}) {
  final messenger = ScaffoldMessenger.of(context);

  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(16, 0, 16, bottom),
        backgroundColor: MarketColors.ink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
        content: Text(
          marketText(
            language,
            'Paying $name from HAAT is coming soon.',
            'الدفع لـ$name من هات قريباً.',
          ),
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
        ),
      ),
    );
}
