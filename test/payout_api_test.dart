import 'package:flutter_test/flutter_test.dart';
import 'package:haat/custom_code/payout_api.dart';

void main() {
  group('toMinor', () {
    test('joins pounds and piastres as digits', () {
      expect(toMinor('740.50', 'SDG'), BigInt.from(74050));
      expect(toMinor('740.5', 'SDG'), BigInt.from(74050));
      expect(toMinor('1,250', 'SDG'), BigInt.from(125000));
      expect(toMinor('0.1', 'SDG'), BigInt.from(10));
    });

    // Rounding a third decimal away would send an amount nobody typed.
    test('refuses more places than the currency has', () {
      expect(toMinor('1.005', 'SDG'), isNull);
      expect(toMinor('1.005', 'LYD'), BigInt.from(1005));
    });

    test('refuses nothing, and what is not a number', () {
      expect(toMinor('0', 'SDG'), isNull);
      expect(toMinor('0.00', 'SDG'), isNull);
      expect(toMinor('', 'SDG'), isNull);
      expect(toMinor('-5', 'SDG'), isNull);
      expect(toMinor('abc', 'SDG'), isNull);
    });
  });

  group('Payout.fromData', () {
    test('reads the platform’s payout, amounts as exact integers', () {
      final payout = Payout.fromData({
        'id': 'p1',
        'currency': 'SDG',
        'amountMinor': '300000',
        'feeMinor': '500',
        'totalMinor': '300500',
        'destination': {
          'bankName': 'Bank of Khartoum',
          'accountName': 'Amna Fabrics',
          'accountNumber': '001234567890',
        },
        'status': 'paid',
        'bankReference': 'TRF-1',
        'requestedAt': '2026-09-26T12:38:00.000Z',
      });

      expect(payout.totalMinor, BigInt.from(300500));
      expect(payout.status, PayoutStatus.paid);
      expect(payout.status.label, 'Sent');
      expect(payout.maskedAccount, '••7890');
      expect(payout.bankReference, 'TRF-1');
    });

    test('reads an unknown status as waiting rather than failing', () {
      expect(Payout.fromData({'status': 'something_new'}).status,
          PayoutStatus.requested);
    });
  });
}
