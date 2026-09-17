// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

Future<String> getDeviceLabel() async {
  try {
    final info = DeviceInfoPlugin();

    if (kIsWeb) return 'Browser';

    if (defaultTargetPlatform == TargetPlatform.android) {
      final android = await info.androidInfo;
      final name = '${android.manufacturer} ${android.model}'.trim();

      return name.isEmpty ? 'Android device' : _titleCase(name);
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final ios = await info.iosInfo;

      return ios.name.isEmpty ? 'iPhone' : ios.name;
    }

    return 'Unknown device';
  } catch (_) {
    return 'Unknown device';
  }
}

String _titleCase(String value) => value
    .split(' ')
    .where((word) => word.isNotEmpty)
    .map((word) => word.length == 1
        ? word.toUpperCase()
        : '${word[0].toUpperCase()}${word.substring(1)}')
    .join(' ');
