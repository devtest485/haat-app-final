import 'package:flutter_test/flutter_test.dart';
import 'package:haat/custom_code/wallet_api.dart';

void main() {
  group('splitMinor', () {
    test('splits Sudanese pounds into whole and piastres', () {
      expect(splitMinor(BigInt.from(1230050), 'SDG'), ('12,300', '.50'));
      expect(splitMinor(BigInt.zero, 'SDG'), ('0', '.00'));
      expect(splitMinor(BigInt.from(5), 'SDG'), ('0', '.05'));
    });

    // Two places here would show a Libyan balance ten times too large.
    test('reads the dinars to three places', () {
      expect(splitMinor(BigInt.from(12500), 'LYD'), ('12', '.500'));
    });

    test('stays exact past what a double holds', () {
      expect(
        splitMinor(BigInt.parse('123456789012345678901'), 'SDG'),
        ('1,234,567,890,123,456,789', '.01'),
      );
    });

    test('keeps the sign of an overdrawn balance', () {
      expect(splitMinor(BigInt.from(-150), 'SDG'), ('-1', '.50'));
    });
  });

  group('Wallet.available', () {
    WalletLine line(String code, String currency, int available) => WalletLine(
          institutionCode: code,
          institutionName: code,
          currency: currency,
          availableMinor: BigInt.from(available),
          pendingMinor: BigInt.from(999),
          heldMinor: BigInt.from(999),
          reserveMinor: BigInt.from(999),
        );

    test('sums what can be spent across banks, and nothing else', () {
      final wallet = Wallet([line('SIB', 'SDG', 1000), line('WMBB', 'SDG', 250)]);
      expect(wallet.available, BigInt.from(1250));
    });

    test('does not add a second currency to the first', () {
      final wallet = Wallet([line('SIB', 'SDG', 1000), line('SIB', 'USD', 5)]);
      expect(wallet.currency, 'SDG');
      expect(wallet.available, BigInt.from(1000));
    });

    test('is zero in SDG before any wallet opens', () {
      expect(const Wallet([]).available, BigInt.zero);
      expect(const Wallet([]).currency, 'SDG');
    });
  });
}
