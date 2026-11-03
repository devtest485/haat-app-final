import '/custom_code/api_client.dart';
import '/custom_code/api_result.dart';

/// How the person receiving is named: their `@handle`, or their phone number.
enum TransferBy {
  username,
  mobile;
}

/// Who a transfer would reach, as the server found them.
///
/// Only what the sender needs to recognise the person: never their full number.
class TransferRecipient {
  const TransferRecipient({
    required this.name,
    required this.businessName,
    this.username,
    this.mobileMasked,
  });

  final String name;
  final String businessName;
  final String? username;

  /// The end of their number only: `+249 •••• 4567`.
  final String? mobileMasked;

  /// Up to two letters for the avatar: `Amna Fabrics` is `AF`.
  String get initials {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first.substring(0, 1).toUpperCase();

    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  factory TransferRecipient.fromData(Map<String, dynamic> data) =>
      TransferRecipient(
        name: data['name'] as String? ?? '',
        businessName: data['businessName'] as String? ?? '',
        username: data['username'] as String?,
        mobileMasked: data['mobileMasked'] as String?,
      );
}

/// A transfer that went through, as the books recorded it.
class TransferReceipt {
  const TransferReceipt({
    required this.transactionId,
    required this.reference,
    required this.currency,
    required this.amountMinor,
    required this.feeMinor,
    required this.totalMinor,
    required this.recipientName,
    required this.occurredAt,
    this.status = 'completed',
    this.reason,
    this.recipientUsername,
    this.recipientMobileMasked,
    this.note,
  });

  final String transactionId;

  /// `completed`, or `held` while HAAT reviews it, or `rejected` — the money back
  /// in the wallet, with [reason] saying why.
  final String status;
  final String? reason;

  bool get isHeld => status == 'held';
  bool get isRejected => status == 'rejected';

  final String reference;
  final String currency;

  /// What the other merchant received.
  final BigInt amountMinor;

  /// What the bank's rules charged for sending, on top of the amount.
  final BigInt feeMinor;

  /// Amount and fee together — what left the wallet.
  final BigInt totalMinor;

  final String recipientName;
  final String? recipientUsername;
  final String? recipientMobileMasked;
  final String? note;
  final DateTime occurredAt;

  static BigInt _minor(Object? value) =>
      BigInt.tryParse('${value ?? '0'}') ?? BigInt.zero;

  factory TransferReceipt.fromData(Map<String, dynamic> data) =>
      TransferReceipt(
        transactionId: data['transactionId'] as String? ?? '',
        status: data['status'] as String? ?? 'completed',
        reason: data['reason'] as String?,
        reference: data['reference'] as String? ?? '',
        currency: data['currency'] as String? ?? 'SDG',
        amountMinor: _minor(data['amountMinor']),
        feeMinor: _minor(data['feeMinor']),
        totalMinor: _minor(data['totalMinor']),
        recipientName: data['recipientName'] as String? ?? '',
        recipientUsername: data['recipientUsername'] as String?,
        recipientMobileMasked: data['recipientMobileMasked'] as String?,
        note: data['note'] as String?,
        occurredAt:
            DateTime.tryParse(data['occurredAt'] as String? ?? '')?.toLocal() ??
                DateTime.now(),
      );
}

/// Money from this business's wallet to another merchant on HAAT.
class TransferApi {
  TransferApi(this._client);

  final ApiClient _client;

  /// Who [value] would reach — for showing their name before anything is sent.
  ///
  /// A POST, so a phone number never sits in a URL. The server looks them up again when
  /// the money is sent; this answer only decides what the screen shows.
  Future<ApiResult<TransferRecipient>> findRecipient({
    required TransferBy by,
    required String value,
  }) =>
      _client.post(
        '/transfers/recipient',
        body: {'by': by.name, 'value': value},
        parse: (envelope) => TransferRecipient.fromData(envelope.object),
      );

  /// A value for this phone's biometric key to sign, approving exactly this send.
  ///
  /// The server binds it to the recipient, amount, currency and [reference], so the
  /// signature cannot be spent on anything else; it is single-use and short-lived.
  Future<ApiResult<String>> challenge({
    required TransferBy by,
    required String value,
    required BigInt amountMinor,
    required String currency,
    required String reference,
  }) =>
      _client.post(
        '/transfers/challenge',
        body: {
          'to': {'by': by.name, 'value': value},
          'amountMinor': amountMinor.toString(),
          'currency': currency,
          'reference': reference,
        },
        parse: (envelope) => envelope.object['challenge'] as String? ?? '',
      );

  /// Sends [amountMinor] to whoever [value] names, authorised by the [passcode] or by
  /// a [biometricSignature] over the [challenge] for this same send.
  ///
  /// [reference] is made once per transfer and kept across retries: the server answers a
  /// repeated reference with the transfer it already made rather than sending twice.
  Future<ApiResult<TransferReceipt>> send({
    required TransferBy by,
    required String value,
    required BigInt amountMinor,
    required String currency,
    required String reference,
    String? passcode,
    String? biometricSignature,
    String? note,
  }) =>
      _client.post(
        '/transfers',
        idempotencyKey: reference,
        body: {
          'to': {'by': by.name, 'value': value},
          'amountMinor': amountMinor.toString(),
          'currency': currency,
          if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
          'reference': reference,
          if (biometricSignature != null)
            'biometricSignature': biometricSignature
          else
            'passcode': passcode,
        },
        parse: (envelope) => TransferReceipt.fromData(envelope.object),
      );
}
