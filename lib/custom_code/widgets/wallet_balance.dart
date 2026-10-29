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

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/wallet_api.dart';

/// The home screen's balance, from the books, kept current while the screen
/// is open.
///
/// It was `24,580.00 SDG`, drawn into the app — the same figure on every
/// merchant's home screen, including one who had never taken a payment. This
/// is what the business can actually spend: the available balance across its
/// banks.
///
/// The app has no push channel for the books, so the wallet is read again
/// every [refreshSeconds] and whenever the app comes back to the foreground.
/// When the figure moves, it counts from the old balance to the new one
/// rather than jumping. Money coming in is called out beside it for a few
/// seconds in green (Received), and money going out in yellow (Sent).
/// [onBalanceChanged] lets the page reload what depends on the balance — the
/// last transactions under it.
///
/// Until the figure arrives it shows a dash rather than a zero, because a
/// zero is a balance and a dash is not yet knowing one.
class WalletBalance extends StatefulWidget {
  const WalletBalance({
    super.key,
    this.width,
    this.height,
    this.hidden,
    this.refreshSeconds,
    this.onBalanceChanged,
  });

  final double? width;
  final double? height;

  /// Masks the figure, for the eye toggle beside it.
  final bool? hidden;
  final int? refreshSeconds;
  final Future Function()? onBalanceChanged;

  @override
  State<WalletBalance> createState() => _WalletBalanceState();
}

class _WalletBalanceState extends State<WalletBalance>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  /// Paise aaye (receive) to green.
  static const _received = Color(0xFF00DA76);

  /// Paise gaye (send) to yellow.
  static const _sent = Color(0xFFFFC21A);

  Wallet? _wallet;

  /// Where the count starts from; the end is always the wallet's own figure.
  BigInt _from = BigInt.zero;

  /// Amount of the last change (always positive), for the note beside the figure.
  BigInt? _noteAmount;

  /// true = received (green), false = sent (yellow).
  bool _noteIncoming = true;

  Timer? _poll;
  Timer? _noteTimer;
  bool _loading = false;

  late final AnimationController _count = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );
  late final AnimationController _note = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
    reverseDuration: const Duration(milliseconds: 240),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _count.value = 1;
    _load();
    _startPolling();
  }

  @override
  void didUpdateWidget(covariant WalletBalance oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshSeconds != widget.refreshSeconds) _startPolling();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Money that came in while the app was in the background shows the moment it is
    // opened, not up to a poll later.
    if (state == AppLifecycleState.resumed) _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _poll?.cancel();
    _noteTimer?.cancel();
    _count.dispose();
    _note.dispose();
    super.dispose();
  }

  void _startPolling() {
    _poll?.cancel();
    final seconds = (widget.refreshSeconds ?? 15).clamp(5, 600);
    _poll = Timer.periodic(Duration(seconds: seconds), (_) => _load());
  }

  Future<void> _load() async {
    if (_loading) return;
    _loading = true;

    try {
      final result = await AuthSession.instance.wallet.get();
      if (!mounted || result is! ApiSuccess<Wallet>) return;

      final next = result.value;
      final previous = _wallet;

      // The number under the balance is the wallet's own. Written here because this is
      // where the wallet is read; the line beneath listens to App State for it.
      if (FFAppState().bban != next.displayNumber) {
        FFAppState().update(() => FFAppState().bban = next.displayNumber);
      }

      if (previous == null) {
        setState(() => _wallet = next);
        return;
      }

      if (previous.available == next.available &&
          previous.currency == next.currency) {
        _wallet = next;
        return;
      }

      final change = next.available - previous.available;
      final sameCurrency = previous.currency == next.currency;

      // Pehle note ki direction set karo taake count ke dauran rang sahi ho.
      if (sameCurrency && change != BigInt.zero) {
        _noteIncoming = change > BigInt.zero;
        _noteAmount = change.abs();
      }

      setState(() {
        _from = _shown(previous);
        _wallet = next;
      });
      _count.forward(from: 0);

      if (sameCurrency && change != BigInt.zero) {
        _announce(change.abs(), incoming: change > BigInt.zero);
      }

      await widget.onBalanceChanged?.call();
    } finally {
      _loading = false;
    }
  }

  void _announce(BigInt amount, {required bool incoming}) {
    HapticFeedback.lightImpact();
    setState(() {
      _noteAmount = amount;
      _noteIncoming = incoming;
    });
    _note.forward(from: 0);

    _noteTimer?.cancel();
    _noteTimer = Timer(const Duration(seconds: 6), () {
      if (mounted) _note.reverse();
    });
  }

  /// The figure on screen right now — mid-count if a count is running.
  BigInt _shown(Wallet wallet) {
    final t = Curves.easeOutCubic.transform(_count.value);
    if (t >= 1) return wallet.available;

    final delta = (wallet.available - _from).toDouble();
    return _from + BigInt.from((delta * t).round());
  }

  TextStyle _style(BuildContext context, double size, Color color,
          [FontWeight weight = FontWeight.w300]) =>
      FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.inter(
              fontWeight: weight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            color: color,
            fontSize: size,
            letterSpacing: 0.0,
            fontWeight: weight,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          );

  Widget _figure(BuildContext context, Wallet? wallet) {
    final ink = FlutterFlowTheme.of(context).primaryText;

    if (wallet == null) return Text('—', style: _style(context, 42, ink));

    if (widget.hidden ?? false) {
      return RichText(
        textScaler: MediaQuery.of(context).textScaler,
        text: TextSpan(children: [
          TextSpan(text: '******', style: _style(context, 42, ink)),
          TextSpan(
              text: ' ${wallet.currency}', style: _style(context, 18, ink)),
        ]),
      );
    }

    return AnimatedBuilder(
      animation: _count,
      builder: (context, _) {
        final (whole, fraction) = splitMinor(_shown(wallet), wallet.currency);

        // Count chalte waqt rang: receive par green, send par yellow, phir
        // dheere dheere normal ink par wapis.
        final changing = _noteAmount != null && _count.isAnimating;
        final tint = _noteIncoming ? _received : _sent;
        final color = changing
            ? Color.lerp(tint, ink, Curves.easeIn.transform(_count.value))!
            : ink;

        return RichText(
          textScaler: MediaQuery.of(context).textScaler,
          text: TextSpan(
            children: [
              TextSpan(text: whole, style: _style(context, 42, color)),
              TextSpan(
                text: '$fraction ${wallet.currency}',
                style: _style(context, 18, color),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Balance ke bagal ka pill: Received (green, neeche-left arrow) ya
  /// Sent (yellow, upar-right arrow).
  Widget _changeNote(BuildContext context, Wallet? wallet) {
    final amount = _noteAmount;
    if (wallet == null || amount == null) return const SizedBox.shrink();

    final incoming = _noteIncoming;
    final tone = incoming ? _received : _sent;

    final (whole, fraction) = splitMinor(amount, wallet.currency);
    final sign = incoming ? '+' : '-';
    final label = (widget.hidden ?? false)
        ? (incoming ? 'Received' : 'Sent')
        : '$sign$whole${fraction == '.00' ? '' : fraction}';

    final curve = CurvedAnimation(
      parent: _note,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
    );

    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: _note, curve: Curves.easeOutCubic),
      axis: Axis.horizontal,
      alignment: AlignmentDirectional.centerStart,
      child: FadeTransition(
        opacity: _note,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-0.25, 0),
            end: Offset.zero,
          ).animate(curve),
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 10),
            child: Container(
              padding: const EdgeInsetsDirectional.fromSTEB(7, 4, 9, 4),
              decoration: BoxDecoration(
                color: tone.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: tone.withValues(alpha: 0.35)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    incoming
                        ? Icons.south_west_rounded
                        : Icons.north_east_rounded,
                    size: 12,
                    color: tone,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    label,
                    maxLines: 1,
                    style: _style(context, 12, tone, FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wallet = _wallet;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: _figure(context, wallet),
            ),
          ),
          _changeNote(context, wallet),
        ],
      ),
    );
  }
}
