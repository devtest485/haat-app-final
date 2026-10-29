// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

Future<FFUploadedFile?> haatPickProductPhoto(BuildContext context) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: const ['png'],
    withData: true,
  );
  final file = result?.files.firstOrNull;
  final bytes = file?.bytes;
  if (file == null || bytes == null) {
    return null;
  }

  final problem = _pngProblem(bytes);
  if (problem != null) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(problem)));
    }
    return null;
  }

  // The upload's type is taken from the name, so it has to end in .png.
  final name =
      file.name.toLowerCase().endsWith('.png') ? file.name : '${file.name}.png';
  return FFUploadedFile(name: name, bytes: bytes);
}

const _maxBytes = 512 * 1024;
const _minSide = 300;
const _signature = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];

String? _pngProblem(Uint8List bytes) {
  // Signature (8) + IHDR length and type (8) + width and height (8).
  if (bytes.length < 24 ||
      !List.generate(8, (i) => bytes[i] == _signature[i]).every((ok) => ok)) {
    return 'Choose a PNG image.';
  }
  if (bytes.length > _maxBytes) {
    return 'That photo is too large. Choose a PNG of 512 KB or less.';
  }
  final header = ByteData.sublistView(bytes, 16, 24);
  final width = header.getUint32(0);
  final height = header.getUint32(4);
  if (width < _minSide || height < _minSide) {
    return 'That photo is too small. Choose one at least 300 × 300 pixels.';
  }
  return null;
}
