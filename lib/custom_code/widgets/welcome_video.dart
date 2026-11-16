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

import 'package:video_player/video_player.dart';

/// A welcome screen's background: the designer's two-second recording, in which the HAAT
/// pattern comes up over the photo. It plays once, muted, and stays on its last frame.
///
/// [video] and [poster] are asset paths (e.g. `assets/videos/welcome_laptop.mp4`). The poster
/// is the photo without the pattern, which is also the video's first frame, so it holds the
/// screen while the video loads and the two join without a jump. With reduced motion on, the
/// video isn't played and the screen shows its last frame.
class WelcomeVideo extends StatefulWidget {
  const WelcomeVideo({
    super.key,
    this.width,
    this.height,
    required this.video,
    required this.poster,
  });

  final double? width;
  final double? height;
  final String video;
  final String poster;

  @override
  State<WelcomeVideo> createState() => _WelcomeVideoState();
}

class _WelcomeVideoState extends State<WelcomeVideo> {
  VideoPlayerController? _controller;
  bool _started = false;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final controller = VideoPlayerController.asset(
      widget.video,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controller = controller;
    try {
      await controller.initialize();
      await controller.setVolume(0);
      await controller.setLooping(false);
      if (!mounted) return;
      setState(() {});
      // A short beat first, so the photo is seen before the pattern starts.
      await Future.delayed(const Duration(milliseconds: 250));
      if (!mounted) return;
      final reduceMotion = MediaQuery.of(context).disableAnimations;
      if (reduceMotion) {
        await controller.seekTo(controller.value.duration);
      } else {
        await controller.play();
      }
      if (mounted) setState(() => _started = true);
    } catch (_) {
      // The poster stays on screen if the video can't be played.
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final showVideo = !_failed &&
        _started &&
        controller != null &&
        controller.value.isInitialized;

    return SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            widget.poster,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
          if (showVideo)
            ClipRect(
              child: FittedBox(
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
