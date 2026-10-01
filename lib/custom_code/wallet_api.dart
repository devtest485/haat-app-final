import '/custom_code/api_client.dart';
import '/custom_code/api_result.dart';

/// Minor-unit places per currency, from the platform's own table. Two unless listed.
///
/// A screen assuming two would show a Libyan balance ten times too large — the dinars
/// use three.
const _places = <String, int>{
  'LYD': 3,
  'KWD': 3,
  'BHD': 3,
  'OMR': 3,
  'TND': 3,
  'JOD': 3,
  'IQD': 3,
  'JPY': 0,
};

int placesOf(String currency) => _places[currency.toUpperCase()] ?? 2;

/// An amount in minor units, split for display: `('12,300', '.50')`.
///
/// String arithmetic on a [BigInt], never division, so a balance past what a double
/// holds exactly still shows every digit. The two halves are returned apart because the
/// home screen draws the whole part large and the fraction small.
(String whole, String fraction) splitMinor(BigInt minor, String currency) {
  final places = placesOf(currency);
  final negative = minor.isNegative;
  final digits = minor.abs().toString().padLeft(places + 1, '0');

  final whole = digits
      .substring(0, digits.length - places)
      .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
  final fraction = places == 0 ? '' : '.${digits.substring(digits.length - places)}';

  return ('${negative ? '-' : ''}$whole', fraction);
}

/// What the business holds at one bank, in one currency.
///
/// Four figures because they mean different things: only [availableMinor] can be spent
/// or withdrawn. The rest is still the merchant's, waiting on the back office, set aside
/// for a payment, or held against refunds.
class WalletLine {
  const WalletLine({
    this.institutionId = '',
    required this.institutionCode,
    required this.institutionName,
    required this.currency,
    required this.availableMinor,
    required this.pendingMinor,
    required this.heldMinor,
    required this.reserveMinor,
  });

  /// The bank's id — what a payout from this line names as the books it leaves.
  final String institutionId;
  final String institutionCode;
  final String institutionName;
  final String currency;
  final BigInt availableMinor;
  final BigInt pendingMinor;
  final BigInt heldMinor;
  final BigInt reserveMinor;

  // Strings on the wire: balances outgrow what a JSON number holds exactly.
  static BigInt _minor(Object? value) => BigInt.tryParse('${value ?? '0'}') ?? BigInt.zero;

  factory WalletLine.fromData(Map<String, dynamic> data) => WalletLine(
        institutionId: data['institutionId'] as String? ?? '',
        institutionCode: data['institutionCode'] as String? ?? '',
        institutionName: data['institutionName'] as String? ?? '',
        currency: data['currency'] as String? ?? 'SDG',
        availableMinor: _minor(data['availableMinor']),
        pendingMinor: _minor(data['pendingMinor']),
        heldMinor: _minor(data['heldMinor']),
        reserveMinor: _minor(data['reserveMinor']),
      );
}

/// The business's wallet: a line per bank and currency.
class Wallet {
  const Wallet(this.lines);

  final List<WalletLine> lines;

  /// The currency the home screen shows — the first line's, SDG before anything opens.
  String get currency => lines.isEmpty ? 'SDG' : lines.first.currency;

  /// What can be spent, across every bank, in [currency].
  ///
  /// Summed because to the merchant it is one balance; the banks behind it are the
  /// platform's arrangement. Other currencies are left out rather than added, since
  /// pounds and dollars do not add up.
  BigInt get available => lines
      .where((line) => line.currency == currency)
      .fold(BigInt.zero, (sum, line) => sum + line.availableMinor);
}

/// The business's own wallet.
class WalletApi {
  WalletApi(this._client);

  final ApiClient _client;

  /// Empty lines is the ordinary answer before the platform opens a wallet, not a fault.
  Future<ApiResult<Wallet>> get() => _client.get(
        '/wallet',
        parse: (envelope) {
          final data = envelope.data;
          final balances = data is Map<String, dynamic> ? data['balances'] : null;

          return Wallet(
            (balances is List ? balances : const [])
                .whereType<Map<String, dynamic>>()
                .map(WalletLine.fromData)
                .toList(),
          );
        },
      );
}
