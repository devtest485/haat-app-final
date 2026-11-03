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

  /// Nothing taken yet, or the server could not say: the period's steps at zero,
  /// so the chart draws flat rather than falling back to its design sample.
  BusinessSummary.empty(this.period)
      : currency = 'SDG',
        totalMinor = BigInt.zero,
        changePercent = null,
        series = [
          for (final (en, ar) in _steps[period] ?? _steps['week']!)
            (en, ar, BigInt.zero)
        ],
        channels = const {};

  /// The server's steps for each period, for [BusinessSummary.empty].
  static const _steps = {
    'day': [
      ('12am', '12 ص'),
      ('4am', '4 ص'),
      ('8am', '8 ص'),
      ('12pm', '12 م'),
      ('4pm', '4 م'),
      ('8pm', '8 م'),
    ],
    'week': [
      ('Sat', 'السبت'),
      ('Sun', 'الأحد'),
      ('Mon', 'الاثنين'),
      ('Tue', 'الثلاثاء'),
      ('Wed', 'الأربعاء'),
      ('Thu', 'الخميس'),
      ('Fri', 'الجمعة'),
    ],
    'month': [
      ('W1', 'الأسبوع 1'),
      ('W2', 'الأسبوع 2'),
      ('W3', 'الأسبوع 3'),
      ('W4', 'الأسبوع 4'),
      ('W5', 'الأسبوع 5'),
    ],
  };

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

    // An invoice is paid through its link, so it is counted with the links: the
    // three rows then add up to every payment, and their shares to 100.
    (int, int) of(String key) {
      final (count, share) = channels[key] ?? (0, 0);
      if (key != 'link') return (count, share);
      final (invoices, invoiceShare) = channels['invoice'] ?? (0, 0);
      return (count + invoices, share + invoiceShare);
    }

    String count(String key) {
      final n = of(key).$1;
      return '$n ${n == 1 ? 'payment' : 'payments'}';
    }

    String share(String key) => '${of(key).$2}%';

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
        of('qr').$2.toDouble(),
        of('nfc').$2.toDouble(),
        of('link').$2.toDouble(),
      ],
      // The step now falls in, in Khartoum time like the server's: the bar the
      // chart opens on.
      'selected': _now(series.length),
    };
  }

  int _now(int steps) {
    if (steps == 0) return 0;
    final now = DateTime.now().toUtc().add(const Duration(hours: 2));
    final index = switch (period) {
      'day' => now.hour ~/ 4,
      'month' => (now.day - 1) ~/ 7,
      // Saturday first.
      _ => (now.weekday + 1) % 7,
    };
    return index.clamp(0, steps - 1);
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
