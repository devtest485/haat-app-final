// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import "/custom_code/api_client.dart";
import "/custom_code/auth_session.dart";
import "/custom_code/token_store.dart";

void _tell(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));

Future haatSaveProduct(
    BuildContext context,
    String? productId,
    String? name,
    String? price,
    String? unit,
    String? quantity,
    bool? outOfStock,
    FFUploadedFile? photo) async {
  final problem = productFormError(name, price, unit, quantity, outOfStock);
  if (problem.isNotEmpty) return _tell(context, problem);
  final body = Map<String, dynamic>();
  body["name"] = name!.trim();
  body["unit"] = (unit ?? "").trim();
  body["priceMinor"] = priceToMinor(price);
  body["quantity"] = productQuantity(quantity, outOfStock);
  await haatAccessToken();
  final tokens = TokenStore();
  await tokens.restore();
  final language = AuthSession.instance.languageCode;
  final client = ApiClient(tokens: tokens)..languageCode = language;
  final id = productId?.trim() ?? "";
  final result = id.isEmpty
      ? await client.post("/products",
          body: body,
          parse: (envelope) => envelope.object["id"]?.toString() ?? "")
      : await client.patch("/products/$id", body: body, parse: (_) => id);
  final savedId = result.valueOrNull ?? "";
  final bytes = photo?.bytes;
  final upload = savedId.isEmpty || bytes == null || bytes.isEmpty
      ? null
      : await client.postFile("/products/$savedId/image",
          bytes: bytes,
          filename: photo?.name ?? "product.png",
          parse: (_) => true);
  client.close();
  if (!context.mounted) return;
  if (!result.isSuccess) return _tell(context, result.messageIn(language));
  if (upload != null && !upload.isSuccess)
    _tell(
        context,
        "The product was saved, but its photo was not. " +
            upload.messageIn(language));
  context.safePop();
}
