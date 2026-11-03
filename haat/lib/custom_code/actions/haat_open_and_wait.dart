// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future haatOpenAndWait(BuildContext context, String routeName,
    String? paramName, dynamic param) async {
  final hasParam = paramName != null && paramName.isNotEmpty && param != null;
  await context.pushNamed(routeName,
      queryParameters: hasParam
          ? {paramName: serializeParam(param, ParamType.JSON)}.withoutNulls
          : {});
}
