// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/backend/api_requests/api_calls.dart';

Future haatChangeStaffRole(BuildContext context, dynamic member,
    List<dynamic>? roles, String? roleName) async {
  final role = roleByName(roles, roleName);
  if (member is! Map || role == null || roleName == staffRoleName(member)) {
    Navigator.of(context).pop();
    return;
  }
  final userId = (member['userId'] ?? '').toString();
  final token = await haatAccessToken();
  final assigned = await HaatAuthGroup.assignRoleCall
      .call(bodyJsonJson: assignRoleBody(member, role), accessToken: token);
  if (!context.mounted) return;
  if (!assigned.succeeded) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(HaatAuthGroup.assignRoleCall
                .message(assigned.jsonBody)
                ?.toString() ??
            'The role could not be changed. Check your connection and try again.')));
    return;
  }
  for (final id in staffRevokeIds(member, role)) {
    await HaatAuthGroup.revokeRoleCall
        .call(assignmentId: id, userId: userId, accessToken: token);
  }
  final staff = await HaatAuthGroup.staffCall.call(accessToken: token);
  final fresh =
      staffById(HaatAuthGroup.staffCall.staff(staff.jsonBody), userId);
  if (fresh is Map) member['assignments'] = fresh['assignments'];
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text('Role changed to $roleName')));
  Navigator.of(context).pop(true);
}
