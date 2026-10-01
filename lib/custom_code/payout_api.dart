import '/custom_code/api_client.dart';
import '/custom_code/api_result.dart';
import '/custom_code/wallet_api.dart';

/// Where a payout stands, in the words the merchant reads.
///
/// - `requested` — set aside from the available balance, waiting for HAAT to send it.
/// - `paid` — sent from the trust account; the bank's reference is on record.
/// - `rejected` — refused by HAAT, with a reason; the money went back.
/// - `cancelled` — withdrawn by the merchant before anybody decided; the money went back.
enum PayoutStatus {
  requested('Waiting'),
  paid('Sent'),
  rejected('Rejected'),
  cancelled('Cancelled');

  const PayoutStatus(this.label);

  final String label;

  static PayoutStatus parse(Object? value) => PayoutStatus.values.firstWhere(
        (status) => status.name == value,
        orElse: () => PayoutStatus.requested,
      );
}

/// A business's available money asked to go to its own bank account.
class Payout {
  const Payout({
    required this.id,
    required this.currency,
    required this.amountMinor,
    required this.feeMinor,
    required this.totalMinor,
    required this.bankName,
    required this.accountName,
    required this.accountNumber,
    required this.status,
    required this.requestedAt,
    this.bankReference,
    this.reason,
  });

  final String id;
  final String currency;

  /// What reaches the account.
  final BigInt amountMinor;

  /// What the platform charges for sending it, on top of the amount.
  final BigInt feeMinor;

  /// Amount and fee together — what left the available balance.
  final BigInt totalMinor;

  final String bankName;
  final String accountName;
  final String accountNumber;
  final PayoutStatus status;
  final DateTime requestedAt;

  /// The bank's reference for the transfer, once sent.
  final String? bankReference;

  /// Why HAAT refused it, when it did.
  final String? reason;

  /// The account's last four, so a list shows which account without showing all of it.
  String get maskedAccount => accountNumber.length > 4
      ? '••${accountNumber.substring(accountNumber.length - 4)}'
      : accountNumber;

  static BigInt _minor(Object? value) =>
      BigInt.tryParse('${value ?? '0'}') ?? BigInt.zero;

  factory Payout.fromData(Map<String, dynamic> data) {
    final destination = data['destination'] is Map<String, dynamic>
        ? data['destination'] as Map<String, dynamic>
        : const <String, dynamic>{};

    return Payout(
      id: data['id'] as String? ?? '',
      currency: data['currency'] as String? ?? 'SDG',
      amountMinor: _minor(data['amountMinor']),
      feeMinor: _minor(data['feeMinor']),
      totalMinor: _minor(data['totalMinor']),
      bankName: destination['bankName'] as String? ?? '',
      accountName: destination['accountName'] as String? ?? '',
      accountNumber: destination['accountNumber'] as String? ?? '',
      status: PayoutStatus.parse(data['status']),
      requestedAt:
          DateTime.tryParse(data['requestedAt'] as String? ?? '')?.toLocal() ??
              DateTime.now(),
      bankReference: data['bankReference'] as String?,
      reason: data['reason'] as String?,
    );
  }
}

/// What a person typed, as whole minor units — `"125.5"` in SDG is `125 50` — or null.
///
/// Joined as digits, never multiplied, so `0.1` is ten piastres and not a float's guess.
/// Refuses rather than rounds a figure with more places than the currency has, and
/// refuses zero, since nothing is not an amount to send.
BigInt? toMinor(String typed, String currency) {
  final places = placesOf(currency);
  final cleaned = typed.trim().replaceAll(',', '');
  final shape = places == 0
      ? RegExp(r'^(\d+)$')
      : RegExp('^(\\d+)(?:\\.(\\d{1,$places}))?\$');
  final match = shape.firstMatch(cleaned);
  if (match == null) return null;

  final minor =
      BigInt.parse('${match[1]}${(match[2] ?? '').padRight(places, '0')}');

  return minor == BigInt.zero ? null : minor;
}

/// The business's own payouts.
class PayoutApi {
  PayoutApi(this._client);

  final ApiClient _client;

  /// Newest first. Empty is the ordinary answer before the first payout.
  Future<ApiResult<List<Payout>>> list() => _client.get(
        '/payouts',
        parse: (envelope) => envelope.list
            .whereType<Map<String, dynamic>>()
            .map(Payout.fromData)
            .toList(),
      );

  /// Asks for [amountMinor] to be sent to the account given.
  ///
  /// [reference] is the caller's own, made once per payout and kept across retries: the
  /// platform answers a repeated reference with the payout it already made, rather than
  /// setting the money aside twice.
  Future<ApiResult<Payout>> request({
    required String institutionId,
    required String currency,
    required BigInt amountMinor,
    required String bankName,
    required String accountName,
    required String accountNumber,
    String? note,
    required String reference,
  }) =>
      _client.post(
        '/payouts',
        idempotencyKey: reference,
        body: {
          'institutionId': institutionId,
          'currency': currency,
          'amountMinor': amountMinor.toString(),
          'destination': {
            'bankName': bankName.trim(),
            'accountName': accountName.trim(),
            'accountNumber': accountNumber.trim(),
          },
          if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
          'reference': reference,
        },
        parse: (envelope) => Payout.fromData(envelope.object),
      );

  /// Withdraws a payout HAAT has not decided yet. The money comes back.
  Future<ApiResult<Payout>> cancel(String id) => _client.post(
        '/payouts/$id/cancel',
        parse: (envelope) => Payout.fromData(envelope.object),
      );
}
