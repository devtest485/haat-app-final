// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future openMarketplaceItem(
  BuildContext context,
  dynamic item,
  String? languageCode,
) async {
  if (item is! Map) return;

  final flow = (item['flow'] ?? '').toString();
  if (flow == 'link') {
    await openBannerLink(context, item['linkUrl']?.toString(), null);
    return;
  }

  context.pushNamed(
    'PayYour',
    queryParameters: {
      'billerName': serializeParam(
        notificationText(item, 'name', languageCode),
        ParamType.String,
      ),
      'logoUrl': serializeParam(
        bannerImageUrl(
          item['logoPath']?.toString(),
          FFDevEnvironmentValues().baseURL,
        ),
        ParamType.String,
      ),
      'flow': serializeParam(
        flow,
        ParamType.String,
      ),
    }.withoutNulls,
  );
}
