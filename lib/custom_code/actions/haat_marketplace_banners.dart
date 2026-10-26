// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/banner_api.dart';

/// Marketplace hero slides from the back office (placement=marketplace), as a
/// JSON list for the Carousel.
Future<List<dynamic>> haatMarketplaceBanners() async {
  final session = AuthSession.instance;
  final result = await session.banners.list(placement: 'marketplace');
  if (result is! ApiSuccess<List<HomeBanner>>) return [];
  final language = session.languageCode;
  return result.value
      .map((slide) => <String, dynamic>{
            'id': slide.id,
            'title': slide.titleIn(language),
            'cta': slide.ctaIn(language),
            'imageUrl': slide.imageUrl,
            'actionUrl': slide.actionUrl,
            'actionRoute': slide.actionRoute
          })
      .toList();
}
