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

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

/// Live CustomBottombar ka tab switcher. Bar khud isay initState me set karta
/// hai aur dispose par clear kar deta hai. Widget self-contained hai — koi
/// alag custom action file zaroori nahi.
void Function(int index)? _bottomTabNavigator;

// The bar's own icons, kept in the code. They exist only for this widget and
// not as project assets, so a FlutterFlow code download leaves them out of
// assets/images; read from here they show up either way.
const Map<String, String> _inlineSvgs = {
  'assets/images/haat_mark.svg':
      r'''<svg width="11" height="18" viewBox="0 0 11 18" fill="none" xmlns="http://www.w3.org/2000/svg"><path d="M6.94869 4.26673L6.28319 7.77788H4.45014V4.26673L3.5211 3.34876L2.59707 4.26673V11.1697H1.24772L0.000114441 4.26673L2.64211 0H4.21329L6.94869 4.26673Z" fill="white"/><path d="M3.78457 13.1283L4.45007 9.61714H6.28312V13.1283L7.21215 14.0463L8.13618 13.1283V6.22363H9.48554L10.7331 13.1283L8.09115 17.395H6.51997L3.78457 13.1283Z" fill="white"/></svg>''',
  'assets/images/shopping_bag_speed.svg':
      r'''<svg xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 -960 960 960" width="24"><path fill="#fff" d="m60-252.31 15-60h199.61l-14.99 60H60Zm80-155.38 15-60h239.61l-14.99 60H140Zm602.23 248.07 20-160.76 28.62-236.16 10.38-82.84-59 479.76ZM251.15-100q-26.07 0-44.76-17.35-18.7-17.34-18.7-42.65h542.23q5.39 0 9.23-3.46 3.85-3.46 4.62-8.85l55.54-453.23q.77-5.38-3.08-9.61-3.85-4.23-9.23-4.23H681.23l-11.77 93.07q-1.61 12.77-11.35 20.16-9.73 7.38-22.49 6.15-12.39-1.23-19.77-10.65-7.39-9.43-5.77-21.81l10.54-86.92H441.23l-11.77 92.46q-1.61 12.77-11.35 20.46-9.73 7.69-22.49 6.46-12.39-1.23-20.08-10.96-7.69-9.73-6.08-22.12l10.54-86.3H243.46q3.62-27.47 23.5-44.04Q286.85-700 313.46-700h73.85l1.15-10q8-70.77 49-110.38 41-39.62 111.77-39.62 61.31 0 101.12 45.96 39.8 45.96 36.5 107.89l-.77 6.15h102.77q31.38.62 52.3 24.16 20.93 23.53 16.69 54.92l-56.53 455.38q-3.62 28.46-24.97 47Q755-100 726.54-100H251.15Zm196.16-600h179.38l.77-6.15q2.54-38-22.88-65.93Q579.15-800 541.54-800q-41.16 0-64.73 23.81-23.58 23.81-28.35 66.19l-1.15 10Z"/></svg>''',
  'assets/images/local_mall.svg':
      r'''<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24"><mask id="a" width="24" height="24" x="0" y="0" maskUnits="userSpaceOnUse" style="mask-type:alpha"><path fill="#d9d9d9" d="M0 0h24v24H0z"/></mask><g mask="url(#a)"><path fill="#fff" d="M5.308 21.5q-.748 0-1.278-.53a1.74 1.74 0 0 1-.53-1.278V8.308q0-.748.53-1.278t1.278-.53H7.5q0-1.873 1.313-3.186Q10.128 2 12 2t3.187 1.314Q16.5 4.626 16.5 6.5h2.192q.749 0 1.278.53.53.53.53 1.278v11.384q0 .749-.53 1.278-.53.53-1.278.53zm0-1.5h13.384a.3.3 0 0 0 .212-.096.3.3 0 0 0 .096-.212V8.308a.3.3 0 0 0-.096-.212.3.3 0 0 0-.212-.096H5.308a.3.3 0 0 0-.212.096.3.3 0 0 0-.096.212v11.384q0 .116.096.212a.3.3 0 0 0 .212.096m9.879-7.813Q16.5 10.873 16.5 9H15q0 1.25-.875 2.125A2.9 2.9 0 0 1 12 12a2.9 2.9 0 0 1-2.125-.875A2.9 2.9 0 0 1 9 9H7.5q0 1.873 1.313 3.187Q10.128 13.5 12 13.5t3.187-1.313M9 6.5h6q0-1.25-.875-2.125A2.9 2.9 0 0 0 12 3.5q-1.25 0-2.125.875A2.9 2.9 0 0 0 9 6.5"/></g></svg>''',
};

void callNavigateTab(int index) {
  _bottomTabNavigator?.call(index);
}

class CustomBottombar extends StatefulWidget {
  const CustomBottombar({
    super.key,
    this.width,
    this.height,
    required this.homePage,
    required this.cashierPage,
    required this.servicesPage,
    required this.storePage,
    this.homeLabel,
    this.cashierLabel,
    this.servicesLabel,
    this.storeLabel,
    this.selectedColor,
    this.unselectedColor,
    this.barColor,
    this.borderColor,
    this.labelSize,
    this.blurAmount,
    this.initialIndex,
    this.extendBodyBehindBar,
    this.onTabChanged,
    this.enableScrolling,
    this.scrollPhysics,
  });

  static final globalKey = GlobalKey<_CustomBottombarState>();

  final double? width;
  final double? height;

  final Widget Function() homePage;
  final Widget Function() cashierPage;
  final Widget Function() servicesPage;
  final Widget Function() storePage;

  final String? homeLabel;
  final String? cashierLabel;
  final String? servicesLabel;
  final String? storeLabel;

  final Color? selectedColor;
  final Color? unselectedColor;

  /// Ab use nahi hota — bar hamesha solid white hai. Parameter sirf isliye
  /// rakha hai ke FlutterFlow ki existing settings na toote.
  final Color? barColor;
  final Color? borderColor;
  final double? labelSize;

  /// Ab use nahi hota (blur hata diya gaya). FlutterFlow compatibility ke liye rakha hai.
  final double? blurAmount;
  final int? initialIndex;
  final bool? extendBodyBehindBar;
  final Future Function(int tabIndex)? onTabChanged;

  /// Scrolling enable/disable karne ke liye — default: true
  /// false karne par page apni original height rakhta hai (scroll nahi hota).
  final bool? enableScrolling;

  /// Scroll physics customize karne ke liye — default: BouncingScrollPhysics
  /// Options: 'bouncing' (iOS style), 'clamping' (Android style), 'never' (scroll band karo)
  final String? scrollPhysics;

  @override
  State<CustomBottombar> createState() => _CustomBottombarState();
}

class _CustomBottombarState extends State<CustomBottombar> {
  static const double _kBarHeight = 85.0;
  static const double _kTopPadding = 12.0;
  static const double _kBorderWidth = 1.0;
  static const Color _kBorderColor = Color(0xFFF3F3F3);
  static const Color _kSelectedColor = Color(0xFF111111);
  static const Color _kUnselectedColor = Color(0xFFC4C4C4);
  static const double _kIconBox = 28.0;
  static const double _kIconLabelGap = 6.0;

  late int _currentIndex;
  final List<int> _pageKeys = [0, 0, 0, 0];

  /// Har tab ka apna alag ScrollController — tab switch par position
  /// remember rehti hai.
  final List<ScrollController> _scrollControllers = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController(),
  ];

  double get _resolvedBarHeight {
    final h = widget.height;
    if (h == null || !h.isFinite || h <= 0) return _kBarHeight;
    return h;
  }

  double? get _resolvedBarWidth {
    final w = widget.width;
    if (w == null || !w.isFinite || w <= 0) return null;
    return w;
  }

  /// 4th tab ka label. FlutterFlow ke `storeLabel` parameter me purani value
  /// ("myStore" / "mystore") bhari ho to wo code ke default ko override kar
  /// deti hai — isliye yahan khali ya purani "mystore" value ko hamesha
  /// 'Profile' bana dete hain. Koi aur custom label ho to wahi dikhta hai.
  String get _storeTabLabel {
    final given = (widget.storeLabel ?? '').trim();
    if (given.isEmpty || given.toLowerCase() == 'mystore') {
      return 'Profile';
    }
    return given;
  }

  /// NavBar ki height — scroll ke liye bottom padding me use hoti hai
  /// taake content NavBar ke peeche na chhupe.
  double get _navBarTotalHeight => _resolvedBarHeight;

  ScrollPhysics get _resolvedPhysics {
    switch (widget.scrollPhysics?.toLowerCase()) {
      case 'clamping':
        return const ClampingScrollPhysics();
      case 'never':
        return const NeverScrollableScrollPhysics();
      case 'bouncing':
      default:
        return const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        );
    }
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = (widget.initialIndex ?? 0).clamp(0, 3);
    _bottomTabNavigator = navigateTo;
  }

  /// The router this bar is listening to.
  ///
  /// Held rather than looked up again in [dispose]. `GoRouter.of(context)` walks the
  /// inherited widget tree, and by the time dispose runs this element is deactivated —
  /// "Looking up a deactivated widget's ancestor is unsafe", which is what the framework
  /// raised on every teardown. The reference is resolved where a dependency is meant to
  /// be, and the listener is removed from the same object it was added to.
  GoRouter? _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final router = GoRouter.of(context);
    if (identical(router, _router)) return;

    // Dependencies can change more than once, and the old code only ever added — so a
    // second call left two listeners on the same delegate and rebuilt the page twice
    // for every route change.
    _router?.routerDelegate.removeListener(_onRouteChange);
    _router = router;
    router.routerDelegate.addListener(_onRouteChange);
  }

  @override
  void dispose() {
    _disposed = true;
    _router?.routerDelegate.removeListener(_onRouteChange);
    if (_bottomTabNavigator == navigateTo) {
      _bottomTabNavigator = null;
    }
    for (final c in _scrollControllers) {
      c.dispose();
    }
    super.dispose();
  }

  /// Set in [dispose], and the only reliable guard for the callback below.
  ///
  /// `mounted` is not enough: it is read when the frame callback runs, and the
  /// element can be torn down between that read and `setState` reaching
  /// `markNeedsBuild`. Navigating quickly — which a run through every route
  /// does — then fails with "_lifecycleState != _ElementLifecycle.defunct".
  bool _disposed = false;

  void _onRouteChange() {
    if (!mounted) return;

    // Post-frame because the router notifies mid-build, and rebuilding the page
    // from inside that build is not allowed. The callback is registered on the
    // binding, which outlives this widget — so one already scheduled still runs
    // after dispose, and has to be told not to.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_disposed || !mounted) return;

      setState(() => _pageKeys[_currentIndex]++);
    });
  }

  void _onItemTapped(int index) {
    if (_currentIndex == index) return;
    navigateTo(index);
  }

  void navigateTo(int index) {
    if (!mounted) return;
    final target = index.clamp(0, 3);
    setState(() {
      _currentIndex = target;
      _pageKeys[target]++;
    });
    widget.onTabChanged?.call(target);
  }

  /// Page ko scroll-capable banana — agar page khud ScrollView use karta ho
  /// to isko wrap nahi karna chahiye (double scroll issue). Is case me
  /// enableScrolling: false pass karein FlutterFlow se.
  Widget _wrapWithScroll({
    required int index,
    required Widget child,
  }) {
    final scrollEnabled = widget.enableScrolling ?? true;

    if (!scrollEnabled) return child;

    return LayoutBuilder(
      builder: (context, constraints) {
        // MediaQuery se bottom padding — system navigation bar bhi include hoti hai
        final bottomPadding = MediaQuery.of(context).padding.bottom;
        // NavBar height + system padding = total space jo scroll ke neeche chahiye.
        // Bar ab har tab par (profile par bhi) dikhta hai, is liye sab tabs ke
        // liye same padding.
        final extraBottom = _navBarTotalHeight + bottomPadding;

        return SingleChildScrollView(
          controller: _scrollControllers[index],
          physics: _resolvedPhysics,
          // extendBody: true ki wajah se content NavBar ke peeche ja sakta
          // hai — yeh padding usse visible area me rakhti hai.
          padding: EdgeInsets.only(bottom: extraBottom),
          child: child,
        );
      },
    );
  }

  Widget _buildPage(int index) {
    late Widget pageContent;
    late String keyPrefix;

    switch (index) {
      case 0:
        keyPrefix = 'home';
        pageContent = widget.homePage();
        break;
      case 1:
        keyPrefix = 'cashier';
        pageContent = widget.cashierPage();
        break;
      case 2:
        keyPrefix = 'services';
        pageContent = widget.servicesPage();
        break;
      case 3:
        keyPrefix = 'store';
        pageContent = widget.storePage();
        break;
      default:
        return const SizedBox.shrink();
    }

    return KeyedSubtree(
      key: ValueKey('${keyPrefix}_${_pageKeys[index]}'),
      child: _wrapWithScroll(index: index, child: pageContent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // Kisi bhi doosre tab se back karne par Home par jao.
        if (_currentIndex != 0) {
          navigateTo(0);
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        extendBody: widget.extendBodyBehindBar ?? true,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: RefreshIndicator(
          onRefresh: () async {
            // Pull-to-refresh: pehle scroll to top, phir page rebuild
            final controller = _scrollControllers[_currentIndex];
            if (controller.hasClients && controller.offset > 0) {
              await controller.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
            setState(() => _pageKeys[_currentIndex]++);
          },
          notificationPredicate: (_) => true,
          child: IndexedStack(
            index: _currentIndex,
            children: [
              _buildPage(0),
              _buildPage(1),
              _buildPage(2),
              _buildPage(3),
            ],
          ),
        ),
        // Bottom bar ab har tab par hamesha show hota hai.
        bottomNavigationBar: _buildNavBar(context),
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    final barHeight = _resolvedBarHeight;
    final barWidth = _resolvedBarWidth;

    return Container(
      width: barWidth,
      decoration: BoxDecoration(
        color: Colors.white, // solid white, bilkul transparent nahi
        border: Border(
          top: BorderSide(
            color: widget.borderColor ?? _kBorderColor,
            width: _kBorderWidth,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: barHeight - _kBorderWidth,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(
                0.0, _kTopPadding, 0.0, 0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNavItem(
                  index: 0,
                  label: widget.homeLabel ?? 'Home',
                  // The HAAT mark, as the design has it (assets/images/haat_mark.svg).
                  selectedIcon: 'assets/images/haat_mark.svg',
                  unselectedIcon: 'assets/images/haat_mark.svg',
                  useColorFilter: true,
                  iconSize: 24,
                  fallbackIcon: Icons.home_rounded,
                ),
                _buildNavItem(
                  index: 1,
                  label: widget.cashierLabel ?? 'Cashier',
                  // The design's bag with speed lines: Material Symbols
                  // "shopping_bag_speed", outlined at weight 300 like local_mall.
                  selectedIcon: 'assets/images/shopping_bag_speed.svg',
                  unselectedIcon: 'assets/images/shopping_bag_speed.svg',
                  useColorFilter: true,
                  iconSize: 24,
                  fallbackIcon: Icons.shopping_bag_outlined,
                ),
                _buildNavItem(
                  index: 2,
                  label: widget.servicesLabel ?? 'Services',
                  selectedIcon: 'assets/images/local_mall.svg',
                  unselectedIcon: 'assets/images/local_mall.svg',
                  useColorFilter: true,
                  iconSize: 24,
                  fallbackIcon: Icons.local_mall_outlined,
                ),
                _buildNavItem(
                  index: 3,
                  label: _storeTabLabel,
                  // add_business.svg went with a FlutterFlow export.
                  // add_business_white.svg is the same mark and is still
                  // bundled; useColorFilter tints it either way, so "white"
                  // describes the file rather than what appears on screen.
                  selectedIcon: 'assets/images/add_business_white.svg',
                  unselectedIcon: 'assets/images/add_business_white.svg',
                  useColorFilter: true,
                  iconSize: 24,
                  fallbackIcon: Icons.add_business_outlined,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required String selectedIcon,
    required String unselectedIcon,
    required bool useColorFilter,
    double iconSize = _kIconBox,
    IconData fallbackIcon = Icons.circle_outlined,
  }) {
    final isSelected = _currentIndex == index;
    final selectedColor = widget.selectedColor ?? _kSelectedColor;
    final unselectedColor = widget.unselectedColor ?? _kUnselectedColor;
    final color = isSelected ? selectedColor : unselectedColor;
    final iconPath = isSelected ? selectedIcon : unselectedIcon;
    final logoUrl = context.watch<FFAppState>().businessLogoUrl;
    final showLogo = index == 3 && logoUrl.isNotEmpty;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: _kIconBox,
              height: _kIconBox,
              child: Center(
                child: showLogo
                    ? _buildBusinessLogo(
                        url: logoUrl,
                        isSelected: isSelected,
                        selectedColor: selectedColor,
                        unselectedColor: unselectedColor)
                    : _buildIcon(
                        iconPath: iconPath,
                        fallbackIcon: fallbackIcon,
                        iconSize: iconSize,
                        isSelected: isSelected,
                        useColorFilter: useColorFilter,
                        color: color,
                        unselectedColor: unselectedColor,
                      ),
              ),
            ),
            const SizedBox(height: _kIconLabelGap),
            // Scaled down rather than cut off: "Marketplace" at 15px is wider than a
            // quarter of a 360px phone, and "Marketpl…" reads as a fault.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontSize: widget.labelSize ?? 13.0,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: color,
                        letterSpacing: 0.0,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessLogo(
      {required String url,
      required bool isSelected,
      required Color selectedColor,
      required Color unselectedColor}) {
    final fallback = Padding(
        padding: const EdgeInsets.all(5.0),
        child: Image.asset('assets/images/button_company_icon.png',
            fit: BoxFit.contain));
    return AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: _kIconBox,
        height: _kIconBox,
        padding: const EdgeInsets.all(1.5),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: isSelected ? selectedColor : unselectedColor,
                width: isSelected ? 2.0 : 1.0)),
        child: ClipOval(
            child: Container(
                color: Colors.white,
                child: Image.network(url,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) => fallback))));
  }

  Widget _buildIcon({
    required String iconPath,
    required IconData fallbackIcon,
    required double iconSize,
    required bool isSelected,
    required bool useColorFilter,
    required Color color,
    required Color unselectedColor,
  }) {
    if (iconPath.isEmpty) {
      return Icon(fallbackIcon, size: iconSize, color: color);
    }

    if (iconPath.toLowerCase().endsWith('.svg')) {
      final colorFilter = useColorFilter
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : (isSelected
              ? null
              : ColorFilter.mode(unselectedColor, BlendMode.srcIn));
      final inline = _inlineSvgs[iconPath];
      if (inline != null) {
        return SvgPicture.string(
          inline,
          width: iconSize,
          height: iconSize,
          fit: BoxFit.contain,
          colorFilter: colorFilter,
        );
      }
      return SvgPicture.asset(
        iconPath,
        width: iconSize,
        height: iconSize,
        fit: BoxFit.contain,
        // The same protection Image.asset below already had, and the reason the
        // bar needed it: a FlutterFlow export removed several SVGs from
        // assets/images while the code still named one of them, so the tab drew
        // nothing and every frame reported "Unable to load asset". A raster icon
        // in that position would have quietly shown the fallback; the vector one
        // had nowhere to fall back to.
        placeholderBuilder: (_) =>
            Icon(fallbackIcon, size: iconSize, color: color),
        colorFilter: colorFilter,
      );
    }

    return Image.asset(
      iconPath,
      width: iconSize,
      height: iconSize,
      fit: BoxFit.contain,
      color: useColorFilter ? color : (isSelected ? null : unselectedColor),
      errorBuilder: (context, error, stackTrace) =>
          Icon(fallbackIcon, size: iconSize, color: color),
    );
  }
}
