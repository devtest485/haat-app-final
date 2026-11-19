import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/payout_flow.dart';
import '/custom_code/transaction_api.dart';
import '/custom_code/widgets/wallet_balance.dart';

String _text(dynamic json, String name) {
  final value = json is Map ? json[name] : null;
  final text = value == null ? '' : '$value'.trim();
  return text == 'null' ? '' : text;
}

/// Waits, while the Pending screen is open, for the admin to decide a held payment.
///
/// A payment over the admin's review amount is set aside until somebody approves or
/// refuses it. [outcome] is the Pending outcome and names the held transfer by
/// `transactionId`. Asks the statement every few seconds, so the screen turns as soon as
/// the admin decides: returns the PaymentStatus outcome — `paymentStatus` Success once
/// approved, Error once refused, with the admin's reason — and `{}` when there is nothing
/// to wait for or the page is closed first.
Future<Map<String, dynamic>> awaitHeldDecision(
  BuildContext context,
  dynamic outcome,
) async {
  // A payout to the linked bank account waits on its own list, not on the statement.
  if (_text(outcome, 'payoutId').isNotEmpty && outcome is Map) {
    return await PayoutFlow.waitFor(context, outcome) ?? {};
  }

  final id = _text(outcome, 'transactionId');
  if (id.isEmpty) return {};
  final session = AuthSession.instance;

  while (context.mounted) {
    await Future.delayed(const Duration(seconds: 4));
    if (!context.mounted) return {};

    final result = await session.transactions.list(limit: 50);
    if (!context.mounted) return {};
    if (result is! ApiSuccess<List<MerchantTransaction>>) continue;

    final lines = result.value;
    final hold = lines
        .where((l) => l.transactionId == id && l.kind == 'hold')
        .firstOrNull;
    // Still waiting, or the hold has dropped out of this page of the statement.
    if (hold == null || hold.status == 'on_hold') continue;

    HapticFeedback.mediumImpact();
    WalletBalance.refreshNow();

    if (hold.status == 'hold_released') {
      final decision = lines
          .where((l) => l.reference == 'decision:$id')
          .firstOrNull
          ?.description;
      final reason =
          (decision ?? '').replaceFirst('Transfer not approved:', '').trim();

      return _refused(outcome, reason.isEmpty ? 'Not approved' : reason);
    }

    // `completed`, or `reversed` once it was approved and later taken back.
    return _approved(outcome);
  }
  return {};
}

List<Map<String, dynamic>> _details(dynamic outcome) {
  final given = outcome is Map ? outcome['details'] : null;
  return given is List
      ? given
          .whereType<Map>()
          .map((line) => Map<String, dynamic>.from(line))
          .toList()
      : <Map<String, dynamic>>[];
}

/// The held outcome as the Success screen reads it: the same amounts and lines, now
/// sent.
Map<String, dynamic> _approved(dynamic outcome) {
  final given = outcome is Map ? Map<String, dynamic>.from(outcome) : {};
  final title = _text(outcome, 'approvedTitle');

  return {
    ...given,
    'paymentStatus': 'Success',
    'status': 'Success',
    'kind': 'success',
    'title': title.isEmpty ? 'Payment sent' : title,
    'shareText': _text(outcome, 'shareText')
        .replaceFirst('waiting for approval', 'sent'),
  };
}

/// The held outcome as the Error screen reads it: refused, the money back in the
/// wallet, and the admin's reason.
Map<String, dynamic> _refused(dynamic outcome, String reason) {
  final given = outcome is Map ? Map<String, dynamic>.from(outcome) : {};
  final title = _text(outcome, 'failedTitle');
  final lines = [
    for (final line in _details(outcome))
      if (line['label'] != 'Reason') line,
    {'label': 'Reason', 'value': reason},
  ];

  return {
    ...given,
    'paymentStatus': 'Error',
    // A non-empty status makes Retry go back rather than home.
    'status': 'rejected',
    'kind': 'rejected',
    'title': title.isEmpty ? 'Payment failed' : title,
    'message': reason,
    'subtitle': reason,
    'details': lines,
    'shareText':
        '${_text(outcome, 'shareText').replaceFirst('waiting for approval', 'not approved')}\nReason: $reason',
  };
}
