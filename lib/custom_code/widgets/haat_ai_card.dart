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

import 'package:google_fonts/google_fonts.dart';

/// HAAT AI card.
///
/// Card me sirf: background image (poore card par), "Hi <name>," + subtitle,
/// aur neeche "Ask HAAT Ai" field. Glow / logo / extra image is widget me
/// nahi hai — jo bhi image aap `bgImageUrl` me doge wahi poore card ka bg
/// banegi.
///
/// Enter ya send button dabane par poori screen ka BLACK chat page khulta hai
/// (hamesha full height, parent ki height se koi farq nahi padta): * user ka
/// message right side par top me, * AI ke jawab ka intezar dikhane wale dots,
/// * `aiReply` badalte hi AI ka jawab left side par add.
///
/// FlutterFlow me parameters: width, height      -> double  (default 363 x
/// 390) bgImageUrl         -> String  (image ka URL ya assets path; khali =
/// black bg) logoUrl            -> String  (beech wala H logo; default
/// Haat_Logo.png, khali = logo nahi) userName           -> String  (default
/// "Ahmed") subtitle           -> String  (default "what should we grow
/// today?") placeholder        -> String  (default "Ask HAAT Ai") aiReply
///        -> String  (API ka jawab) onMessageSent      -> Action(String
/// message)   (yahan API call lagao) onExpandedChanged  -> Action(bool
/// isExpanded)  (chat khulne / band hone par)
class HaatAiCard extends StatefulWidget {
  const HaatAiCard({
    super.key,
    this.width,
    this.height,
    this.bgImageUrl,
    this.logoUrl,
    this.userName,
    this.subtitle,
    this.placeholder,
    this.aiReply,
    this.onMessageSent,
    this.onExpandedChanged,
  });

  final double? width;
  final double? height;
  final String? bgImageUrl;
  final String? logoUrl;
  final String? userName;
  final String? subtitle;
  final String? placeholder;
  final String? aiReply;
  final Future Function(String message)? onMessageSent;
  final Future Function(bool isExpanded)? onExpandedChanged;

  @override
  State<HaatAiCard> createState() => _HaatAiCardState();
}

// ---------------------------------------------------------------------------
// Shared colors / helpers
// ---------------------------------------------------------------------------

const Color _kGreen = Color(0xFF00DA76);
const Color _kGrayText = Color(0xFFABB1BB);
const Color _kSendIcon = Color(0xFF001A0E);
const Color _kFieldBg = Color(0x0DFFFFFF); // rgba(255,255,255,0.05)

class _ChatMessage {
  const _ChatMessage(this.text, {required this.isUser});
  final String text;
  final bool isUser;
}

/// Card aur full-screen chat page ke beech shared chat state.
class _ChatSession extends ChangeNotifier {
  final List<_ChatMessage> messages = [];
  bool loading = false;

  void addUser(String text) {
    messages.add(_ChatMessage(text, isUser: true));
    loading = true;
    notifyListeners();
  }

  void addAi(String text) {
    messages.add(_ChatMessage(text, isUser: false));
    loading = false;
    notifyListeners();
  }

  void clear() {
    messages.clear();
    loading = false;
    notifyListeners();
  }
}

// ---------------------------------------------------------------------------
// Card
// ---------------------------------------------------------------------------

class _HaatAiCardState extends State<HaatAiCard> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _ChatSession _session = _ChatSession();

  final GlobalKey _cardKey = GlobalKey();
  bool _chatOpen = false;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _session.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant HaatAiCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final reply = widget.aiReply;
    if (reply != oldWidget.aiReply &&
        reply != null &&
        reply.trim().isNotEmpty) {
      // Build ke dauran notify nahi kar sakte, is liye frame ke baad.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _session.addAi(reply.trim());
      });
    }
  }

  void _submit(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return;

    _session.addUser(text);
    _openChat();

    if (widget.onMessageSent != null) {
      // API yahan se call hogi, jawab `aiReply` se wapas aayega.
      widget.onMessageSent!.call(text);
    } else {
      // API abhi attach nahi hai — sirf preview ke liye demo jawab.
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted || !_session.loading) return;
        _session.addAi('API connect hone ke baad yahan AI ka jawab aayega.');
      });
    }
  }

  void _submitFromCard() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    _controller.clear();
    _focusNode.unfocus();
    _submit(text);
  }

  /// Card ki current jagah (root Navigator ke coordinates me) — isi se
  /// open/close animation shuru aur khatam hoti hai.
  Rect? _cardRect() {
    final cardBox = _cardKey.currentContext?.findRenderObject();
    final navBox =
        Navigator.of(context, rootNavigator: true).context.findRenderObject();
    if (cardBox is! RenderBox || !cardBox.hasSize) return null;
    if (navBox is! RenderBox || !navBox.hasSize) return null;
    final topLeft = navBox.globalToLocal(cardBox.localToGlobal(Offset.zero));
    return topLeft & cardBox.size;
  }

  void _openChat() {
    if (_chatOpen) return;
    _chatOpen = true;
    widget.onExpandedChanged?.call(true);

    final startRect = _cardRect();

    Navigator.of(context, rootNavigator: true)
        .push(
      PageRouteBuilder(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 500),
        reverseTransitionDuration: const Duration(milliseconds: 420),
        pageBuilder: (_, __, ___) => _HaatChatPage(
          session: _session,
          placeholder: _placeholder,
          onSend: _submit,
        ),
        transitionsBuilder: (context, animation, _, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              final full = Offset.zero & constraints.biggest;
              final from = startRect ?? full;

              return AnimatedBuilder(
                animation: animation,
                builder: (context, _) {
                  final v = animation.value;
                  // Card ka rect -> poori screen (width aur height dono badhti hain).
                  final t = Curves.easeInOutCubic.transform(v);
                  final rect = Rect.lerp(from, full, t)!;
                  final radius = 10.0 * (1 - t);
                  // Black bg jaldi aata hai, content baad me fade-in hota hai.
                  final bgAlpha = const Interval(0.0, 0.25).transform(v);
                  final contentAlpha = const Interval(
                    0.3,
                    1.0,
                    curve: Curves.easeOut,
                  ).transform(v);

                  return ClipPath(
                    clipper: _RevealClipper(rect: rect, radius: radius),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ColoredBox(
                          color: Colors.black.withValues(alpha: bgAlpha),
                        ),
                        Opacity(opacity: contentAlpha, child: child),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    )
        .then((_) {
      _chatOpen = false;
      _session.clear(); // naya chat
      widget.onExpandedChanged?.call(false);
    });
  }

  String get _placeholder => (widget.placeholder?.trim().isNotEmpty ?? false)
      ? widget.placeholder!.trim()
      : 'Ask HAAT Ai';

  double _resolve(
      double? given, double bounded, bool hasBounded, double design) {
    if (given != null && given.isFinite && given > 0) return given;
    if (hasBounded && bounded.isFinite) return bounded;
    return design;
  }

  // Figma export wali image ke around transparent glow/shadow ka margin hota hai
  // (isi se card ke andar "border" jaisa dikhta tha). Ye margin card se bahar
  // dhakel diya jata hai. Agar abhi bhi kinara dikhe to in numbers ko thoda
  // barhao, agar image ka kinara kat raha ho to ghatao.
  static const double _bgMarginL = 19;
  static const double _bgMarginR = 19;
  static const double _bgMarginT = 13;
  static const double _bgMarginB = 33;

  static const String _defaultLogoUrl =
      'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/haat-4d5muk/assets/if8j14yqbgl9/Haat_Logo.png';

  Widget _buildBackground(double w, double h) {
    final url = widget.bgImageUrl?.trim() ?? '';
    if (url.isEmpty) return const SizedBox.shrink();

    final isNetwork = url.startsWith('http://') || url.startsWith('https://');
    Widget errorBuilder(BuildContext _, Object __, StackTrace? ___) =>
        const SizedBox.shrink();

    // Image ke andar ka asli panel [L..W-R] x [T..H-B] hai; usay poore card par
    // phailane ke liye image ko itna bada karke shift karte hain.
    final sx = w / (w - _bgMarginL - _bgMarginR);
    final sy = h / (h - _bgMarginT - _bgMarginB);

    return Positioned(
      left: -_bgMarginL * sx,
      top: -_bgMarginT * sy,
      width: w * sx,
      height: h * sy,
      child: isNetwork
          ? Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: errorBuilder,
            )
          : Image.asset(
              url,
              fit: BoxFit.cover,
              errorBuilder: errorBuilder,
            ),
    );
  }

  Widget _buildLogo() {
    final raw = widget.logoUrl;
    // null = default logo, khali string = logo nahi
    final url = raw == null ? _defaultLogoUrl : raw.trim();
    if (url.isEmpty) return const SizedBox.shrink();

    final isNetwork = url.startsWith('http://') || url.startsWith('https://');
    Widget errorBuilder(BuildContext _, Object __, StackTrace? ___) =>
        const SizedBox.shrink();

    return Positioned(
      top: 241,
      left: 0,
      right: 0,
      child: Center(
        child: SizedBox(
          width: 27,
          height: 44,
          child: isNetwork
              ? Image.network(url,
                  fit: BoxFit.contain, errorBuilder: errorBuilder)
              : Image.asset(url,
                  fit: BoxFit.contain, errorBuilder: errorBuilder),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = _resolve(widget.width, constraints.maxWidth,
            constraints.hasBoundedWidth, 363);
        final h = _resolve(widget.height, constraints.maxHeight,
            constraints.hasBoundedHeight, 390);

        final name = (widget.userName?.trim().isNotEmpty ?? false)
            ? widget.userName!.trim()
            : 'Ahmed';
        final subtitle = (widget.subtitle?.trim().isNotEmpty ?? false)
            ? widget.subtitle!.trim()
            : 'what should we grow today?';

        return Container(
          key: _cardKey,
          width: w,
          height: h,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              _buildBackground(w, h),
              _buildLogo(),

              // Titles
              Positioned(
                top: 28,
                left: 12,
                right: 12,
                child: Column(
                  children: [
                    SizedBox(
                      height: 26,
                      child: Text(
                        'Hi $name,',
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          height: 26 / 18,
                          fontWeight: FontWeight.w700,
                          color: _kGrayText,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 26,
                      child: Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          height: 26 / 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Ask field
              Positioned(
                left: 12,
                right: 12,
                bottom: 24,
                height: 48,
                child: _AskField(
                  controller: _controller,
                  focusNode: _focusNode,
                  hint: _placeholder,
                  onSubmit: _submitFromCard,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Ask field (card aur chat page dono me same)
// ---------------------------------------------------------------------------

class _AskField extends StatelessWidget {
  const _AskField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    required this.onSubmit,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final VoidCallback onSubmit;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _GradientBorderPainter(),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 6, 0),
        decoration: BoxDecoration(
          color: _kFieldBg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: autofocus,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSubmit(),
                cursorColor: _kGreen,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  height: 18 / 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: hint,
                  hintStyle: GoogleFonts.outfit(
                    fontSize: 14,
                    height: 18 / 14,
                    fontWeight: FontWeight.w400,
                    color: _kGrayText,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onSubmit,
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: _kGreen,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Transform.rotate(
                  angle: -0.65,
                  child: const Icon(
                    Icons.send_outlined,
                    size: 16,
                    color: _kSendIcon,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Input ka border: left se bright white, right ki taraf dull hota hua.
class _GradientBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 1.2;
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(strokeWidth / 2),
      Radius.circular(size.height / 2),
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = const LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [Color(0xF2FFFFFF), Color(0x66FFFFFF), Color(0x14FFFFFF)],
        stops: [0.0, 0.55, 1.0],
      ).createShader(rect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Full-screen black chat page
// ---------------------------------------------------------------------------

class _HaatChatPage extends StatefulWidget {
  const _HaatChatPage({
    required this.session,
    required this.placeholder,
    required this.onSend,
  });

  final _ChatSession session;
  final String placeholder;
  final void Function(String text) onSend;

  @override
  State<_HaatChatPage> createState() => _HaatChatPageState();
}

class _HaatChatPageState extends State<_HaatChatPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.session.addListener(_scrollToEnd);
    _scrollToEnd();
  }

  Animation<double>? _routeAnimation;
  bool _focusScheduled = false;

  void _onRouteAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      _focusNode.requestFocus();
      _routeAnimation?.removeStatusListener(_onRouteAnimationStatus);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_focusScheduled) return;
    _focusScheduled = true;
    // Keyboard animation khatam hone ke baad kholo, taake open animation smooth rahe.
    final anim = ModalRoute.of(context)?.animation;
    if (anim == null || anim.isCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    } else {
      _routeAnimation = anim;
      anim.addStatusListener(_onRouteAnimationStatus);
    }
  }

  @override
  void dispose() {
    _routeAnimation?.removeStatusListener(_onRouteAnimationStatus);
    widget.session.removeListener(_scrollToEnd);
    _controller.dispose();
    _focusNode.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    widget.onSend(text);
    // Enter ke baad keyboard khula rahe
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 8, 4),
              child: Row(
                children: [
                  Text(
                    'HAAT AI',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).maybePop();
                    },
                    icon: const Icon(Icons.close_rounded,
                        color: Colors.white, size: 22),
                  ),
                ],
              ),
            ),

            // Messages
            Expanded(
              child: AnimatedBuilder(
                animation: widget.session,
                builder: (context, _) {
                  final messages = widget.session.messages;
                  final loading = widget.session.loading;
                  return ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                    itemCount: messages.length + (loading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= messages.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: _TypingDots(color: _kGrayText),
                          ),
                        );
                      }
                      return _buildMessage(
                        messages[index],
                        MediaQuery.of(context).size.width - 32,
                      );
                    },
                  );
                },
              ),
            ),

            // Input
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: SizedBox(
                height: 48,
                child: _AskField(
                  controller: _controller,
                  focusNode: _focusNode,
                  hint: widget.placeholder,
                  onSubmit: _send,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(_ChatMessage msg, double maxWidth) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(
          offset: Offset(msg.isUser ? 16 * (1 - v) : 0, 14 * (1 - v)),
          child: child,
        ),
      ),
      child: _buildMessageBody(msg, maxWidth),
    );
  }

  Widget _buildMessageBody(_ChatMessage msg, double maxWidth) {
    if (msg.isUser) {
      // User ka message: right side
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth * 0.8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0x1FFFFFFF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: Text(
              msg.text,
              style: GoogleFonts.outfit(
                fontSize: 15,
                height: 1.35,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }

    // AI ka jawab: left side
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth * 0.92),
          child: SelectableText(
            msg.text,
            style: GoogleFonts.outfit(
              fontSize: 15,
              height: 1.45,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Card ke rect se poori screen tak phailne wala rounded clip.
class _RevealClipper extends CustomClipper<Path> {
  _RevealClipper({required this.rect, required this.radius});
  final Rect rect;
  final double radius;

  @override
  Path getClip(Size size) =>
      Path()..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));

  @override
  bool shouldReclip(covariant _RevealClipper old) =>
      old.rect != rect || old.radius != radius;
}

// ---------------------------------------------------------------------------
// Typing dots
// ---------------------------------------------------------------------------

class _TypingDots extends StatefulWidget {
  const _TypingDots({required this.color});
  final Color color;

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final t = (_c.value - i * 0.18) % 1.0;
            final wave = t < 0.5 ? t * 2 : (1 - t) * 2; // 0..1..0
            return Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.35 + 0.65 * wave),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}