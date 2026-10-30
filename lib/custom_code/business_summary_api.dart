import '/custom_code/api_client.dart';
import '/custom_code/api_result.dart';
import '/custom_code/wallet_api.dart' show splitMinor;

/// What the business took in over a day, week or month: `GET /business/summary`.
class BusinessSummary {
  const BusinessSummary({
    required this.period,
    required this.currency,
    required this.totalMinor,
    required this.changePercent,
    required this.series,
    required this.channels,
  });

  BusinessSummary.empty(this.period)
      : currency = 'SDG',
        totalMinor = BigInt.zero,
        changePercent = null,
        series = const [],
        channels = const {};

  final String period;
  final String currency;
  final BigInt totalMinor;

  /// Against the period before; null when there was nothing to compare with.
  final int? changePercent;

  /// One bucket per chart step: (label, labelAr, amount in minor units).
  final List<(String, String, BigInt)> series;

  /// `qr`, `nfc`, `link`, `invoice` → (count, share in percent).
  final Map<String, (int, int)> channels;

  static BusinessSummary fromData(Map<String, dynamic> data) {
    BigInt minor(Object? value) =>
        BigInt.tryParse('${value ?? 0}') ?? BigInt.zero;
    int whole(Object? value) =>
        value is num ? value.round() : int.tryParse('$value') ?? 0;

    return BusinessSummary(
      period: '${data['period'] ?? 'week'}',
      currency: '${data['currency'] ?? 'SDG'}',
      totalMinor: minor(data['totalMinor']),
      changePercent:
          data['changePercent'] == null ? null : whole(data['changePercent']),
      series: (data['series'] is List ? data['series'] as List : const [])
          .whereType<Map<String, dynamic>>()
          .map((b) => (
                '${b['label'] ?? ''}',
                '${b['labelAr'] ?? b['label'] ?? ''}',
                minor(b['amountMinor'])
              ))
          .toList(),
      channels: {
        for (final c in (data['byChannel'] is List
                ? data['byChannel'] as List
                : const [])
            .whereType<Map<String, dynamic>>())
          '${c['channel']}': (whole(c['count']), whole(c['sharePercent'])),
      },
    );
  }

  Map<String, dynamic> toJson(String languageCode) {
    final (whole, fraction) = splitMinor(totalMinor, currency);
    final against = switch (period) {
      'day' => 'yesterday',
      'month' => 'last month',
      _ => 'last week'
    };
    final arabic = languageCode.toLowerCase().startsWith('ar');

    String count(String key) {
      final n = channels[key]?.$1 ?? 0;
      return '$n ${n == 1 ? 'payment' : 'payments'}';
    }

    String share(String key) => '${channels[key]?.$2 ?? 0}%';

    return {
      'total': totalMinor == BigInt.zero ? '0' : '+$whole',
      'fraction': fraction == '.00' ? '' : fraction,
      'currency': currency,
      'change': changePercent == null
          ? ''
          : '${changePercent! >= 0 ? '+' : '−'} ${changePercent!.abs()}% vs $against',
      // Major units for the chart: it only compares the steps with each other.
      'values': [for (final s in series) s.$3.toDouble() / 100],
      'labels': [for (final s in series) arabic ? s.$2 : s.$1],
      'qrCount': count('qr'),
      'qrShare': share('qr'),
      'nfcCount': count('nfc'),
      'nfcShare': share('nfc'),
      'linkCount': count('link'),
      'linkShare': share('link'),
      'shares': [
        (channels['qr']?.$2 ?? 0).toDouble(),
        (channels['nfc']?.$2 ?? 0).toDouble(),
        (channels['link']?.$2 ?? 0).toDouble(),
      ],
    };
  }
}

class BusinessSummaryApi {
  BusinessSummaryApi(this._client);

  final ApiClient _client;

  /// Null when the server could not be reached or refused (no business, no permission).
  Future<BusinessSummary?> load(String period) async {
    final result = await _client.get<BusinessSummary>(
      '/business/summary',
      query: {'period': period},
      parse: (envelope) {
        final data = envelope.data;
        return BusinessSummary.fromData(
            data is Map<String, dynamic> ? data : const {});
      },
    );
    return result.valueOrNull;
  }
}
