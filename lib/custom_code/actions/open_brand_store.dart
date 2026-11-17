// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future openBrandStore(
  BuildContext context,
  dynamic item,
  String? languageCode,
) async {
  // A brand card on the Marketplace tab (home or "See all") opens the brand's store.
  if (item is! Map) return;

  context.pushNamed(
    'BrandStore',
    queryParameters: {
      'brandName': serializeParam(
        brandName(item, languageCode),
        ParamType.String,
      ),
      'description': serializeParam(
        notificationText(item, 'description', languageCode),
        ParamType.String,
      ),
      'logoUrl': serializeParam(
        bannerImageUrl(
          item['logoPath']?.toString(),
          FFDevEnvironmentValues().baseURL,
        ),
        ParamType.String,
      ),
      'brandColor': serializeParam(
        brandColorHex(item),
        ParamType.String,
      ),
    }.withoutNulls,
  );
}
