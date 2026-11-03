import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '/custom_code/auth_session.dart';
import '/custom_code/pay_request_api.dart';
import '/custom_code/pay_request_flow.dart' show openPayRequest;
import '/custom_code/tap_to_pay.dart' show openTapApproval, openTapReceipt;
import '/flutter_flow/flutter_flow_util.dart';

const _ink = Color(0xFF111111);

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
    Navigator.of(context).pop(code);
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

    final location =
        WidgetsBinding.instance.platformDispatcher.defaultRouteName;
    final launch = _linkIn(location);
    if (launch != null) PendingPayLink.hold(launch.$2, kind: launch.$1);
    WidgetsBinding.instance.addObserver(_instance);
  }

  /// The code in `haat://haat.com/pay/CODE`, or in the shared link
  /// `https://<server>/api/v1/p/CODE` that the phone opens in the app rather than the
  /// browser; null for any other address. Android hands over the path alone, so only
  /// its end is read.
  ///
  /// `haat://haat.com/tap/CODE` is what the phone opens after paying a merchant's
  /// tap, and `haat://haat.com/approve/CODE` after a tap it approves on its own
  /// screen; [kinds] `{'tap'}` or `{'approve'}` reads those.
  static String? _codeIn(
    String? location, {
    Set<String> kinds = const {'pay', 'p'},
  }) {
    final uri = Uri.tryParse(location ?? '');
    if (uri == null) return null;
    final segments = uri.pathSegments.where((part) => part.isNotEmpty).toList();
    if (segments.length < 2) return null;
    final kind = segments[segments.length - 2];
    if (!kinds.contains(kind)) return null;

    return payCodeFrom(segments.last);
  }

  /// What [location] opens, as (`pay`, `tap` or `approve`, the code); null for none.
  static (String, String)? _linkIn(String? location) {
    for (final kind in const ['tap', 'approve']) {
      final code = _codeIn(location, kinds: {kind});
      if (code != null) return (kind, code);
    }
    final code = _codeIn(location);
    return code == null ? null : ('pay', code);
  }

  @override
  Future<bool> didPushRouteInformation(
      RouteInformation routeInformation) async {
    final link = _linkIn(routeInformation.uri.toString());
    if (link == null) return false;
    final (kind, code) = link;

    final session = AuthSession.instance;
    final navigator = appNavigatorKey.currentState;
    if (!session.isSignedIn || session.lockedOnReopen || navigator == null) {
      PendingPayLink.hold(code, kind: kind);
      return false;
    }

    _open(navigator.context, kind, code);
    return true;
  }
}

void _open(BuildContext context, String kind, String code) {
  switch (kind) {
    case 'tap':
      openTapReceipt(context, code);
    case 'approve':
      openTapApproval(context, code);
    default:
      openPayRequest(context, code);
  }
}

/// Opens a payment link that arrived before the person was in, once they are.
///
/// Called by the home screen as it appears.
void openPendingPayLink(BuildContext context) {
  if (!AuthSession.instance.isSignedIn || AuthSession.instance.lockedOnReopen) {
    return;
  }
  final kind = PendingPayLink.kind;
  final code = PendingPayLink.take();
  if (code == null) return;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (context.mounted) _open(context, kind, code);
  });
}
