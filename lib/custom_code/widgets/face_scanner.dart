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

import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class FaceScanner extends StatefulWidget {
  const FaceScanner({
    super.key,
    this.width,
    this.height,
    this.title,
    this.showBackButton,
    this.useFrontCamera,
    this.mirrorPreview,
    this.ovalWidthFactor,
    this.ovalAspectRatio,
    this.dimOutsideOval,
    this.hintText,
    this.onCaptured,
    this.onClose,
  });

  final double? width;
  final double? height;

  /// Top title — default: 'ID Scanning'
  final String? title;

  /// Top-left back arrow — default: true
  final bool? showBackButton;

  /// Selfie camera — default: true
  final bool? useFrontCamera;

  /// Preview ko selfie ki tarah mirror karein — default: false
  /// (Device ke hisaab se preview ulta lage to isay true kar dein)
  final bool? mirrorPreview;

  /// Oval ki chaurai screen ke % me — default: 0.60
  final double? ovalWidthFactor;

  /// Oval ka height / width — default: 1.5
  final double? ovalAspectRatio;

  /// Oval ke bahar 56% black scrim — default: true (design ke mutabiq)
  final bool? dimOutsideOval;

  /// Oval ke neeche optional hint — khaali chhod dein to nahi dikhega
  final String? hintText;

  /// Capture hone par local file path (Action param)
  final Future Function(String imagePath)? onCaptured;

  /// Back press par — sirf tab chalta hai jab stack me pop karne ke liye
  /// kuch na ho (jaise deep link se yeh pehla page khula ho). Back arrow
  /// khud pop karta hai, is liye is action me "next page" par navigate
  /// karne wala step na rakhein. (Action param)
  final Future Function()? onClose;

  @override
  State<FaceScanner> createState() => _FaceScannerState();
}

class _FaceScannerState extends State<FaceScanner> with WidgetsBindingObserver {
  /// Design: `rgba(0, 0, 0, 0.56)` — same scrim token as the ID scanner.
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

      final wantFront = widget.useFrontCamera ?? true;
      final target =
          wantFront ? CameraLensDirection.front : CameraLensDirection.back;
      final selected = cameras.firstWhere(
        (c) => c.lensDirection == target,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        selected,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await controller.initialize();
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
        message: 'Camera permission is required to take your selfie.',
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

  /// FlutterFlow passes `double.infinity` for a custom widget set to fill its
  /// parent. Multiplying that produces an infinite oval, so resolve it against
  /// the real constraints before doing any layout maths.
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

    final ovalW = w * (widget.ovalWidthFactor ?? 0.60);
    final ovalH = ovalW * (widget.ovalAspectRatio ?? 1.5);
    const ovalAlign = Alignment(0, -0.18);

    return SizedBox(
      width: w,
      height: h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(color: Colors.black),

          if (_hasPreview)
            _CoverPreview(
              controller: _controller!,
              mirror: widget.mirrorPreview ?? false,
            ),

          // 56% black scrim outside the oval, matching the ID scanner's
          // design token — the face itself stays clear.
          if (widget.dimOutsideOval ?? true)
            IgnorePointer(
              child: CustomPaint(
                painter: _OvalScrimPainter(
                  ovalSize: Size(ovalW, ovalH),
                  alignment: ovalAlign,
                  color: _scrim,
                ),
              ),
            ),

          if (!_hasPreview) Center(child: _statusBlock()),

          // Face oval outline
          Align(
            alignment: ovalAlign,
            child: SizedBox(
              width: ovalW,
              height: ovalH,
              child: CustomPaint(
                painter: _OvalGuidePainter(
                  color: Colors.white,
                  stroke: 3,
                ),
              ),
            ),
          ),

          // Optional hint
          if ((widget.hintText ?? '').isNotEmpty)
            Align(
              alignment: Alignment(0, ovalAlign.y + (ovalH / h) + 0.10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  widget.hintText!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.alexandria(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w400,
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
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.18),
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                  child: Center(
                    child: _capturing
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.85),
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
  const _CoverPreview({required this.controller, this.mirror = false});
  final CameraController controller;
  final bool mirror;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    var scale = size.aspectRatio * controller.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;
    Widget preview = Center(child: CameraPreview(controller));
    if (mirror) {
      preview = Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
        child: preview,
      );
    }
    return ClipRect(
      child: Transform.scale(scale: scale, child: preview),
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

/// Sirf oval ka white outline.
class _OvalGuidePainter extends CustomPainter {
  _OvalGuidePainter({required this.color, required this.stroke});
  final Color color;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;
    canvas.drawOval(
      Rect.fromLTWH(
        stroke / 2,
        stroke / 2,
        size.width - stroke,
        size.height - stroke,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _OvalGuidePainter old) =>
      old.color != color || old.stroke != stroke;
}

/// Oval ke bahar dark scrim (hole punched).
class _OvalScrimPainter extends CustomPainter {
  _OvalScrimPainter({
    required this.ovalSize,
    required this.alignment,
    required this.color,
  });
  final Size ovalSize;
  final Alignment alignment;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = alignment.withinRect(rect);
    final ovalRect = Rect.fromCenter(
      center: center,
      width: ovalSize.width,
      height: ovalSize.height,
    );
    final path = Path.combine(
      PathOperation.difference,
      Path()..addRect(rect),
      Path()..addOval(ovalRect),
    );
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _OvalScrimPainter old) =>
      old.ovalSize != ovalSize ||
      old.alignment != alignment ||
      old.color != color;
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the `</>` button on the right!
