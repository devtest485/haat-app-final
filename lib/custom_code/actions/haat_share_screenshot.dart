// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

/// Shares the screen as the person sees it — the receipt — as a picture.
///
/// [context] is the page or component whose whole area is the picture; [hideBottom]
/// leaves off that many points at its foot, where its own Done and Share buttons
/// are. When no picture can be taken, [fallbackText] is shared instead.
Future haatShareScreenshot(
  BuildContext context,
  double? hideBottom,
  String? fallbackText,
) async {
  final png = await _picture(context, hideBottom ?? 0);
  if (png != null) {
    await SharePlus.instance.share(ShareParams(
      files: [XFile.fromData(png, mimeType: 'image/png')],
      fileNameOverrides: [
        'HAAT-receipt-${DateTime.now().millisecondsSinceEpoch}.png'
      ],
    ));
  } else if (fallbackText != null && fallbackText.trim().isNotEmpty) {
    await SharePlus.instance.share(ShareParams(text: fallbackText));
  }
}

/// [context]'s area, less [hideBottom] at its foot, as a PNG at the screen's own
/// sharpness; null when it isn't on screen to be taken.
Future<Uint8List?> _picture(BuildContext context, double hideBottom) async {
  try {
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return null;
    final ratio = MediaQuery.devicePixelRatioOf(context);

    // The nearest layer above it that can be turned into an image: the route's own.
    RenderObject? node = box;
    while (node != null && node is! RenderRepaintBoundary) {
      node = node.parent;
    }
    if (node is! RenderRepaintBoundary) return null;
    final boundary = node;

    final origin = box.localToGlobal(Offset.zero, ancestor: boundary);
    final height =
        (box.size.height - hideBottom).clamp(1.0, box.size.height).toDouble();
    final source = Rect.fromLTWH(
      origin.dx * ratio,
      origin.dy * ratio,
      box.size.width * ratio,
      height * ratio,
    );

    final whole = await boundary.toImage(pixelRatio: ratio);
    final recorder = ui.PictureRecorder();
    Canvas(recorder).drawImageRect(
      whole,
      source,
      Offset.zero & source.size,
      Paint(),
    );
    final picture = recorder.endRecording();
    final image = await picture.toImage(
      source.width.round(),
      source.height.round(),
    );
    whole.dispose();
    picture.dispose();

    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return data?.buffer.asUint8List();
  } catch (_) {
    return null;
  }
}
