import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/payout_api.dart';
import '/custom_code/wallet_api.dart';
import '/custom_code/widgets/wallet_balance.dart';
import '/flutter_flow/custom_functions.dart' show formatMinor;

/// Sending money from the wallet to the linked bank account, from Review Details to the
/// status screen.
///
/// It goes the way a transfer to a person goes — the same review, the same passcode
/// sheet, the same Success, Pending and Error screens — and ends in a payout, which the
/// back office sends and records. So the answer is nearly always Pending: the money is
/// set aside at once, and the Pending screen turns into Success when HAAT has sent it, or
/// into Error, with the reason, if it is refused.
class PayoutFlow {
  PayoutFlow._();

  static String _short(String id) => id.split('-').first.toUpperCase();

  static String _when(DateTime at) => DateFormat('d MMM y · HH:mm').format(at);

  static Map<String, String> _line(String label, String value) =>
      {'label': label, 'value': value};

  static String _share(String heading, List<Map<String, String>> lines) => [
        heading,
        for (final line in lines) '${line['label']}: ${line['value']}',
      ].join('\n');

  /// The outcome of a send that did not go through: the Error screen's.
  static Map<String, dynamic> _failed(
    String kind,
    String amountMinor,
    String currency,
    String reference,
    String reason, {
    bool keepReference = false,
  }) {
    final now = DateTime.now();
    final lines = [
      _line('Amount', '$currency ${_money(amountMinor, currency)}'),
      _line('Reference number', _short(reference)),
      _line('Date & Time', _when(now)),
      if (reason.isNotEmpty) _line('Reason', reason),
    ];

    return {
      'kind': kind,
      'status': 'Error',
      'message': reason,
      'keepReference': keepReference,
      'title': 'Transfer failed',
      'amount': _money(amountMinor, currency),
      'currency': currency,
      'subtitle': reason,
      'details': lines,
      'shareText': _share('HAAT transfer to bank, not sent', lines),
    };
  }

  static String _money(String minor, String currency) =>
      formatMinor(minor, currency).replaceFirst(RegExp(r'^[A-Z]{3}\s+'), '');

  /// Asks for the payout and turns the answer into what the status screens read.
  ///
  /// A wrong passcode is not a failed transfer, only a message for the passcode sheet:
  /// nothing was asked for, and the same reference may be tried again.
  static Future<Map<String, dynamic>> send({
    required String? passcode,
    required String? amountMinor,
    required String? currency,
    required String? reference,
    required String? name,
    required String? via,
  }) async {
    final session = AuthSession.instance;
    final minor = (amountMinor ?? '').trim();
    final code = (currency ?? '').trim().isEmpty ? 'SDG' : currency!.trim().toUpperCase();
    final ref = (reference ?? '').trim();
    final amount = BigInt.tryParse(minor);

    final linked = await session.bankLinks.linked();
    final account = (linked ?? const []).where((a) => a.currency == code).firstOrNull ??
        (linked ?? const []).firstOrNull;
    final wallet = await session.wallet.get();
    final line = wallet is ApiSuccess<Wallet>
        ? wallet.value.lines.where((l) => l.currency == code).firstOrNull
        : null;

    if (amount == null || account == null || line == null) {
      return _failed(
        'error',
        minor,
        code,
        ref,
        account == null
            ? 'Link your SIB account first.'
            : 'We couldn’t read your wallet. Try again.',
      );
    }

    final result = await session.payouts.request(
      institutionId: line.institutionId,
      currency: code,
      amountMinor: amount,
      bankName: account.label,
      accountName: account.holderName,
      accountNumber: account.accountNumber,
      reference: ref,
      passcode: passcode,
    );

    if (result is ApiUnreachable<Payout>) {
      // The request may or may not have arrived: a retry keeps the reference, so the
      // money is not set aside twice.
      return _failed(
        'offline',
        minor,
        code,
        ref,
        'Couldn’t reach HAAT. Check your connection and try again.',
        keepReference: true,
      );
    }

    final payout = result.valueOrNull;
    if (payout == null) {
      final field = result is ApiFailure<Payout> ? '${result.data['field'] ?? ''}' : '';
      final message = result.messageIn(session.languageCode);

      if (field == 'passcode') {
        return {
          'kind': 'credential',
          'status': '',
          'message': message,
          'keepReference': true,
        };
      }

      return _failed('error', minor, code, ref, message);
    }

    WalletBalance.refreshNow();

    final label = name == null || name.trim().isEmpty ? account.holderName : name.trim();
    final target = (via ?? '').trim().isEmpty
        ? '${account.label} ${account.displayNumber}'
        : via!.trim();
    final lines = [
      _line('Amount', '$code ${_money(payout.amountMinor.toString(), code)}'),
      if (payout.feeMinor > BigInt.zero)
        _line('Fee', '$code ${_money(payout.feeMinor.toString(), code)}'),
      _line('From', 'HAAT wallet'),
      _line('To Account', target),
      _line('Reference number', _short(payout.id)),
      _line('Receiver Name', label),
      _line('Date & Time', _when(payout.requestedAt)),
    ];

    return {
      'kind': 'held',
      'status': 'Pending',
      // The payout's own id: the Pending screen asks about it until HAAT decides.
      'transactionId': payout.id,
      'payoutId': payout.id,
      'approvedTitle': 'Money sent',
      'failedTitle': 'Transfer failed',
      'keepReference': false,
      'title': 'Waiting for approval',
      'amount': _money(payout.amountMinor.toString(), code),
      'currency': code,
      'subtitle': '$label · ${account.label} transfer',
      'details': lines,
      'shareText': _share('HAAT transfer to bank, waiting for approval', lines),
    };
  }

  /// Waits, while the Pending screen is open, for HAAT to send or refuse the payout.
  ///
  /// Asks for the payouts every few seconds; returns once the one named by [outcome] is
  /// decided — `paid` is Success, `rejected` or `cancelled` is Error with the reason — and
  /// null when the page closes first.
  static Future<Map<String, dynamic>?> waitFor(
    BuildContext context,
    Map<dynamic, dynamic> outcome,
  ) async {
    final id = '${outcome['payoutId'] ?? ''}';
    if (id.isEmpty) return null;

    while (context.mounted) {
      await Future.delayed(const Duration(seconds: 4));
      if (!context.mounted) return null;

      final result = await AuthSession.instance.payouts.list();
      if (!context.mounted) return null;
      if (result is! ApiSuccess<List<Payout>>) continue;

      final payout = result.value.where((p) => p.id == id).firstOrNull;
      if (payout == null || payout.status == PayoutStatus.requested) continue;

      HapticFeedback.mediumImpact();
      WalletBalance.refreshNow();

      final given = Map<String, dynamic>.from(outcome);

      if (payout.status == PayoutStatus.paid) {
        final lines = [
          for (final line in (given['details'] as List? ?? const []))
            if (line is Map) Map<String, dynamic>.from(line),
          if (payout.bankReference != null)
            {'label': 'Bank reference', 'value': payout.bankReference!},
        ];

        return {
          ...given,
          'paymentStatus': 'Success',
          'status': 'Success',
          'kind': 'success',
          'title': '${given['approvedTitle'] ?? 'Money sent'}',
          'details': lines,
          'shareText': '${given['shareText'] ?? ''}'.replaceFirst('waiting for approval', 'sent'),
        };
      }

      final reason = payout.status == PayoutStatus.cancelled
          ? 'The transfer was cancelled'
          : ((payout.reason ?? '').trim().isEmpty ? 'Not approved' : payout.reason!.trim());
      final lines = [
        for (final line in (given['details'] as List? ?? const []))
          if (line is Map && line['label'] != 'Reason') Map<String, dynamic>.from(line),
        {'label': 'Reason', 'value': reason},
      ];

      return {
        ...given,
        'paymentStatus': 'Error',
        'status': 'rejected',
        'kind': 'rejected',
        'title': '${given['failedTitle'] ?? 'Transfer failed'}',
        'message': reason,
        'subtitle': reason,
        'details': lines,
        'shareText':
            '${'${given['shareText'] ?? ''}'.replaceFirst('waiting for approval', 'not approved')}\nReason: $reason',
      };
    }

    return null;
  }
}
