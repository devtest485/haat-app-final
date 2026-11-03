/// What the cashier is charging for: the cart's products, kept from the moment a sale
/// is charged from the cart until the QR, link or tap for it is made.
///
/// Sent with the request as its lines, each with the product it is, so the business's
/// Orders know what sold and whose product it was. Charged from the keypad, there is no
/// cart and the request goes without lines, as before.
class SaleCart {
  SaleCart._();

  static List<Map<String, dynamic>> _lines = const [];

  /// The cart being charged; null or empty for a sale typed on the keypad.
  static void set(List<dynamic>? cart) {
    _lines = [
      for (final line in cart ?? const [])
        if (line is Map)
          {
            'description': '${line['name'] ?? ''}'.trim(),
            'quantity': int.tryParse('${line['qty']}') ?? 0,
            'unitAmountMinor': '${line['priceMinor'] ?? ''}'.trim(),
            'productId': '${line['id'] ?? ''}'.trim(),
          },
    ];
  }

  /// The lines for a request of [amountMinor], or null when there are none or they are
  /// not exactly that sale — the server refuses lines that do not add up, and a request
  /// for something else must not name these products.
  static List<Map<String, dynamic>>? linesFor(BigInt amountMinor) {
    if (_lines.isEmpty || _lines.length > 50) return null;
    var total = BigInt.zero;
    final lines = <Map<String, dynamic>>[];
    for (final line in _lines) {
      final description = line['description'] as String;
      final quantity = line['quantity'] as int;
      final unit = line['unitAmountMinor'] as String;
      final productId = line['productId'] as String;
      if (description.isEmpty ||
          quantity < 1 ||
          quantity > 100000 ||
          !RegExp(r'^[1-9][0-9]{0,15}$').hasMatch(unit)) {
        return null;
      }
      total += BigInt.parse(unit) * BigInt.from(quantity);
      lines.add({
        'description': description.length > 120
            ? description.substring(0, 120)
            : description,
        'quantity': quantity,
        'unitAmountMinor': unit,
        if (productId.length == 36) 'productId': productId,
      });
    }
    return total == amountMinor ? lines : null;
  }
}
