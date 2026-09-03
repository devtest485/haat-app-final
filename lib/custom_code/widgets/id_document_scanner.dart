// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class IdDocumentScanner extends StatefulWidget {
  const IdDocumentScanner({
    super.key,
    this.width,
    this.height,
    this.title,
    this.showTipsOnOpen,
    this.showBackButton,
    this.frameAspectRatio,
    this.sheetTitle,
    this.tipsCardText,
    this.tip1,
    this.tip2,
    this.tip3,
    this.tip4,
    this.okButtonText,
    this.onCaptured,
    this.onClose,
  });

  final double? width;
  final double? height;

  /// Top title — default: 'ID Scanning'
  final String? title;

  /// Page khulte hi tips bottom sheet dikhaye — default: true
  final bool? showTipsOnOpen;

  /// Top-left back arrow — default: true
  final bool? showBackButton;

  /// ID card = 1.58, passport page = 1.42 — default: 1.58
  final double? frameAspectRatio;

  final String? sheetTitle;
  final String? tipsCardText;
  final String? tip1;
  final String? tip2;
  final String? tip3;
  final String? tip4;
  final String? okButtonText;

  /// Capture hone par local file path deta hai (Action param)
  final Future Function(String imagePath)? onCaptured;

  /// Back press par — sirf tab chalta hai jab stack me pop karne ke liye
  /// kuch na ho (jaise deep link se yeh pehla page khula ho). Back arrow
  /// khud pop karta hai, is liye is action me "next page" par navigate
  /// karne wala step na rakhein. (Action param)
  final Future Function()? onClose;

  /// Kahin se bhi sirf tips sheet dikhani ho to:
  /// await IdDocumentScanner.showScanTipsSheet(context);
  static Future<void> showScanTipsSheet(
    BuildContext context, {
    String? sheetTitle,
    String? tipsCardText,
    List<String>? tips,
    String? okButtonText,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x99000000),
      builder: (ctx) => ScanTipsSheet(
        sheetTitle: sheetTitle,
        tipsCardText: tipsCardText,
        tips: tips,
        okButtonText: okButtonText,
      ),
    );
  }

  @override
  State<IdDocumentScanner> createState() => _IdDocumentScannerState();
}

class _IdDocumentScannerState extends State<IdDocumentScanner>
    with WidgetsBindingObserver {
  /// Design: `linear-gradient(0deg, rgba(0,0,0,0.56), rgba(0,0,0,0.56))`
  /// over the camera image — a flat 56% black scrim.
  static const _scrim = Color(0x8F000000);

  CameraController? _controller;
  bool _initializing = true;
  bool _capturing = false;
  bool _permissionDenied = false;
  bool _closing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupCamera();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.showTipsOnOpen ?? true) {
        IdDocumentScanner.showScanTipsSheet(
          context,
          sheetTitle: widget.sheetTitle,
          tipsCardText: widget.tipsCardText,
          tips: _tips,
          okButtonText: widget.okButtonText,
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _controller = null;
      controller.dispose();
      if (mounted) setState(() {});
    } else if (state == AppLifecycleState.resumed) {
      _setupCamera();
    }
  }

  /// Back arrow. Pop yahin hota hai, taake page ka `onClose` action galti se
  /// aage navigate karne wala ho to bhi back arrow "next" na ban jaye.
  /// `onClose` sirf fallback hai — jab stack me pop karne ke liye kuch na ho.
  Future<void> _handleBack() async {
    if (_closing) return;
    _closing = true;
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      await navigator.maybePop();
    } else {
      await widget.onClose?.call();
    }
    if (mounted) _closing = false;
  }

  List<String> get _tips => [
        widget.tip1 ??
            'Verify that all details on your document are clear and not blurry.',
        widget.tip2 ??
            'Ensure well-lit surroundings to prevent shadows from obscuring the data.',
        widget.tip3 ??
            'Avoid using a flash, as it may make it challenging to read the information.',
        widget.tip4 ??
            'Ensure your fingers do not cover any data, the document must fit within the frame.',
      ];

  Future<void> _setupCamera() async {
    if (mounted) {
      setState(() {
        _initializing = true;
        _error = null;
      });
    }
    try {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        if (!mounted) return;
        setState(() {
          _permissionDenied = true;
          _initializing = false;
        });
        return;
      }

      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (!mounted) return;
        setState(() {
          _error = 'No camera found on this device.';
          _initializing = false;
        });
        return;
      }

      final back = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        back,
        ResolutionPreset.veryHigh,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await controller.initialize();
      // Design ke mutabiq flash hamesha off.
      try {
        await controller.setFlashMode(FlashMode.off);
      } catch (_) {}

      if (!mounted) {
        controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _permissionDenied = false;
        _initializing = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Camera could not be started.\n$e';
        _initializing = false;
      });
    }
  }

  bool get _hasPreview =>
      _controller != null && _controller!.value.isInitialized;

  /// Shown in place of the preview while starting up, or when the camera
  /// cannot be used (permission refused, or no camera — e.g. the simulator).
  Widget _statusBlock() {
    if (_initializing) {
      return const CircularProgressIndicator(color: Colors.white);
    }
    if (_permissionDenied) {
      return _MessageBlock(
        icon: Icons.no_photography_outlined,
        message: 'Camera permission is required to scan your document.',
        actionText: 'Open settings',
        onAction: openAppSettings,
      );
    }
    return _MessageBlock(
      icon: Icons.videocam_off_outlined,
      message: _error ?? 'Camera is unavailable on this device.',
      actionText: 'Try again',
      onAction: () async {
        await _setupCamera();
        return true;
      },
    );
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _capturing) {
      return;
    }
    setState(() => _capturing = true);
    try {
      final shot = await controller.takePicture();
      if (!mounted) return;
      await widget.onCaptured?.call(shot.path);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Capture failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _capturing = false);
    }
  }

  /// FlutterFlow passes `double.infinity` for a custom widget set to fill its
  /// parent. Multiplying that produces infinite frame sizes, so resolve it
  /// against the real constraints before doing any layout maths.
  double _resolve(double? given, double bounded, bool hasBounded, double mq) {
    if (given != null && given.isFinite) return given;
    if (hasBounded) return bounded;
    return mq;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => _buildScanner(context, constraints),
    );
  }

  Widget _buildScanner(BuildContext context, BoxConstraints constraints) {
    final size = MediaQuery.sizeOf(context);
    final w = _resolve(widget.width, constraints.maxWidth,
        constraints.hasBoundedWidth, size.width);
    final h = _resolve(widget.height, constraints.maxHeight,
        constraints.hasBoundedHeight, size.height);
    // A ratio outside this range collapses the frame into an invisible sliver,
    // so keep it usable no matter what the page passes in.
    final ratio = (widget.frameAspectRatio ?? 1.58).clamp(1.0, 2.2);
    final frameW = w * 0.84;
    final frameH = frameW / ratio;

    return SizedBox(
      width: w,
      height: h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: Colors.black),
          if (_hasPreview) _CoverPreview(controller: _controller!),

          // 56% black scrim across the whole preview, per the design.
          const ColoredBox(color: _scrim),

          if (!_hasPreview) Center(child: _statusBlock()),

          // Scan frame corners
          Align(
            alignment: const Alignment(0, -0.12),
            child: SizedBox(
              // No outset: the brackets trace the document frame itself, so
              // they keep a margin from the screen edges as in the design.
              width: frameW,
              height: frameH,
              child: CustomPaint(
                painter: _ScanFramePainter(
                  color: const Color(0xB3FFFFFF),
                  stroke: 4,
                  corner: 22,
                ),
              ),
            ),
          ),

          // Title + back. Aligned to topCenter so the 56px bar keeps its
          // height — a bare SafeArea child gets StackFit.expand's tight
          // constraints and would stretch, dropping the title mid-screen.
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: 56,
                child: Stack(
                  children: [
                    if (widget.showBackButton ?? true)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 20),
                          onPressed: _handleBack,
                        ),
                      ),
                    Center(
                      child: Text(
                        widget.title ?? 'ID Scanning',
                        style: GoogleFonts.alexandria(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Shutter
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 32 + MediaQuery.paddingOf(context).bottom,
              ),
              child: GestureDetector(
                onTap: _capture,
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.22),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Center(
                    child: _capturing
                        ? const SizedBox(
                            width: 26,
                            height: 26,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Preview ko BoxFit.cover ki tarah full-bleed dikhata hai.
class _CoverPreview extends StatelessWidget {
  const _CoverPreview({required this.controller});
  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    var scale = size.aspectRatio * controller.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    return ClipRect(
      child: Transform.scale(
        scale: scale,
        child: Center(child: CameraPreview(controller)),
      ),
    );
  }
}

class _MessageBlock extends StatelessWidget {
  const _MessageBlock({
    required this.icon,
    required this.message,
    required this.actionText,
    required this.onAction,
  });

  final IconData icon;
  final String message;
  final String actionText;
  final Future<bool> Function() onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFFDBDBDB), size: 40),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.alexandria(
              color: const Color(0xFFDBDBDB),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => onAction(),
            child: Text(
              actionText,
              style: GoogleFonts.alexandria(
                color: const Color(0xFF00DA76),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 4 rounded corner brackets.
class _ScanFramePainter extends CustomPainter {
  _ScanFramePainter({
    required this.color,
    required this.stroke,
    required this.corner,
  });

  final Color color;
  final double stroke;
  final double corner;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final r = corner;
    final arm = math.min(size.width, size.height) * 0.16;
    final o = stroke / 2;
    final w = size.width - stroke;
    final h = size.height - stroke;
    final path = Path();

    // top-left
    path
      ..moveTo(o, o + r + arm)
      ..lineTo(o, o + r)
      ..arcToPoint(Offset(o + r, o), radius: Radius.circular(r))
      ..lineTo(o + r + arm, o);
    // top-right
    path
      ..moveTo(o + w - r - arm, o)
      ..lineTo(o + w - r, o)
      ..arcToPoint(Offset(o + w, o + r), radius: Radius.circular(r))
      ..lineTo(o + w, o + r + arm);
    // bottom-right
    path
      ..moveTo(o + w, o + h - r - arm)
      ..lineTo(o + w, o + h - r)
      ..arcToPoint(Offset(o + w - r, o + h), radius: Radius.circular(r))
      ..lineTo(o + w - r - arm, o + h);
    // bottom-left
    path
      ..moveTo(o + r + arm, o + h)
      ..lineTo(o + r, o + h)
      ..arcToPoint(Offset(o, o + h - r), radius: Radius.circular(r))
      ..lineTo(o, o + h - r - arm);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ScanFramePainter old) =>
      old.color != color || old.stroke != stroke || old.corner != corner;
}

/// ===== Bottom sheet (Figma CSS ke exact tokens) =====
class ScanTipsSheet extends StatelessWidget {
  const ScanTipsSheet({
    super.key,
    this.sheetTitle,
    this.tipsCardText,
    this.tips,
    this.okButtonText,
  });

  final String? sheetTitle;
  final String? tipsCardText;
  final List<String>? tips;
  final String? okButtonText;

  static const _bg = Color(0xFF0D0D0D);
  static const _textGrey = Color(0xFFDBDBDB);
  static const _cardBg = Color(0x94323232); // rgba(50,50,50,0.58)
  static const _iconBg = Color(0xFF1E1E1E);
  static const _green = Color(0xFF00DA76);

  @override
  Widget build(BuildContext context) {
    final items = tips ??
        const [
          'Verify that all details on your document are clear and not blurry.',
          'Ensure well-lit surroundings to prevent shadows from obscuring the data.',
          'Avoid using a flash, as it may make it challenging to read the information.',
          'Ensure your fingers do not cover any data, the document must fit within the frame.',
        ];
    const icons = [
      Icons.text_snippet,
      Icons.wb_sunny,
      Icons.flash_off,
      Icons.visibility,
    ];

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  sheetTitle ?? 'Prepare to scan document',
                  style: GoogleFonts.alexandria(
                    fontSize: 16.38,
                    height: 20 / 16.38,
                    fontWeight: FontWeight.w500,
                    color: _textGrey,
                  ),
                ),
                const SizedBox(height: 24),

                // "Scanning tips" card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 31.56,
                        height: 31.56,
                        decoration: BoxDecoration(
                          color: const Color(0xFF333333),
                          borderRadius: BorderRadius.circular(9.1),
                        ),
                        child: const Icon(
                          Icons.camera_enhance,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          tipsCardText ?? 'Scanning tips',
                          style: GoogleFonts.alexandria(
                            fontSize: 12,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                            color: _textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Tip rows
                for (var i = 0; i < items.length; i++) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: _iconBg,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icons[i % icons.length],
                          color: _green,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          items[i],
                          style: const TextStyle(
                            fontFamily: 'Codec Pro',
                            fontSize: 12,
                            height: 1.131,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],

                // Ok button
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(106.667),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0F000000),
                        blurRadius: 18.4,
                        offset: Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(106.667),
                      onTap: () => Navigator.of(context).pop(),
                      child: Center(
                        child: Text(
                          okButtonText ?? 'Ok',
                          style: GoogleFonts.alexandria(
                            fontSize: 18,
                            height: 26 / 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the `</>` button on the right!
