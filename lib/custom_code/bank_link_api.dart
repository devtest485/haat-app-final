import '/custom_code/api_client.dart';
import '/custom_code/api_result.dart';

/// Where the code was sent, after asking to link an account.
class BankLinkChallenge {
  const BankLinkChallenge({
    required this.institutionName,
    required this.mobileMasked,
    required this.devOtpCode,
  });

  final String institutionName;

  /// The phone the bank has on file, with all but the last four digits hidden.
  final String mobileMasked;

  /// The code itself, while no SMS provider delivers it. Empty where one does.
  final String devOtpCode;

  static BankLinkChallenge fromData(Map<String, dynamic> data) {
    String text(Object? value) {
      final s = '${value ?? ''}'.trim();
      return s == 'null' ? '' : s;
    }

    return BankLinkChallenge(
      institutionName: text(data['institutionName']),
      mobileMasked: text(data['mobileMasked']),
      devOtpCode: text(data['devOtpCode']),
    );
  }
}

/// What the bank holds for the person, shown back to be confirmed.
class BankLinkDetails {
  const BankLinkDetails({
    required this.institutionName,
    required this.holderName,
    required this.idMasked,
    required this.mobileMasked,
    required this.accountMasked,
    required this.businessName,
  });

  final String institutionName;
  final String holderName;
  final String idMasked;
  final String mobileMasked;
  final String accountMasked;
  final String businessName;

  static BankLinkDetails fromData(Map<String, dynamic> data) {
    String text(Object? value) {
      final s = '${value ?? ''}'.trim();
      return s == 'null' ? '' : s;
    }

    return BankLinkDetails(
      institutionName: text(data['institutionName']),
      holderName: text(data['holderName']),
      idMasked: text(data['idMasked']),
      mobileMasked: text(data['mobileMasked']),
      accountMasked: text(data['accountMasked']),
      businessName: text(data['businessName']),
    );
  }

  Map<String, dynamic> toJson() => {
        'institutionName': institutionName,
        'holderName': holderName,
        'idMasked': idMasked.isEmpty ? '—' : idMasked,
        'mobileMasked': mobileMasked,
        'accountMasked': accountMasked,
        'businessName': businessName,
      };
}

/// A bank account the business has linked.
class LinkedBank {
  const LinkedBank({
    required this.id,
    required this.institutionCode,
    required this.institutionName,
    required this.accountNumber,
    required this.holderName,
    required this.currency,
  });

  final String id;
  final String institutionCode;
  final String institutionName;
  final String accountNumber;
  final String holderName;
  final String currency;

  /// `216937501527` as `2169 3750 1527`, the way a bank prints it.
  String get displayNumber => accountNumber.replaceAllMapped(
      RegExp(r'(\d{4})(?=\d)'), (match) => '${match[1]} ');

  /// What the bank is called on a screen: its short name, SIB, rather than its legal one.
  String get label => institutionCode.isEmpty ? institutionName : institutionCode;

  static LinkedBank fromData(Map<String, dynamic> data) {
    String text(Object? value) {
      final s = '${value ?? ''}'.trim();
      return s == 'null' ? '' : s;
    }

    return LinkedBank(
      id: text(data['id']),
      institutionCode: text(data['institutionCode']),
      institutionName: text(data['institutionName']),
      accountNumber: text(data['accountNumber']),
      holderName: text(data['holderName']),
      currency: text(data['currency']).isEmpty ? 'SDG' : text(data['currency']),
    );
  }
}

/// Linking the business's account at a partner bank: `/bank-links`.
///
/// Three steps, one per screen. Ask — the bank sends a code to the phone it has on file.
/// Verify — the code is checked and what the bank holds comes back to be confirmed.
/// Confirm — the account is linked, and shows under the wallet number from then on.
class BankLinkApi {
  BankLinkApi(this._client);

  final ApiClient _client;

  Future<ApiResult<BankLinkChallenge>> request(String number, String mobile) =>
      _client.post<BankLinkChallenge>(
        '/bank-links/request',
        body: {'number': number, 'mobile': mobile},
        parse: (envelope) => BankLinkChallenge.fromData(envelope.object),
      );

  Future<ApiResult<BankLinkDetails>> verify(
    String number,
    String mobile,
    String code,
  ) =>
      _client.post<BankLinkDetails>(
        '/bank-links/verify',
        body: {'number': number, 'mobile': mobile, 'code': code},
        parse: (envelope) => BankLinkDetails.fromData(envelope.object),
      );

  Future<ApiResult<LinkedBank>> confirm(String number, String mobile) =>
      _client.post<LinkedBank>(
        '/bank-links/confirm',
        body: {'number': number, 'mobile': mobile},
        parse: (envelope) => LinkedBank.fromData(envelope.object),
      );

  /// The accounts linked so far; null when the server could not be reached or refused.
  Future<List<LinkedBank>?> linked() async {
    final result = await _client.get<List<LinkedBank>>(
      '/bank-links',
      parse: (envelope) => envelope.list
          .whereType<Map<String, dynamic>>()
          .map(LinkedBank.fromData)
          .toList(),
    );

    return result.valueOrNull;
  }
}
