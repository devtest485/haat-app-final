// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '/components/product_card/product_card_widget.dart';

/// The cart on the Cashier tab: a black bar that rises from the bottom once something
/// is in it, and opens into the black Checkout screen when Charge is tapped.
///
/// ## Where it goes
///
/// Last in the page's Stack, the full size of the page. Collapsed, only the bar takes
/// touches — the rest of it is empty space, so the product grid underneath keeps
/// working. Open, it covers the page, back button included; tapping the products
/// peeking at the top, or the system back gesture, closes it again.
///
/// ## What it is given
///
/// [cart] is the page state the product cards write — lines of `id`, `name`, `unit`,
/// `priceMinor`, `imageUrl` and `qty`, as `cartToggle` makes them. [products] is the
/// page's product list, the first row of which peeks over the Checkout screen. The
/// widget only reads them. Charge on the open screen calls [onCharge] with the total
/// in minor units, and the page takes it from there.
///
/// ## The animation
///
/// The bar's own rectangle is stretched to the screen's, the Charge button rising with
/// its bottom edge, while the Cashier screen drops back in at the top as a strip of
/// the product grid with rounded corners — the way back to it.
class AddProductBar extends StatefulWidget {
  const AddProductBar({
    super.key,
    this.width,
    this.height,
    this.cart,
    this.products,
    this.currency,
    this.bottomGap,
    this.onCharge,
  });

  final double? width;
  final double? height;
  final List<dynamic>? cart;

  /// The page's products; the first two peek over the open Checkout screen.
  final List<dynamic>? products;

  /// Written beside every amount; SDG when empty.
  final String? currency;

  /// Space under the collapsed bar, above the safe area. 35 when not set.
  final double? bottomGap;
  final Future Function(String totalMinor)? onCharge;

  @override
  State<AddProductBar> createState() => _AddProductBarState();
}

class _AddProductBarState extends State<AddProductBar>
    with TickerProviderStateMixin {
  static const double _barHeight = 70;
  static const double _sideGap = 15;
  static const Color _muted = Color(0xFFABB1BB);
  static const Color _pageColor = Color(0xFFF5F5F7);

  /// How far the Cashier peek reaches below the status bar.
  static const double _peekBelowSafeArea = 54;

  /// How much of the product cards shows in the peek.
  static const double _peekShown = 100;

  late final AnimationController _expand = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
    reverseDuration: const Duration(milliseconds: 420),
  );

  late final AnimationController _presence = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
    reverseDuration: const Duration(milliseconds: 240),
  );

  /// What is drawn. Kept from the last cart that had something in it, so the bar
  /// slides away still showing its last total rather than "0 items".
  List<Map> _lines = const [];
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _lines = _read(widget.cart);
    if (_lines.isNotEmpty) _presence.value = 1;
  }

  @override
  void didUpdateWidget(covariant AddProductBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    final lines = _read(widget.cart);
    if (lines.isNotEmpty) {
      _lines = lines;
      _presence.forward();
    } else {
      _presence.reverse();
      if (_open) _setOpen(false);
    }
  }

  @override
  void dispose() {
    _expand.dispose();
    _presence.dispose();
    super.dispose();
  }

  static List<Map> _read(List<dynamic>? cart) =>
      (cart ?? const []).whereType<Map>().toList();

  void _setOpen(bool open) {
    if (_open == open) return;
    setState(() => _open = open);

    if (open) HapticFeedback.selectionClick();

    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      _expand.value = open ? 1 : 0;
    } else if (open) {
      _expand.forward();
    } else {
      _expand.reverse();
    }
  }

  // ── Figures ───────────────────────────────────────────────────────────────────

  String get _currency {
    final code = (widget.currency ?? '').trim();
    return code.isEmpty ? 'SDG' : code;
  }

  static int _qty(Map line) => int.tryParse('${line['qty']}') ?? 0;

  static BigInt _price(Map line) =>
      BigInt.tryParse('${line['priceMinor']}'.trim()) ?? BigInt.zero;

  int get _count => _lines.fold(0, (sum, line) => sum + _qty(line));

  BigInt get _total => _lines.fold(
        BigInt.zero,
        (sum, line) => sum + _price(line) * BigInt.from(_qty(line)),
      );

  /// `300000` reads `3,000`; `125050` reads `1,250.50`.
  static String _money(BigInt minor) {
    final hundred = BigInt.from(100);
    final major = (minor ~/ hundred).toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+$)'),
          (match) => '${match[1]},',
        );
    final cents = (minor % hundred).toInt();

    return cents == 0 ? major : '$major.${cents.toString().padLeft(2, '0')}';
  }

  String get _itemsLabel => _count == 1 ? '1 item' : '$_count items';

  /// The Checkout screen's type: Outfit, with the line height in pixels.
  static TextStyle _outfit(
    double size,
    FontWeight weight,
    double lineHeight, {
    Color color = Colors.white,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.outfit(
      color: color,
      fontSize: size,
      fontWeight: weight,
      height: lineHeight / size,
      letterSpacing: letterSpacing,
    );
  }

  // ── Drawing ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_open,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _setOpen(false);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(
            constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.sizeOf(context).width,
            constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : MediaQuery.sizeOf(context).height,
          );

          return SizedBox(
            width: size.width,
            height: size.height,
            child: AnimatedBuilder(
              animation: Listenable.merge([_expand, _presence]),
              builder: (context, _) => _frame(context, size),
            ),
          );
        },
      ),
    );
  }

  Widget _frame(BuildContext context, Size size) {
    if (_presence.value == 0 && _expand.value == 0) {
      return const SizedBox.shrink();
    }

    final safe = MediaQuery.paddingOf(context);
    final t = Curves.easeInOutCubic.transform(_expand.value);
    final shown = Curves.easeOutCubic.transform(_presence.value);
    final gap = (widget.bottomGap ?? 35) + safe.bottom;
    final peekBottom = safe.top + _peekBelowSafeArea;
    final peekIn = const Interval(0.35, 1, curve: Curves.easeOutCubic)
        .transform(_expand.value);

    final collapsed = Rect.fromLTRB(
      _sideGap,
      size.height - gap - _barHeight,
      size.width - _sideGap,
      size.height - gap,
    );
    final rect = Rect.lerp(collapsed, Offset.zero & size, t)!;
    final drop = (1 - shown) * (_barHeight + gap + 24);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fromRect(
          rect: rect.shift(Offset(0, drop)),
          child: Material(
            color: FlutterFlowTheme.of(context).primaryBackground,
            borderRadius: BorderRadius.circular(lerpDouble(12, 0, t)!),
            clipBehavior: Clip.antiAlias,
            elevation: lerpDouble(6, 0, t)!,
            shadowColor: const Color(0x40000000),
            child: Stack(
              children: [
                if (t > 0)
                  Positioned.fill(
                    child: OverflowBox(
                      alignment: Alignment.bottomCenter,
                      minWidth: size.width,
                      maxWidth: size.width,
                      minHeight: size.height,
                      maxHeight: size.height,
                      child: _body(context, t, peekBottom, safe.bottom),
                    ),
                  ),
                if (t < 1)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: _barHeight,
                    child: Opacity(
                      opacity: (1 - t * 2.5).clamp(0.0, 1.0),
                      child: IgnorePointer(ignoring: _open, child: _head()),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (peekIn > 0)
          Positioned(
            left: 0,
            right: 0,
            top: -(peekBottom + 24) * (1 - peekIn),
            height: peekBottom,
            child: _peek(size, peekBottom),
          ),
      ],
    );
  }

  /// The collapsed bar: thumbnails, the count and total, and Charge.
  Widget _head() {
    return InkWell(
      onTap: _open ? null : () => _setOpen(true),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(_sideGap, 0, _sideGap, 0),
        child: Row(
          children: [
            _thumbs(),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _itemsLabel,
                    style: GoogleFonts.montserrat(
                      color: _muted,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: _amount(_total, 14, 9),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            _chargePill(),
          ],
        ),
      ),
    );
  }

  Widget _chargePill() {
    return GestureDetector(
      onTap: () => _setOpen(true),
      child: Container(
        width: 88,
        height: 32.5,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          'Charge',
          style: GoogleFonts.montserrat(
            color: FlutterFlowTheme.of(context).primaryBackground,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Up to three photos, overlapping, and a count for the rest.
  Widget _thumbs() {
    const side = 34.0;
    const step = 22.0;
    final shown = _lines.take(3).toList();
    final rest = _lines.length - shown.length;
    final tiles = shown.length + (rest > 0 ? 1 : 0);

    return SizedBox(
      width: side + step * (tiles - 1),
      height: side,
      child: Stack(
        children: [
          for (var i = 0; i < shown.length; i++)
            PositionedDirectional(
              start: step * i,
              child: _tile(shown[i], side, 9, border: true),
            ),
          if (rest > 0)
            PositionedDirectional(
              start: step * shown.length,
              child: Container(
                width: side,
                height: side,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2C30),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    width: 2,
                  ),
                ),
                child: Text(
                  '+$rest',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _tile(Map line, double side, double radius, {bool border = false}) {
    final url = '${line['imageUrl'] ?? ''}';

    return Container(
      width: side,
      height: side,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: border
            ? Border.all(
                color: FlutterFlowTheme.of(context).primaryBackground,
                width: 2,
              )
            : null,
      ),
      child: url.isEmpty
          ? const Icon(Icons.local_cafe_outlined,
              color: Color(0x40000000), size: 16)
          : Image.network(
              url,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stack) => const SizedBox(),
            ),
    );
  }

  /// `6,000` large and `SDG` small, as the bar writes every amount.
  Widget _amount(BigInt minor, double size, double currencySize,
      {Color color = Colors.white}) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '${_money(minor)} ',
            style: GoogleFonts.montserrat(
              color: color,
              fontSize: size,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: _currency,
            style: GoogleFonts.montserrat(
              color: color,
              fontSize: currencySize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      maxLines: 1,
    );
  }

  // ── The open Checkout screen ──────────────────────────────────────────────────

  /// The foot of the Cashier screen, held at the top: the first row of products, as
  /// the grid draws them. Tapping it goes back.
  Widget _peek(Size size, double height) {
    const gutter = 10.0;
    final cardWidth = (size.width - _sideGap * 2 - gutter) / 2;
    final cards = _peekCards();

    return Semantics(
      button: true,
      label: 'Back to products',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _setOpen(false),
        child: ClipRRect(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(20)),
          child: ColoredBox(
            color: _pageColor,
            child: IgnorePointer(
              child: Stack(
                children: [
                  for (var i = 0; i < cards.length; i++)
                    Positioned(
                      left: _sideGap + i * (cardWidth + gutter),
                      top: height - _peekShown,
                      width: cardWidth,
                      // The grid's own shape, so the cards read as the same cards.
                      height: cardWidth / 0.79,
                      child: cards[i],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// The grid's first two products; the cart's, when the page passes none.
  List<Widget> _peekCards() {
    final cart = widget.cart?.toList() ?? [];
    final products = (widget.products ?? const []).take(2).toList();

    if (products.isNotEmpty) {
      return [
        for (final product in products)
          ProductCardWidget(
            name: '${getJsonField(product, r'$.name') ?? ''}',
            priceLabel: moneyLabel('${getJsonField(product, r'$.priceMinor')}'),
            unit: '${getJsonField(product, r'$.unit') ?? ''}',
            imageUrl: bannerImageUrl(
              getJsonField(product, r'$.imagePath')?.toString(),
              FFDevEnvironmentValues().baseURL,
            ),
            quantity: cartQuantity(cart, '${getJsonField(product, r'$.id')}'),
            selected: productInCart(cart, '${getJsonField(product, r'$.id')}'),
          ),
      ];
    }

    return [
      for (final line in _lines.take(2))
        ProductCardWidget(
          name: '${line['name'] ?? ''}',
          priceLabel: moneyLabel('${line['priceMinor']}'),
          unit: '${line['unit'] ?? ''}',
          imageUrl: '${line['imageUrl'] ?? ''}',
          quantity: _qty(line),
          selected: true,
        ),
    ];
  }

  /// Everything under the peek: Cart, its lines, the total and Charge.
  Widget _body(
      BuildContext context, double t, double peekBottom, double bottomInset) {
    final reveal = const Interval(0.45, 1, curve: Curves.easeOut).transform(t);

    return Opacity(
      opacity: reveal,
      child: Transform.translate(
        offset: Offset(0, 28 * (1 - reveal)),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            peekBottom + 38,
            24,
            math.max(bottomInset + 10, 24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Cart',
                style: _outfit(30, FontWeight.w700, 26, letterSpacing: -0.3),
              ),
              const SizedBox(height: 28),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: _lines.length,
                  separatorBuilder: (context, _) => const SizedBox(height: 24),
                  itemBuilder: (context, index) => _row(_lines[index]),
                ),
              ),
              const SizedBox(height: 16),
              _totalRow(),
              const SizedBox(height: 44),
              _chargeButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(Map line) {
    final qty = _qty(line);

    return SizedBox(
      height: 48,
      child: Row(
        children: [
          _thumb(line),
          const SizedBox(width: 12),
          SizedBox(
            width: 28,
            child: Text(
              '$qty ×',
              maxLines: 1,
              softWrap: false,
              style: _outfit(13, FontWeight.w700, 15),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${line['name'] ?? ''}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: _outfit(15, FontWeight.w400, 20),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${_money(_price(line) * BigInt.from(qty))} $_currency',
            maxLines: 1,
            style: _outfit(14, FontWeight.w400, 18, color: _muted),
          ),
        ],
      ),
    );
  }

  /// The product's photo in a white circle.
  Widget _thumb(Map line) {
    final url = '${line['imageUrl'] ?? ''}';

    return Container(
      width: 48,
      height: 48,
      padding: const EdgeInsets.all(6),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: url.isEmpty
          ? const Icon(Icons.local_cafe_outlined,
              color: Color(0x40000000), size: 20)
          : ClipOval(
              child: Image.network(
                url,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stack) => const SizedBox(),
              ),
            ),
    );
  }

  Widget _totalRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text('Total', style: _outfit(18, FontWeight.w500, 26, color: _muted)),
        const SizedBox(width: 16),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerEnd,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${_money(_total)} ',
                    style: _outfit(31.26, FontWeight.w700, 31),
                  ),
                  TextSpan(
                    text: _currency,
                    style: _outfit(13.4, FontWeight.w700, 19),
                  ),
                ],
              ),
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _chargeButton() {
    final total = _total;
    final enabled = total > BigInt.zero;

    return Semantics(
      button: true,
      enabled: enabled,
      child: Material(
        color: enabled ? Colors.white : const Color(0xFF262626),
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: !enabled
              ? null
              : () async {
                  HapticFeedback.lightImpact();
                  await widget.onCharge?.call(total.toString());
                },
          child: SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Charge ${_money(total)} $_currency',
                    maxLines: 1,
                    style: _outfit(
                      18,
                      FontWeight.w700,
                      26,
                      color: enabled ? Colors.black : const Color(0xFF808080),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
