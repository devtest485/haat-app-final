import '/custom_code/api_client.dart';
import '/custom_code/api_result.dart';

/// One line of the merchant's statement.
///
/// Their own side of a movement: a customer's payment also moves the platform's
/// commission, and that line belongs to the platform rather than to the merchant whose
/// screen this is.
class MerchantTransaction {
  const MerchantTransaction({
    required this.id,
    required this.kind,
    required this.reference,
    required this.description,
    required this.occurredAt,
    required this.direction,
    required this.amountMinor,
    required this.currency,
    this.counterparty,
  });

  final String id;

  /// What the movement was — `payment`, `payout`, `release`, and so on.
  final String kind;
  final String reference;
  final String? description;
  final DateTime occurredAt;

  /// `credit` when money came in, `debit` when it went out.
  final String direction;

  /// Always positive, in minor units. [direction] carries the sign.
  final int amountMinor;
  final String currency;

  /// The other merchant, on a transfer between two: who it went to, or came from.
  final String? counterparty;

  /// A transfer between merchants — drawn yellow when sent and green when received.
  bool get isTransfer => kind == 'transfer';

  bool get incoming => direction == 'credit';

  /// The amount as a person reads it: `SDG 4,200`.
  ///
  /// Minor units divided by a hundred, which is right for every currency this platform
  /// deals in. Grouped by thousands because a five-figure balance without separators is
  /// a number people misread.
  String get amount {
    final major = amountMinor ~/ 100;
    final cents = amountMinor % 100;
    final grouped = major.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+$)'),
          (match) => '${match[1]},',
        );

    return cents == 0
        ? '$currency $grouped'
        : '$currency $grouped.${cents.toString().padLeft(2, '0')}';
  }

  /// What to call the line when the posting carried no description of its own.
  String get title {
    final other = counterparty?.trim() ?? '';
    if (isTransfer && other.isNotEmpty) {
      return incoming ? 'From $other' : 'To $other';
    }

    final given = description?.trim() ?? '';
    if (given.isNotEmpty) return given;

    return switch (kind) {
      'payment' => 'Payment received',
      'payout' => 'Payout',
      'release' => 'Funds released',
      'refund' => 'Refund',
      'fee' => 'Fee',
      'transfer' => 'Transfer',
      _ => 'Transaction',
    };
  }

  factory MerchantTransaction.fromData(Map<String, dynamic> data) {
    final transfer = data['transfer'] is Map<String, dynamic>
        ? data['transfer'] as Map<String, dynamic>
        : null;
    final incoming = (data['direction'] as String? ?? 'credit') == 'credit';

    return MerchantTransaction(
      id: data['entryId'] as String? ?? '',
      kind: data['kind'] as String? ?? '',
      reference: data['reference'] as String? ?? '',
      description: data['description'] as String?,
      occurredAt:
          DateTime.tryParse(data['occurredAt'] as String? ?? '')?.toLocal() ??
              DateTime.now(),
      direction: data['direction'] as String? ?? 'credit',
      // A string on the wire: balances outgrow what a JSON number can hold exactly.
      amountMinor: int.tryParse('${data['amountMinor'] ?? '0'}') ?? 0,
      currency: data['currency'] as String? ?? 'SDG',
      counterparty: transfer?[incoming ? 'fromName' : 'toName'] as String?,
    );
  }
}

/// The merchant's statement.
class TransactionApi {
  TransactionApi(this._client);

  final ApiClient _client;

  /// What has moved through the business's account, newest first.
  ///
  /// [since] serves the screen's own filters — last week, last thirty days — so the
  /// phone asks for the window it is showing rather than fetching a year and hiding
  /// most of it.
  ///
  /// An empty list is the ordinary answer for a business that has not traded yet, and
  /// the screen has a state drawn for exactly that.
  Future<ApiResult<List<MerchantTransaction>>> list({
    DateTime? since,
    int limit = 20,
  }) =>
      _client.get(
        '/transactions',
        query: {
          'limit': '$limit',
          if (since != null) 'since': since.toUtc().toIso8601String(),
        },
        parse: (envelope) => envelope.list
            .whereType<Map<String, dynamic>>()
            .map(MerchantTransaction.fromData)
            .toList(),
      );
}
