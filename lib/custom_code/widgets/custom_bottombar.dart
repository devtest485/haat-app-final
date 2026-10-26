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

/// Live CustomBottombar ka tab switcher. Bar khud isay initState me set karta
/// hai aur dispose par clear kar deta hai. Widget self-contained hai — koi
/// alag custom action file zaroori nahi.
void Function(int index)? _bottomTabNavigator;

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
        // Bar ab har tab par (mystore par bhi) dikhta hai, is liye sab tabs ke
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
                  selectedIcon: '',
                  unselectedIcon: '',
                  useColorFilter: true,
                  iconSize: 28,
                  fallbackIcon: Icons.home_rounded,
                ),
                _buildNavItem(
                  index: 1,
                  label: widget.cashierLabel ?? 'Cashier',
                  selectedIcon: 'assets/images/local_mall.svg',
                  unselectedIcon: 'assets/images/local_mall.svg',
                  useColorFilter: true,
                  iconSize: 28,
                  fallbackIcon: Icons.shopping_bag_outlined,
                ),
                _buildNavItem(
                  index: 2,
                  label: widget.servicesLabel ?? 'Services',
                  selectedIcon: '',
                  unselectedIcon: '',
                  useColorFilter: true,
                  iconSize: 28,
                  fallbackIcon: Icons.storefront_outlined,
                ),
                _buildNavItem(
                  index: 3,
                  label: widget.storeLabel ?? 'mystore',
                  // add_business.svg went with a FlutterFlow export.
                  // add_business_white.svg is the same mark and is still
                  // bundled; useColorFilter tints it either way, so "white"
                  // describes the file rather than what appears on screen.
                  selectedIcon: 'assets/images/add_business_white.svg',
                  unselectedIcon: 'assets/images/add_business_white.svg',
                  useColorFilter: true,
                  iconSize: 28,
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
                child: _buildIcon(
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
        colorFilter: useColorFilter
            ? ColorFilter.mode(color, BlendMode.srcIn)
            : (isSelected
                ? null
                : ColorFilter.mode(unselectedColor, BlendMode.srcIn)),
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
