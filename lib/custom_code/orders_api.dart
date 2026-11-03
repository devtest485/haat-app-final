import 'package:intl/intl.dart';

import '/custom_code/api_client.dart';
import '/custom_code/wallet_api.dart' show splitMinor;

/// One line of an order: what was sold, how many, for how much.
class OrderLine {
  const OrderLine({
    required this.description,
    required this.quantity,
    required this.amountMinor,
    required this.productId,
  });

  final String description;
  final int quantity;
  final BigInt amountMinor;

  /// Null for a line sold before lines named their product.
  final String? productId;
}

/// A paid sale the cashier built from products: `GET /business/orders`.
class SaleOrder {
  const SaleOrder({
    required this.id,
    required this.code,
    required this.channel,
    required this.currency,
    required this.amountMinor,
    required this.lines,
    required this.payerName,
    required this.paidAt,
  });

  final String id;
  final String code;

  /// `qr`, `nfc`, `link` or `invoice`; null when the books did not say.
  final String? channel;
  final String currency;

  /// What the customer was charged.
  final BigInt amountMinor;
  final List<OrderLine> lines;

  /// The paying business, when they paid from a HAAT wallet.
  final String? payerName;
  final DateTime paidAt;

  static SaleOrder fromData(Map<String, dynamic> data) {
    BigInt minor(Object? value) =>
        BigInt.tryParse('${value ?? 0}') ?? BigInt.zero;
    String? text(Object? value) {
      final s = '${value ?? ''}'.trim();
      return s.isEmpty || s == 'null' ? null : s;
    }

    return SaleOrder(
      id: '${data['id'] ?? ''}',
      code: '${data['code'] ?? ''}',
      channel: text(data['channel']),
      currency: text(data['currency']) ?? 'SDG',
      amountMinor: minor(data['amountMinor']),
      lines: (data['lines'] is List ? data['lines'] as List : const [])
          .whereType<Map<String, dynamic>>()
          .map((l) => OrderLine(
                description: '${l['description'] ?? ''}',
                quantity: int.tryParse('${l['quantity']}') ?? 1,
                amountMinor: minor(l['amountMinor']),
                productId: text(l['productId']),
              ))
          .toList(),
      payerName: text(data['payerName']),
      paidAt: DateTime.tryParse('${data['paidAt']}')?.toLocal() ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  /// Whether one of [products] — the business's own, `isMine` — is in this order. A
  /// line from before lines named their product is matched by its name.
  bool sells(List<Map<String, dynamic>> products) {
    final ids = {for (final p in products) '${p['id']}'.toLowerCase()};
    final names = {
      for (final p in products) '${p['name'] ?? ''}'.trim().toLowerCase()
    };
    return lines.any((line) => line.productId != null
        ? ids.contains(line.productId!.toLowerCase())
        : names.contains(line.description.trim().toLowerCase()));
  }

  /// What the Orders page binds to.
  Map<String, dynamic> toJson(DateTime now) {
    String money(BigInt value) {
      final (whole, fraction) = splitMinor(value, currency);
      return '$whole${fraction == '.00' ? '' : fraction} $currency';
    }

    final items = lines.fold<int>(0, (sum, l) => sum + l.quantity);
    final first = lines.isEmpty ? '' : lines.first.description;
    final how = switch (channel) {
      'nfc' => 'Tap to pay',
      'link' => 'Payment link',
      'invoice' => 'Invoice',
      _ => 'QR code',
    };

    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(paidAt.year, paidAt.month, paidAt.day);
    final time = DateFormat('h:mm a').format(paidAt);
    final when = day == today
        ? 'Today, $time'
        : day == today.subtract(const Duration(days: 1))
            ? 'Yesterday, $time'
            : paidAt.year == now.year
                ? DateFormat('d MMM, h:mm a').format(paidAt)
                : DateFormat('d MMM yyyy').format(paidAt);

    return {
      'id': id,
      'code': code,
      'title': lines.length <= 1 ? first : '$first + ${lines.length - 1} more',
      'items': '$items ${items == 1 ? 'item' : 'items'}',
      'amount': money(amountMinor),
      'channel': channel ?? 'qr',
      'paidBy': payerName == null ? how : '$how · $payerName',
      'when': when,
      'lines': [
        for (final l in lines)
          {
            'name': l.description,
            'quantity': '×${l.quantity}',
            'amount': money(l.amountMinor),
          }
      ],
    };
  }
}

class OrdersApi {
  OrdersApi(this._client);

  final ApiClient _client;

  /// The business's orders with one of its own products in them, newest first; null
  /// when the server could not be reached or refused.
  Future<List<SaleOrder>?> mine({int limit = 100}) async {
    final orders = await _client.get<List<SaleOrder>>(
      '/business/orders',
      query: {'limit': '$limit'},
      parse: (envelope) {
        final data = envelope.data;
        return (data is List ? data : const [])
            .whereType<Map<String, dynamic>>()
            .map(SaleOrder.fromData)
            .toList();
      },
    );
    final all = orders.valueOrNull;
    if (all == null) return null;

    final products = await _client.get<List<Map<String, dynamic>>>(
      '/products',
      parse: (envelope) {
        final data = envelope.data;
        return (data is List ? data : const [])
            .whereType<Map<String, dynamic>>()
            .where((p) => p['isMine'] == true)
            .toList();
      },
    );
    final mine = products.valueOrNull;
    // Without the catalogue there is no telling whose product sold; show every order
    // rather than none.
    if (mine == null) return all;
    return all.where((order) => order.sells(mine)).toList();
  }
}
