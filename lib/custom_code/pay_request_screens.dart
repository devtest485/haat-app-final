import 'dart:async';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '/components/no_internet/no_internet_widget.dart';
import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/authorize_dialog.dart';
import '/custom_code/pay_request_api.dart';
import '/custom_code/payout_api.dart' show toMinor;
import '/custom_code/transfer_api.dart';
import '/custom_code/wallet_api.dart';
import '/custom_code/widgets/wallet_balance.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/payment_status/payment_error/payment_error_widget.dart';
import '/payment_status/payment_pending/payment_pending_widget.dart';
import '/payment_status/payment_success/payment_success_widget.dart';

const _page = Color(0xFFF5F5F7);
const _ink = Color(0xFF111111);
const _muted = Color(0xFF6B6B72);
const _hairline = Color(0xFFE4E4E9);
const _green = Color(0xFF00794A);
const _greenSoft = Color(0xFFE6F2ED);
const _danger = Color(0xFFD93025);
const _dangerSoft = Color(0xFFFCECEA);
const _amber = Color(0xFFB26A00);
const _amberSoft = Color(0xFFFFF4E0);

TextStyle _type(
  double size, {
  FontWeight weight = FontWeight.w500,
  Color color = _ink,
  double? height,
  double spacing = 0,
}) =>
    GoogleFonts.montserrat(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: spacing,
    );

String _money(BigInt minor, String currency) {
  final (whole, fraction) = splitMinor(minor, currency);
  return '$whole$fraction $currency';
}

String _shortReference(String id) => id.split('-').first.toUpperCase();

String _clock(Duration left) {
  final seconds = left.inSeconds.clamp(0, 359999);
  final h = seconds ~/ 3600;
  final m = (seconds % 3600) ~/ 60;
  final s = seconds % 60;
  final mm = m.toString().padLeft(2, '0');
  final ss = s.toString().padLeft(2, '0');

  return h > 0 ? '$h:$mm:$ss' : '$mm:$ss';
}

void _toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

// ══ Scanning ═══════════════════════════════════════════════════════════════════════

/// The camera, looking for a HAAT payment QR.
///
/// Opened from the QR button on the store profile. Only HAAT's own codes are taken —
/// anything else is said to be not a HAAT request, and never opened — and the code is
/// all that is read from it: who is paid and how much come from HAAT on the next screen.
class PayScannerScreen extends StatefulWidget {
  const PayScannerScreen({super.key});

  @override
  State<PayScannerScreen> createState() => _PayScannerScreenState();
}

class _PayScannerScreenState extends State<PayScannerScreen> {
  // The whole frame is read, not only the square drawn on it: a scan window is mapped
  // from the screen to the camera's picture, and on phones where that mapping is off
  // nothing is ever found. `_opened` is what stops a QR from being taken twice.
  final _camera = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.normal,
    autoZoom: true,
  );

  /// Set once a code is taken, so a second frame of the same QR does nothing.
  bool _opened = false;
  String? _hint;
  Timer? _hintTimer;

  @override
  void dispose() {
    _hintTimer?.cancel();
    unawaited(_camera.dispose());
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      if (_take(barcode.rawValue ?? barcode.url?.url ?? barcode.displayValue)) {
        return;
      }
    }
  }

  /// Opens [scanned] when it is a HAAT request; says so when it is not.
  bool _take(String? scanned) {
    if (_opened || scanned == null || scanned.trim().isEmpty) return false;

    final code = payCodeFrom(scanned);
    if (code == null) {
      // Read every few frames while it stays in view; said once until it goes.
      if (_hint == null) _showHint('This isn’t a HAAT payment QR.');
      return false;
    }

    _opened = true;
    HapticFeedback.selectionClick();
    unawaited(_camera.stop());
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => PayRequestScreen(code: code)),
    );
    return true;
  }

  void _showHint(String text) {
    _hintTimer?.cancel();
    setState(() => _hint = text);
    _hintTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _hint = null);
    });
  }

  Future<void> _fromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null || !mounted) return;

    BarcodeCapture? capture;
    try {
      capture = await _camera.analyzeImage(
        picked.path,
        formats: const [BarcodeFormat.qrCode],
      );
    } catch (_) {
      capture = null;
    }
    if (!mounted) return;

    final values = capture?.barcodes.map((b) => b.rawValue) ?? const [];
    if (values.isEmpty) {
      _showHint('No QR code found in that photo.');
      return;
    }
    for (final value in values) {
      if (_take(value)) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final side = (size.width * 0.68).clamp(200.0, 300.0);
    final window = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.42),
      width: side,
      height: side,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              controller: _camera,
              onDetect: _onDetect,
              errorBuilder: (context, error) => _CameraProblem(
                denied:
                    error.errorCode == MobileScannerErrorCode.permissionDenied,
              ),
            ),
            IgnorePointer(
              child: CustomPaint(painter: _ScanFrame(window)),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: window.bottom + 24,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: _hint == null
                    ? Text(
                        'Scan a HAAT payment QR',
                        key: const ValueKey('help'),
                        textAlign: TextAlign.center,
                        style: _type(14, color: Colors.white),
                      )
                    : Center(
                        key: ValueKey(_hint),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(_hint!,
                              style: _type(13, weight: FontWeight.w600)),
                        ),
                      ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Back',
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Expanded(
                      child: Text(
                        'Scan to pay',
                        textAlign: TextAlign.center,
                        style: _type(15, color: Colors.white),
                      ),
                    ),
                    ValueListenableBuilder<MobileScannerState>(
                      valueListenable: _camera,
                      builder: (context, state, _) {
                        final on = state.torchState == TorchState.on;
                        final usable =
                            state.torchState != TorchState.unavailable;
                        return IconButton(
                          tooltip: on ? 'Turn torch off' : 'Turn torch on',
                          onPressed: usable ? _camera.toggleTorch : null,
                          icon: Icon(
                            on ? Icons.flash_on : Icons.flash_off,
                            color: usable ? Colors.white : Colors.white38,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: MediaQuery.paddingOf(context).bottom + 28,
              child: _GlassButton(
                icon: Icons.photo_library_outlined,
                label: 'Scan from photos',
                onTap: _fromGallery,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The dark surround with a clear square and its corners.
class _ScanFrame extends CustomPainter {
  _ScanFrame(this.window);

  final Rect window;

  @override
  void paint(Canvas canvas, Size size) {
    final hole = RRect.fromRectAndRadius(window, const Radius.circular(24));
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Offset.zero & size),
        Path()..addRRect(hole),
      ),
      Paint()..color = const Color(0x99000000),
    );

    const arm = 34.0;
    const r = 24.0;
    final pen = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    final l = window.left, t = window.top, rt = window.right, b = window.bottom;

    for (final corner in [
      Path()
        ..moveTo(l, t + arm)
        ..lineTo(l, t + r)
        ..arcToPoint(Offset(l + r, t), radius: const Radius.circular(r))
        ..lineTo(l + arm, t),
      Path()
        ..moveTo(rt - arm, t)
        ..lineTo(rt - r, t)
        ..arcToPoint(Offset(rt, t + r), radius: const Radius.circular(r))
        ..lineTo(rt, t + arm),
      Path()
        ..moveTo(rt, b - arm)
        ..lineTo(rt, b - r)
        ..arcToPoint(Offset(rt - r, b), radius: const Radius.circular(r))
        ..lineTo(rt - arm, b),
      Path()
        ..moveTo(l + arm, b)
        ..lineTo(l + r, b)
        ..arcToPoint(Offset(l, b - r), radius: const Radius.circular(r))
        ..lineTo(l, b - arm),
    ]) {
      canvas.drawPath(corner, pen);
    }
  }

  @override
  bool shouldRepaint(_ScanFrame old) => old.window != window;
}

class _GlassButton extends StatelessWidget {
  const _GlassButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: const Color(0x33FFFFFF),
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: SizedBox(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(label,
                    style: _type(14,
                        weight: FontWeight.w600, color: Colors.white)),
              ],
            ),
          ),
        ),
      );
}

class _CameraProblem extends StatelessWidget {
  const _CameraProblem({required this.denied});

  final bool denied;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: Colors.black,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.no_photography_outlined,
                    color: Colors.white70, size: 40),
                const SizedBox(height: 16),
                Text(
                  denied ? 'Camera access is off' : 'The camera didn’t start',
                  textAlign: TextAlign.center,
                  style:
                      _type(17, weight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  denied
                      ? 'Allow HAAT to use the camera in Settings, or pick the QR from your photos.'
                      : 'Close this and try again, or scan the QR from your photos.',
                  textAlign: TextAlign.center,
                  style: _type(13, color: Colors.white70, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      );
}

// ══ Paying a request ═══════════════════════════════════════════════════════════════

/// A failed payment, shown in place of the request until Retry.
class _PayFailure {
  const _PayFailure({
    required this.reference,
    required this.reason,
    required this.offline,
    required this.at,
  });

  final String reference;
  final String? reason;
  final bool offline;
  final DateTime at;
}

/// Another business's request — scanned or opened from a link — and paying it.
///
/// Everything shown comes from HAAT for [code]: who is asking, how much, the fee, and
/// whether this business may pay it. Approving needs the passcode or a fingerprint
/// signature over this very request, and the server pays it once, to the business that
/// made it — a second tap, a retry or a second payer all find it already paid.
class PayRequestScreen extends StatefulWidget {
  const PayRequestScreen({super.key, required this.code, this.onExit});

  final String code;

  /// Leaving the screen; by default back to the page under it, or home once paid.
  /// Given when the screen was opened from a link and has nothing under it.
  final VoidCallback? onExit;

  @override
  State<PayRequestScreen> createState() => _PayRequestScreenState();
}

class _PayRequestScreenState extends State<PayRequestScreen> {
  PaymentRequestPreview? _preview;
  Wallet? _wallet;
  String? _loadError;
  bool _loadOffline = false;
  bool _loading = true;

  bool _paying = false;
  String _reference = const Uuid().v4();
  TransferReceipt? _receipt;
  _PayFailure? _failure;

  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _load();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _preview?.expiresAt != null) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
      _loadOffline = false;
    });

    final results = await Future.wait([
      AuthSession.instance.payRequests.preview(widget.code),
      AuthSession.instance.wallet.get(),
    ]);
    if (!mounted) return;

    final preview = results[0] as ApiResult<PaymentRequestPreview>;
    final wallet = results[1] as ApiResult<Wallet>;
    setState(() {
      _loading = false;
      if (wallet is ApiSuccess<Wallet>) _wallet = wallet.value;
      if (preview is ApiSuccess<PaymentRequestPreview>) {
        _preview = preview.value;
      } else {
        _loadOffline = preview is ApiUnreachable<PaymentRequestPreview>;
        _loadError = preview.errorCode == 'NOT_FOUND' ||
                preview.errorCode == 'PAYMENT_REQUEST_NOT_FOUND'
            ? 'This code isn’t a HAAT payment request. Check it with the business that sent it.'
            : preview.messageIn('en');
      }
    });
  }

  bool _expired(PaymentRequestPreview p) =>
      p.status == 'expired' ||
      (p.expiresAt != null && !p.expiresAt!.isAfter(DateTime.now()));

  /// Why this business cannot pay it, in words; null when it can.
  String? _blocker(PaymentRequestPreview p) {
    if (p.status == 'paid') return 'This request has already been paid.';
    if (p.status == 'cancelled') {
      return '${p.requester.name} cancelled this request.';
    }
    if (_expired(p)) {
      return 'This request has expired. Ask ${p.requester.name} for a new one.';
    }
    if (!p.payable) {
      return switch (p.refusal) {
        'own_request' =>
          'This is your own request. Share it with the business that’s paying you.',
        'other_bank' =>
          'This request is for a different bank than your HAAT wallet.',
        'no_amount' =>
          'This code has no amount. Ask for a payment QR or link instead.',
        'no_rule' => 'Your bank doesn’t allow this payment yet.',
        'over_limit' => 'This amount is outside what your bank allows.',
        _ => 'This request can’t be paid right now.',
      };
    }
    final total = p.totalMinor ?? p.amountMinor;
    final wallet = _wallet;
    if (total != null &&
        wallet != null &&
        wallet.currency == p.currency &&
        total > wallet.available) {
      return 'Not enough in your wallet. Available: ${_money(wallet.available, wallet.currency)}.';
    }
    return null;
  }

  // ── Approve and pay ──────────────────────────────────────────────────────────────

  Future<void> _pay() async {
    final p = _preview;
    if (p == null || _paying || _inFlow || _blocker(p) != null) return;
    _inFlow = true;
    try {
      await _approveAndPay(p);
    } finally {
      _inFlow = false;
    }
  }

  /// One tap of Approve at a time: a second, while the dialog is up, does nothing.
  bool _inFlow = false;

  Future<void> _approveAndPay(PaymentRequestPreview p) async {
    final fingerprint =
        await AuthSession.instance.biometrics.availability() == null;
    final amount = _money(p.totalMinor ?? p.amountMinor!, p.currency);
    String? refusal;

    while (mounted) {
      final credential = await showAuthorizeDialog(
        context,
        amount: amount,
        name: p.requester.name,
        fingerprint: fingerprint,
        verb: 'pay',
        biometricTitle: 'Confirm payment',
        error: refusal,
        // Read when the fingerprint is used, so it signs the reference then in force.
        challenge: () => AuthSession.instance.payRequests
            .challenge(code: p.code, reference: _reference),
      );
      if (!mounted || credential == null) return;

      setState(() => _paying = true);
      final result = await AuthSession.instance.payRequests.pay(
        code: p.code,
        reference: _reference,
        passcode: credential.passcode,
        biometricSignature: credential.signature,
      );
      if (!mounted) return;
      setState(() => _paying = false);

      if (result is ApiSuccess<TransferReceipt>) {
        HapticFeedback.mediumImpact();
        WalletBalance.refreshNow();
        _showInPlace(() => _receipt = result.value);
        return;
      }

      final reference = _reference;
      if (result is ApiFailure<TransferReceipt>) {
        final field = result.data['field'];
        // A refused credential keeps the reference: nothing moved, and a fingerprint
        // retried after a dropped answer must find the same payment.
        if (field == 'passcode' || field == 'biometric') {
          refusal = result.messageIn('en');
          continue;
        }
        // Refused for any other reason: nothing was paid, so the next try is new.
        _reference = const Uuid().v4();
      }
      // A dropped connection keeps the reference, so a retry cannot pay twice.
      HapticFeedback.heavyImpact();
      _showInPlace(() => _failure = _PayFailure(
            reference: reference,
            reason: result.messageIn('en'),
            offline: result is ApiUnreachable<TransferReceipt>,
            at: DateTime.now(),
          ));
      return;
    }
  }

  void _showInPlace(VoidCallback outcome) {
    final self = ModalRoute.of(context);
    Navigator.of(context).popUntil((route) => route == self);
    setState(outcome);
  }

  void _back() {
    final exit = widget.onExit;
    if (exit != null) {
      exit();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  void _done() {
    final exit = widget.onExit;
    if (exit != null) {
      exit();
    } else {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  List<(String, String)> _receiptLines(TransferReceipt receipt) {
    final p = _preview;
    return [
      ('Paid to', receipt.recipientName),
      if (receipt.recipientUsername != null)
        ('Username', '@${receipt.recipientUsername}'),
      if (p?.invoiceReference != null) ('Invoice', p!.invoiceReference!),
      ('Request code', widget.code),
      if (receipt.feeMinor > BigInt.zero) ...[
        ('Fee', _money(receipt.feeMinor, receipt.currency)),
        ('Total from wallet', _money(receipt.totalMinor, receipt.currency)),
      ],
      ('Reference number', _shortReference(receipt.transactionId)),
      ('Date & time', dateTimeFormat('d MMM y · HH:mm', receipt.occurredAt)),
    ];
  }

  Future<void> _shareReceipt(TransferReceipt receipt) async {
    await SharePlus.instance.share(ShareParams(
      subject: 'HAAT payment receipt',
      text: [
        'HAAT payment receipt',
        'Paid ${_money(receipt.amountMinor, receipt.currency)} to ${receipt.recipientName}',
        for (final (label, value) in _receiptLines(receipt)) '$label: $value',
      ].join('\n'),
    ));
  }

  Widget _outcome() {
    final receipt = _receipt;
    if (receipt != null) {
      if (receipt.isHeld) {
        final lines = [
          ('Amount', _money(receipt.amountMinor, receipt.currency)),
          if (receipt.feeMinor > BigInt.zero)
            ('Fee', _money(receipt.feeMinor, receipt.currency)),
          ('From', 'HAAT wallet'),
          ('Receiver Name', receipt.recipientName),
          ('Request code', widget.code),
          ('Reference number', _shortReference(receipt.transactionId)),
          (
            'Date & Time',
            dateTimeFormat('d MMM y · HH:mm', receipt.occurredAt)
          ),
        ];
        return PaymentPendingWidget(
          key: ValueKey('pending-${receipt.transactionId}'),
          details: lines,
          primaryLabel: 'Remind me once processed',
          onPrimary: () async {
            _toast(context, 'You’ll be notified once HAAT approves it.');
            _done();
          },
          onShare: () => SharePlus.instance.share(ShareParams(
            text: [
              'HAAT payment, waiting for approval',
              for (final (label, value) in lines) '$label: $value',
            ].join('\n'),
          )),
        );
      }
      if (!receipt.isRejected) {
        final (whole, fraction) =
            splitMinor(receipt.amountMinor, receipt.currency);
        return PaymentSuccessWidget(
          key: ValueKey(receipt.transactionId),
          title: 'Payment sent',
          amount: '$whole$fraction',
          currency: receipt.currency,
          subtitle: '${receipt.recipientName} · HAAT payment',
          details: _receiptLines(receipt),
          onDone: () async => _done(),
          onShare: () => _shareReceipt(receipt),
        );
      }
      return PaymentErrorWidget(
        key: ValueKey('rejected-${receipt.transactionId}'),
        details: [
          ('Amount', _money(receipt.amountMinor, receipt.currency)),
          ('Reference number', _shortReference(receipt.transactionId)),
          (
            'Date & Time',
            dateTimeFormat('d MMM y · HH:mm', receipt.occurredAt)
          ),
          if (receipt.reason != null && receipt.reason!.trim().isNotEmpty)
            ('Reason', receipt.reason!.trim()),
        ],
        onRetry: () async {
          setState(() {
            _receipt = null;
            _reference = const Uuid().v4();
          });
          await _load();
        },
      );
    }

    final failure = _failure;
    if (failure != null) {
      if (failure.offline) {
        return NoInternetWidget(
          key: const ValueKey('offline'),
          onRetry: () async {
            setState(() => _failure = null);
            await _pay();
          },
        );
      }
      final p = _preview;
      return PaymentErrorWidget(
        key: ValueKey('error-${failure.reference}'),
        details: [
          if (p != null)
            ('Amount', _money(p.totalMinor ?? p.amountMinor!, p.currency)),
          ('Request code', widget.code),
          ('Reference number', _shortReference(failure.reference)),
          ('Date & Time', dateTimeFormat('d MMM y · HH:mm', failure.at)),
          if (failure.reason != null && failure.reason!.trim().isNotEmpty)
            ('Reason', failure.reason!.trim()),
        ],
        // The request may have changed meanwhile — paid by someone else, or expired.
        onRetry: () async {
          setState(() => _failure = null);
          await _load();
        },
      );
    }

    return _HeaderPage(
      key: const ValueKey('request'),
      title: 'Pay request',
      onBack: _back,
      body: _body(),
      bottom: _footer(),
    );
  }

  Widget _body() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.only(top: 120),
        child: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: _ink),
          ),
        ),
      );
    }
    final p = _preview;
    if (p == null) {
      return _Problem(
        icon: _loadOffline ? Icons.wifi_off_rounded : Icons.qr_code_2_rounded,
        title: _loadOffline ? 'You’re offline' : 'Can’t open this request',
        message: _loadOffline
            ? 'Connect to the internet to see who is asking and how much.'
            : (_loadError ?? 'Something went wrong.'),
        action: 'Try again',
        onAction: _load,
      );
    }

    final blocker = _blocker(p);
    final expiresAt = p.expiresAt;
    final left = expiresAt?.difference(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _RequesterCard(requester: p.requester),
        const SizedBox(height: 12),
        _Card(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            children: [
              Text('Amount requested', style: _type(12, color: _muted)),
              const SizedBox(height: 6),
              _Amount(
                  minor: p.amountMinor ?? BigInt.zero, currency: p.currency),
              if (p.description != null &&
                  p.description!.trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  '“${p.description!.trim()}”',
                  textAlign: TextAlign.center,
                  style: _type(13, color: _muted, height: 1.4),
                ),
              ],
              const SizedBox(height: 20),
              const Divider(height: 1, color: _hairline),
              const SizedBox(height: 8),
              if (p.invoiceReference != null)
                _Line('Invoice', p.invoiceReference!),
              _Line('Request code', p.code),
              _Line(
                'Fee',
                (p.feeMinor ?? BigInt.zero) > BigInt.zero
                    ? _money(p.feeMinor!, p.currency)
                    : 'No fee',
              ),
              if (p.totalMinor != null)
                _Line('Total from wallet', _money(p.totalMinor!, p.currency),
                    strong: true),
              if (left != null && p.status == 'open')
                _Line(
                  'Expires in',
                  left.isNegative ? 'Expired' : _clock(left),
                  tone: left.inSeconds < 60 ? _danger : null,
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (blocker != null)
          _Notice(icon: Icons.info_outline_rounded, text: blocker, danger: true)
        else
          const _Notice(
            icon: Icons.lock_outline_rounded,
            text:
                'Who gets paid and how much come from HAAT, not from the QR or link. '
                'You’ll approve with your passcode or fingerprint, and it can only be paid once.',
          ),
      ],
    );
  }

  Widget? _footer() {
    final p = _preview;
    if (_loading || p == null) return null;
    final blocker = _blocker(p);
    if (blocker != null) {
      return _PillButton(label: 'Close', onTap: _back, quiet: true);
    }

    return _PillButton(
      label:
          'Approve & pay ${_money(p.totalMinor ?? p.amountMinor!, p.currency)}',
      busy: _paying,
      onTap: _pay,
    );
  }

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: PopScope(
          // Opened from a link there is nothing under it to go back to.
          canPop: widget.onExit == null,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) _back();
          },
          child: Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: _outcome(),
            ),
          ),
        ),
      );
}

class _RequesterCard extends StatelessWidget {
  const _RequesterCard({required this.requester});

  final PaymentRequester requester;

  @override
  Widget build(BuildContext context) {
    final handle = requester.username ?? requester.handle;
    return _Card(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _Logo(url: requester.logoUrl, initials: requester.initials, size: 56),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Requested by', style: _type(11, color: _muted)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        requester.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: _type(16, weight: FontWeight.w600, height: 1.25),
                      ),
                    ),
                    if (requester.verified) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.verified_rounded,
                          color: _green, size: 18),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  [
                    if (handle.isNotEmpty) '@$handle',
                    if (requester.mobileMasked != null) requester.mobileMasked!,
                  ].join('  ·  '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _type(12, color: _muted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══ Asking to be paid ══════════════════════════════════════════════════════════════

/// A QR or a link this business shows or sends to be paid [amount], once.
///
/// Reached from Select Pay Out after the amount is typed. The request is made on HAAT
/// first — the QR and the link carry only its code — and this screen watches it until
/// it is paid, so the merchant sees the money arrive. The QR carries the business's
/// logo in its middle; Save puts the card in Photos, Share sends it with a message.
class RequestPaymentScreen extends StatefulWidget {
  const RequestPaymentScreen({
    super.key,
    required this.amount,
    required this.link,
    this.description,
  });

  /// As typed on the amount screen.
  final String amount;

  /// A payment link rather than a QR.
  final bool link;
  final String? description;

  @override
  State<RequestPaymentScreen> createState() => _RequestPaymentScreenState();
}

class _RequestPaymentScreenState extends State<RequestPaymentScreen> {
  final _card = GlobalKey();

  PaymentRequest? _request;
  String? _error;
  bool _offline = false;
  bool _creating = true;
  bool _saving = false;
  bool _sharing = false;
  bool _cancelling = false;

  /// Kept across a retry, so a request HAAT made but never answered is not made twice.
  String _reference = const Uuid().v4();
  String? _logoUrl;

  Timer? _tick;
  Timer? _watch;

  @override
  void initState() {
    super.initState();
    final known = FFAppState().businessLogoUrl;
    _logoUrl = known.isEmpty ? null : known;
    if (_logoUrl == null) _loadLogo();
    _create();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _request != null) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    _watch?.cancel();
    super.dispose();
  }

  Future<void> _loadLogo() async {
    final result = await AuthSession.instance.organizations.currentLogoUrl();
    if (!mounted) return;
    if (result is ApiSuccess<String?> && result.value != null) {
      setState(() => _logoUrl = result.value);
    }
  }

  Future<void> _create() async {
    setState(() {
      _creating = true;
      _error = null;
      _offline = false;
    });

    final wallet = await AuthSession.instance.wallet.get();
    final currency =
        wallet is ApiSuccess<Wallet> ? wallet.value.currency : 'SDG';
    final minor = toMinor(widget.amount, currency);
    if (!mounted) return;
    if (minor == null || minor <= BigInt.zero) {
      setState(() {
        _creating = false;
        _error = 'Enter an amount above zero first.';
      });
      return;
    }

    final result = await AuthSession.instance.payRequests.create(
      link: widget.link,
      amountMinor: minor,
      currency: currency,
      reference: _reference,
      description: widget.description,
    );
    if (!mounted) return;

    setState(() {
      _creating = false;
      if (result is ApiSuccess<PaymentRequest>) {
        _request = result.value;
        _watchForPayment();
      } else {
        _offline = result is ApiUnreachable<PaymentRequest>;
        // Refused means nothing was made; the next try is a new request.
        if (result is ApiFailure<PaymentRequest>) {
          _reference = const Uuid().v4();
        }
        _error = result.messageIn('en');
      }
    });
  }

  /// Asks HAAT every few seconds whether it was paid, until it is, or cannot be.
  void _watchForPayment() {
    _watch?.cancel();
    _watch = Timer.periodic(const Duration(seconds: 4), (_) async {
      final request = _request;
      if (request == null || request.status != 'open' || _expired(request)) {
        _watch?.cancel();
        return;
      }
      final result = await AuthSession.instance.payRequests.list();
      if (!mounted || result is! ApiSuccess<List<PaymentRequest>>) return;

      final now = result.value.where((r) => r.id == request.id).firstOrNull;
      if (now == null || now.status == request.status) return;

      _watch?.cancel();
      if (now.isPaid) {
        HapticFeedback.mediumImpact();
        WalletBalance.refreshNow();
      }
      setState(() => _request = now);
    });
  }

  bool _expired(PaymentRequest r) =>
      r.status == 'expired' ||
      (r.expiresAt != null && !r.expiresAt!.isAfter(DateTime.now()));

  Future<void> _again() async {
    _watch?.cancel();
    setState(() {
      _request = null;
      _reference = const Uuid().v4();
    });
    await _create();
  }

  Future<void> _cancel() async {
    final request = _request;
    if (request == null || _cancelling) return;

    final sure = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Cancel this request?',
            style: _type(17, weight: FontWeight.w600)),
        content: Text(
          'The ${widget.link ? 'link' : 'QR'} stops working right away. Anyone who '
          'opens it will be told it was cancelled.',
          style: _type(13, color: _muted, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialog).pop(false),
            child: Text('Keep it', style: _type(14, weight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialog).pop(true),
            child: Text('Cancel request',
                style: _type(14, weight: FontWeight.w600, color: _danger)),
          ),
        ],
      ),
    );
    if (sure != true || !mounted) return;

    setState(() => _cancelling = true);
    final result = await AuthSession.instance.payRequests.cancel(request.id);
    if (!mounted) return;
    setState(() => _cancelling = false);

    if (result is ApiSuccess<void>) {
      _watch?.cancel();
      Navigator.of(context).maybePop();
    } else {
      _toast(context, result.messageIn('en'));
    }
  }

  // ── Save and share ───────────────────────────────────────────────────────────────

  /// The card as a picture, sharp enough to print.
  Future<Uint8List?> _cardImage() async {
    final boundary =
        _card.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;

    final image = await boundary.toImage(pixelRatio: 3);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();

    return bytes?.buffer.asUint8List();
  }

  Future<void> _save() async {
    final request = _request;
    if (request == null || _saving) return;
    setState(() => _saving = true);

    try {
      if (!await Gal.hasAccess() && !await Gal.requestAccess()) {
        if (mounted) {
          _toast(context, 'Allow HAAT to add to Photos in Settings.');
        }
        return;
      }
      final png = await _cardImage();
      if (png == null) return;
      await Gal.putImageBytes(png, name: 'HAAT-${request.code}');
      HapticFeedback.lightImpact();
      if (mounted) _toast(context, 'Saved to Photos');
    } on GalException catch (error) {
      if (mounted) _toast(context, error.type.message);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _message(PaymentRequest request) {
    final amount = _money(request.amountMinor, request.currency);
    final until = request.expiresAt == null
        ? null
        : dateTimeFormat('d MMM, HH:mm', request.expiresAt);

    return [
      '${request.merchantName} is requesting $amount on HAAT.',
      '',
      widget.link
          ? 'Tap to pay securely in the HAAT app:'
          : 'Scan the QR with HAAT, or tap to pay securely:',
      request.link,
      '',
      'Request code: ${request.code}',
      if (until != null) 'Valid until $until · can be paid once.',
    ].join('\n');
  }

  Future<void> _share() async {
    final request = _request;
    if (request == null || _sharing) return;
    setState(() => _sharing = true);

    try {
      final png = widget.link ? null : await _cardImage();
      await SharePlus.instance.share(ShareParams(
        subject: 'HAAT payment request from ${request.merchantName}',
        text: _message(request),
        files:
            png == null ? null : [XFile.fromData(png, mimeType: 'image/png')],
        fileNameOverrides: png == null ? null : ['HAAT-${request.code}.png'],
      ));
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  Future<void> _copyLink() async {
    final request = _request;
    if (request == null) return;
    await Clipboard.setData(ClipboardData(text: request.link));
    HapticFeedback.selectionClick();
    if (mounted) _toast(context, 'Link copied');
  }

  // ── Layout ───────────────────────────────────────────────────────────────────────

  Widget _received(PaymentRequest request) {
    final (whole, fraction) = splitMinor(request.amountMinor, request.currency);
    return PaymentSuccessWidget(
      key: ValueKey('paid-${request.id}'),
      title: 'Payment received',
      amount: '$whole$fraction',
      currency: request.currency,
      subtitle: 'Paid into your HAAT wallet',
      details: [
        if (request.invoiceReference != null)
          ('Invoice', request.invoiceReference!),
        ('Request code', request.code),
        ('Paid by', widget.link ? 'Payment link' : 'QR code'),
        (
          'Date & time',
          dateTimeFormat('d MMM y · HH:mm', request.paidAt ?? DateTime.now())
        ),
      ],
      onDone: () async =>
          Navigator.of(context).popUntil((route) => route.isFirst),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = _request;
    final Widget child;
    if (request != null && request.isPaid) {
      child = _received(request);
    } else {
      child = _HeaderPage(
        key: const ValueKey('request'),
        title: widget.link ? 'Payment link' : 'Scan QR code',
        onBack: () => Navigator.of(context).maybePop(),
        body: _body(),
        bottom: _footer(),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          child: child,
        ),
      ),
    );
  }

  Widget _body() {
    final request = _request;
    if (_creating && request == null) {
      return const Padding(
        padding: EdgeInsets.only(top: 140),
        child: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: _ink),
          ),
        ),
      );
    }
    if (request == null) {
      return _Problem(
        icon: _offline ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
        title: _offline ? 'You’re offline' : 'Couldn’t make the request',
        message: _offline
            ? 'Connect to the internet and try again. Nothing was made twice.'
            : (_error ?? 'Something went wrong.'),
        action: 'Try again',
        onAction: _create,
      );
    }

    final expired = _expired(request);
    final cancelled = request.status == 'cancelled';
    final left = request.expiresAt?.difference(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.link
              ? 'Send this link to the payer. It opens HAAT on their phone,\nor a secure page if they don’t have it.'
              : 'Ask the payer to scan this with HAAT,\nor any phone camera.',
          textAlign: TextAlign.center,
          style: _type(13, color: _muted, height: 1.5),
        ),
        const SizedBox(height: 20),
        RepaintBoundary(
          key: _card,
          child: _RequestCard(
            request: request,
            logoUrl: _logoUrl,
            link: widget.link,
            onCopy: _copyLink,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: _StatusChip(
            text: cancelled
                ? 'Cancelled'
                : expired
                    ? 'Expired'
                    : left == null
                        ? 'Waiting for payment'
                        : 'Waiting for payment · ${_clock(left)}',
            tone: cancelled || expired ? _danger : _amber,
            soft: cancelled || expired ? _dangerSoft : _amberSoft,
            live: !cancelled && !expired,
          ),
        ),
        if (!cancelled && !expired) ...[
          const SizedBox(height: 4),
          Center(
            child: TextButton(
              onPressed: _cancelling ? null : _cancel,
              child: Text(
                _cancelling ? 'Cancelling…' : 'Cancel request',
                style: _type(13, weight: FontWeight.w600, color: _muted),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget? _footer() {
    final request = _request;
    if (request == null) return null;
    if (_expired(request) || request.status == 'cancelled') {
      return _PillButton(label: 'Make a new one', onTap: _again);
    }

    return Row(
      children: [
        Expanded(
          child: widget.link
              ? _PillButton(label: 'Copy link', onTap: _copyLink)
              : _PillButton(
                  label: 'Save to Photos',
                  busy: _saving,
                  onTap: _save,
                ),
        ),
        const SizedBox(width: 12),
        Semantics(
          button: true,
          label: 'Share',
          child: Material(
            color: FlutterFlowTheme.of(context).accent3,
            shape: const StadiumBorder(),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: _sharing ? null : _share,
              child: SizedBox(
                width: 64,
                height: 50,
                child: _sharing
                    ? const Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: _ink),
                        ),
                      )
                    : const Icon(Icons.share_outlined, color: _ink, size: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// What is saved and shared: who is asking, the QR (or link), and how much.
class _RequestCard extends StatelessWidget {
  const _RequestCard({
    required this.request,
    required this.logoUrl,
    required this.link,
    required this.onCopy,
  });

  final PaymentRequest request;
  final String? logoUrl;
  final bool link;
  final VoidCallback onCopy;

  String get _initials {
    final words = request.merchantName
        .trim()
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList();
    if (words.isEmpty) return 'H';
    if (words.length == 1) return words.first[0].toUpperCase();
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final (whole, fraction) = splitMinor(request.amountMinor, request.currency);
    final until = request.expiresAt == null
        ? null
        : dateTimeFormat('d MMM, HH:mm', request.expiresAt);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(
        children: [
          Row(
            children: [
              _Logo(url: logoUrl, initials: _initials, size: 36),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.merchantName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _type(14, weight: FontWeight.w600),
                    ),
                    Text('Payment request', style: _type(11, color: _muted)),
                  ],
                ),
              ),
              Text('HAAT',
                  style: _type(13, weight: FontWeight.w700, spacing: 2.4)),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(height: 1, color: _hairline),
          const SizedBox(height: 22),
          if (link)
            _LinkBox(link: request.link, onCopy: onCopy)
          else
            _BrandedQr(
              data: request.link,
              logoUrl: logoUrl,
              initials: _initials,
            ),
          const SizedBox(height: 22),
          Text('Amount', style: _type(11, color: _muted)),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(children: [
              TextSpan(text: '$whole$fraction '),
              TextSpan(
                text: request.currency,
                style: _type(16, weight: FontWeight.w500, color: _muted),
              ),
            ]),
            style: _type(28, weight: FontWeight.w600, spacing: -0.6),
          ),
          if (request.invoiceReference != null) ...[
            const SizedBox(height: 6),
            Text('Invoice ${request.invoiceReference}',
                style: _type(12, color: _muted)),
          ],
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _page,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text('Code ', style: _type(12, color: _muted)),
                Text(request.code,
                    style: _type(12, weight: FontWeight.w700, spacing: 1.5)),
                const Spacer(),
                if (until != null)
                  Text('Valid until $until', style: _type(12, color: _muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// The QR, with the business's logo set in its middle. Drawn at the highest error
/// correction, so the logo covering the centre never stops it from being read.
class _BrandedQr extends StatelessWidget {
  const _BrandedQr({
    required this.data,
    required this.logoUrl,
    required this.initials,
  });

  final String data;
  final String? logoUrl;
  final String initials;

  @override
  Widget build(BuildContext context) {
    const size = 216.0;
    const badge = size * 0.22;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          QrImageView(
            data: data,
            size: size,
            padding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            errorCorrectionLevel: QrErrorCorrectLevel.H,
            semanticsLabel: 'Payment QR code',
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: _ink,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: _ink,
            ),
          ),
          Container(
            width: badge + 8,
            height: badge + 8,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: _Logo(
              url: logoUrl,
              initials: initials,
              size: badge,
              radius: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkBox extends StatelessWidget {
  const _LinkBox({required this.link, required this.onCopy});

  final String link;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment link', style: _type(11, color: _muted)),
          const SizedBox(height: 8),
          Material(
            color: _page,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onCopy,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
                child: Row(
                  children: [
                    const Icon(Icons.link_rounded, size: 20, color: _ink),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        link.replaceFirst(RegExp(r'^https?://'), ''),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: _type(13, weight: FontWeight.w600, height: 1.4),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.copy_rounded, size: 18, color: _muted),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}

class _StatusChip extends StatefulWidget {
  const _StatusChip({
    required this.text,
    required this.tone,
    required this.soft,
    required this.live,
  });

  final String text;
  final Color tone;
  final Color soft;
  final bool live;

  @override
  State<_StatusChip> createState() => _StatusChipState();
}

class _StatusChipState extends State<_StatusChip>
    with SingleTickerProviderStateMixin {
  late final _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(_StatusChip old) {
    super.didUpdateWidget(old);
    _sync();
  }

  void _sync() {
    final still = MediaQuery.disableAnimationsOf(context);
    if (widget.live && !still) {
      if (!_pulse.isAnimating) _pulse.repeat(reverse: true);
    } else {
      _pulse.stop();
      _pulse.value = 1;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: widget.soft,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FadeTransition(
              opacity: Tween(begin: 0.3, end: 1.0).animate(_pulse),
              child: Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: widget.tone, shape: BoxShape.circle),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.text,
              style: _type(12, weight: FontWeight.w600, color: widget.tone)
                  .copyWith(
                      fontFeatures: const [ui.FontFeature.tabularFigures()]),
            ),
          ],
        ),
      );
}

// ══ Opening a link ═════════════════════════════════════════════════════════════════

/// Where `haat://haat.com/pay/CODE` and the shared link land.
///
/// FlutterFlow writes the router, so a link is caught before it reaches it. Signed in
/// and unlocked, the request opens over whatever is on screen. Otherwise the code is
/// kept and the router takes the link to the usual start — sign-in or the passcode
/// first — and the home screen opens it once the person is in. Nothing is ever paid
/// from a link without them seeing it and approving it.
class PayLinks with WidgetsBindingObserver {
  PayLinks._();

  static final _instance = PayLinks._();
  static bool _started = false;

  /// Starts listening. Called once, from the app's start-up action, before the router
  /// is up — so a link that launched the app is kept as well.
  static void start() {
    if (_started) return;
    _started = true;

    final launch =
        _codeIn(WidgetsBinding.instance.platformDispatcher.defaultRouteName);
    if (launch != null) PendingPayLink.hold(launch);
    WidgetsBinding.instance.addObserver(_instance);
  }

  /// The code in `haat://haat.com/pay/CODE`, or in the shared link
  /// `https://<server>/api/v1/p/CODE` that the phone opens in the app rather than the
  /// browser; null for any other address. Android hands over the path alone, so only
  /// its end is read.
  static String? _codeIn(String? location) {
    final uri = Uri.tryParse(location ?? '');
    if (uri == null) return null;
    final segments = uri.pathSegments.where((part) => part.isNotEmpty).toList();
    if (segments.length < 2) return null;
    final kind = segments[segments.length - 2];
    if (kind != 'pay' && kind != 'p') return null;

    return payCodeFrom(segments.last);
  }

  @override
  Future<bool> didPushRouteInformation(
      RouteInformation routeInformation) async {
    final code = _codeIn(routeInformation.uri.toString());
    if (code == null) return false;

    final session = AuthSession.instance;
    final navigator = appNavigatorKey.currentState;
    if (!session.isSignedIn || session.lockedOnReopen || navigator == null) {
      PendingPayLink.hold(code);
      return false;
    }

    navigator.push(
      MaterialPageRoute(builder: (_) => PayRequestScreen(code: code)),
    );
    return true;
  }
}

/// Opens a payment link that arrived before the person was in, once they are.
///
/// Called by the home screen as it appears.
void openPendingPayLink(BuildContext context) {
  if (!AuthSession.instance.isSignedIn || AuthSession.instance.lockedOnReopen) {
    return;
  }
  final code = PendingPayLink.take();
  if (code == null) return;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PayRequestScreen(code: code)),
    );
  });
}

// ══ Pieces ═════════════════════════════════════════════════════════════════════════

/// The app's page: the grey header art behind a back arrow and title, the content
/// scrolling under it, and the action pinned to the bottom.
class _HeaderPage extends StatelessWidget {
  const _HeaderPage({
    super.key,
    required this.title,
    required this.onBack,
    required this.body,
    this.bottom,
  });

  final String title;
  final VoidCallback onBack;
  final Widget body;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: 162,
          child: Image.asset('assets/images/GrayPageBg.png', fit: BoxFit.cover),
        ),
        Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(8, top + 8, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Back',
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back, color: _ink),
                  ),
                  Expanded(
                    child: Text(title,
                        textAlign: TextAlign.center, style: _type(15)),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: body,
              ),
            ),
            if (bottom != null)
              Padding(
                padding: EdgeInsets.fromLTRB(20, 8, 20, bottomInset + 20),
                child: bottom,
              ),
          ],
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: child,
      );
}

class _Amount extends StatelessWidget {
  const _Amount({required this.minor, required this.currency});

  final BigInt minor;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final (whole, fraction) = splitMinor(minor, currency);
    return Text.rich(
      TextSpan(children: [
        TextSpan(text: whole),
        TextSpan(
          text: '$fraction ',
          style: _type(22, weight: FontWeight.w600),
        ),
        TextSpan(
          text: currency,
          style: _type(16, weight: FontWeight.w500, color: _muted),
        ),
      ]),
      textAlign: TextAlign.center,
      style: _type(36, weight: FontWeight.w600, spacing: -1),
    );
  }
}

class _Line extends StatelessWidget {
  const _Line(this.label, this.value, {this.strong = false, this.tone});

  final String label;
  final String value;
  final bool strong;
  final Color? tone;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: _type(13, color: _muted)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: _type(
                  13,
                  weight: strong ? FontWeight.w700 : FontWeight.w600,
                  color: tone ?? _ink,
                ).copyWith(
                    fontFeatures: const [ui.FontFeature.tabularFigures()]),
              ),
            ),
          ],
        ),
      );
}

class _Notice extends StatelessWidget {
  const _Notice({required this.icon, required this.text, this.danger = false});

  final IconData icon;
  final String text;
  final bool danger;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: danger ? _dangerSoft : _greenSoft,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: danger ? _danger : _green),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: _type(12, color: danger ? _danger : _green, height: 1.5),
              ),
            ),
          ],
        ),
      );
}

class _Logo extends StatelessWidget {
  const _Logo({
    required this.url,
    required this.initials,
    required this.size,
    this.radius,
  });

  final String? url;
  final String initials;
  final double size;

  /// Rounded square; a circle when null.
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      color: _ink,
      child: Text(
        initials,
        style: _type(size * 0.36, weight: FontWeight.w700, color: Colors.white),
      ),
    );
    final image = url == null
        ? fallback
        : CachedNetworkImage(
            imageUrl: url!,
            width: size,
            height: size,
            fit: BoxFit.cover,
            placeholder: (_, __) => fallback,
            errorWidget: (_, __, ___) => fallback,
          );

    return radius == null
        ? ClipOval(child: SizedBox.square(dimension: size, child: image))
        : ClipRRect(
            borderRadius: BorderRadius.circular(radius!),
            child: SizedBox.square(dimension: size, child: image),
          );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.onTap,
    this.busy = false,
    this.quiet = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool busy;

  /// The secondary style: dark text on the soft fill.
  final bool quiet;

  @override
  Widget build(BuildContext context) => Material(
        color: quiet ? FlutterFlowTheme.of(context).accent3 : Colors.black,
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: busy ? null : onTap,
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: Center(
              child: busy
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: quiet ? _ink : Colors.white,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: quiet ? _ink : Colors.white,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      );
}

class _Problem extends StatelessWidget {
  const _Problem({
    required this.icon,
    required this.title,
    required this.message,
    required this.action,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String action;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 72),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: _ink),
            ),
            const SizedBox(height: 20),
            Text(title,
                textAlign: TextAlign.center,
                style: _type(18, weight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: _type(13, color: _muted, height: 1.5)),
            const SizedBox(height: 24),
            SizedBox(
              width: 180,
              child: _PillButton(label: action, onTap: onAction, quiet: true),
            ),
          ],
        ),
      );
}
