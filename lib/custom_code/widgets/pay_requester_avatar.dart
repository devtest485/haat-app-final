// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/pay_request_flow.dart';

/// The logo of the business asking to be paid, round, or its initials on ink.
class PayRequesterAvatar extends StatefulWidget {
  const PayRequesterAvatar({
    super.key,
    this.width,
    this.height,
    this.request,
  });

  final double? width;
  final double? height;
  final dynamic request;

  @override
  State<PayRequesterAvatar> createState() => _PayRequesterAvatarState();
}

class _PayRequesterAvatarState extends State<PayRequesterAvatar> {
  @override
  Widget build(BuildContext context) => PayRequestLogo(
        url: payRequestField(widget.request, 'logoUrl'),
        initials: payRequestField(widget.request, 'initials'),
        size: widget.width ?? 64,
      );
}
