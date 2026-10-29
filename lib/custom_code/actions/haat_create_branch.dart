// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import "dart:math" as math;

import "/custom_code/api_client.dart";
import "/custom_code/api_result.dart";
import "/custom_code/auth_session.dart";
import "/custom_code/token_store.dart";

void _tell(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));

String _branchLetters(String name) =>
    name.toUpperCase().replaceAll(RegExp(r"[^A-Z0-9]"), "");

String _branchCode(String name, math.Random random) =>
    (_branchLetters(name).isEmpty
        ? "BR"
        : _branchLetters(name)
            .substring(0, math.min(6, _branchLetters(name).length))) +
    "-" +
    (1000 + random.nextInt(9000)).toString();

bool _codeTaken(ApiResult<bool> result) =>
    result is ApiFailure<bool> && result.envelope.responseCode == 409;

Future<ApiResult<bool>> _postBranch(ApiClient client, Map<String, dynamic> body,
        String name, math.Random random) =>
    client.post("/organizations/branches",
        body: body..["code"] = _branchCode(name, random), parse: (_) => true);

Future haatCreateBranch(
    BuildContext context, String? name, String? address) async {
  final branchName = name?.trim() ?? "";
  if (branchName.length < 2) return _tell(context, "Enter a branch name.");
  final branchAddress = address?.trim() ?? "";
  final body = Map<String, dynamic>();
  body["name"] = branchName;
  if (branchAddress.isNotEmpty) body["address"] = branchAddress;
  await haatAccessToken();
  final tokens = TokenStore();
  await tokens.restore();
  final language = AuthSession.instance.languageCode;
  final client = ApiClient(tokens: tokens)..languageCode = language;
  final random = math.Random();
  var result = await _postBranch(client, body, branchName, random);
  for (var attempts = 1; attempts < 3 && _codeTaken(result); attempts++)
    result = await _postBranch(client, body, branchName, random);
  client.close();
  if (!context.mounted) return;
  if (!result.isSuccess) return _tell(context, result.messageIn(language));
  _tell(context, "$branchName was added.");
  context.safePop();
}
