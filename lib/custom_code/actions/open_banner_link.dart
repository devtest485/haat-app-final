// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:url_launcher/url_launcher.dart';

import '/home_screens/request_stand/request_n_f_c/request_n_f_c_widget.dart';

/// Opens what a tapped banner points at: its web address in the phone's browser, or
/// else the app screen it names.
///
/// A route this build does not have is skipped rather than thrown — the back office
/// can write a card for a screen that ships next week.
Future openBannerLink(
  BuildContext context,
  String? actionUrl,
  String? actionRoute,
) async {
  final link = (actionUrl ?? '').trim();
  final route = (actionRoute ?? '').trim();

  if (link.isNotEmpty && link != 'null') {
    // The back office asks for https://, but a bare address still opens.
    final uri = Uri.tryParse(link.contains('://') ? link : 'https://$link');
    if (uri == null) return;

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) await launchUrl(uri);
    } catch (_) {}
    return;
  }
  if (route.isEmpty || route == 'null') return;

  // Offered by the back office, but a sheet rather than a screen with a route name.
  if (route == 'RequestNFC') {
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.viewInsetsOf(context),
        child: RequestNFCWidget(),
      ),
    );
    return;
  }

  // A route may carry what its screen needs, written as a query: `AddFund?fund=transfer`
  // opens the transfer amount screen, which cannot open without knowing which it is.
  final parsed = Uri.tryParse(route);
  final name = parsed?.path ?? route;
  final query = parsed?.queryParameters ?? const <String, String>{};

  try {
    context.pushNamed(name, queryParameters: query);
  } catch (_) {}
}
