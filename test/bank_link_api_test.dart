import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haat/custom_code/api_client.dart';
import 'package:haat/custom_code/bank_link_api.dart';
import 'package:haat/custom_code/phone_format.dart';
import 'package:haat/custom_code/token_store.dart';
import 'package:haat/flutter_flow/custom_functions.dart' as functions;
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

BankLinkApi apiAnswering(
  int status,
  Object? data, {
  bool ok = true,
  String? errorCode,
  void Function(http.Request)? seen,
}) {
  FlutterSecureStorage.setMockInitialValues({});
  final client = ApiClient(
    tokens: TokenStore(),
    baseUrl: 'http://stub.test/api/v1',
    inner: MockClient((request) async {
      seen?.call(request);
      return http.Response(
        jsonEncode({
          'isSuccess': ok,
          'title': 't',
          'title_ar': 't',
          'message': 'm',
          'message_ar': 'm',
          'data': data,
          'responseCode': status,
          if (errorCode != null) 'errorCode': errorCode,
        }),
        status,
        headers: {'content-type': 'application/json'},
      );
    }),
  );

  return BankLinkApi(client);
}

void main() {
  group('linking a bank account', () {
    test('asking for a code sends the number and phone, and reads where it went',
        () async {
      http.Request? sent;
      final api = apiAnswering(
        200,
        {
          'institutionName': 'Sudanese Islamic Bank',
          'mobileMasked': '*********0910',
          'expiresAt': '2026-11-19T11:14:30.719Z',
          'devOtpCode': '804528',
        },
        seen: (request) => sent = request,
      );

      final result = await api.request('84537779', '+249912090910');
      final challenge = result.valueOrNull!;

      expect(sent!.url.path, endsWith('/bank-links/request'));
      expect(jsonDecode(sent!.body),
          {'number': '84537779', 'mobile': '+249912090910'});
      expect(challenge.mobileMasked, '*********0910');
      expect(challenge.devOtpCode, '804528');
    });

    test('a code the server does not hand back reads as empty', () async {
      final api = apiAnswering(200, {
        'institutionName': 'SIB',
        'mobileMasked': '*********0910',
        'devOtpCode': null,
      });

      expect((await api.request('84537779', '+249912090910')).valueOrNull!.devOtpCode,
          '');
    });

    test('an account that is not this business\'s is a refusal with a code to branch on',
        () async {
      final api = apiAnswering(404, {}, ok: false, errorCode: 'NOT_FOUND');
      final result = await api.request('11111111', '+249912090910');

      expect(result.valueOrNull, isNull);
      expect(result.errorCode, 'NOT_FOUND');
    });

    test('verifying carries the code and keeps what the bank holds', () async {
      http.Request? sent;
      final api = apiAnswering(
        200,
        {
          'institutionName': 'Sudanese Islamic Bank',
          'holderName': 'Mohammed Alamin',
          'idMasked': '···· 4471',
          'mobileMasked': '*********0910',
          'accountMasked': '···· 1527',
          'businessName': 'Lipper Pizza',
        },
        seen: (request) => sent = request,
      );

      final details =
          (await api.verify('84537779', '+249912090910', '482601')).valueOrNull!;

      expect(jsonDecode(sent!.body)['code'], '482601');
      expect(details.holderName, 'Mohammed Alamin');
      expect(details.toJson()['businessName'], 'Lipper Pizza');
      expect(details.toJson()['idMasked'], '···· 4471');
    });

    test('several accounts under one customer number are offered to choose from', () async {
      final api = apiAnswering(200, {
        'institutionName': 'SIB',
        'holderName': 'Mohammed Alamin',
        'idMasked': null,
        'mobileMasked': '*********0910',
        'accountMasked': '···· 7812',
        'businessName': 'Lipper Pizza',
        'accounts': [
          {'id': 'a1', 'accountType': 'current', 'accountMasked': '···· 7812'},
          {'id': 'a2', 'accountType': 'savings', 'accountMasked': '···· 4410'},
          {'id': 'a3', 'accountType': 'business', 'accountMasked': '···· 0935'},
        ],
      });

      final details =
          (await api.verify('84537779', '+249912090910', '482601')).valueOrNull!;

      expect(details.accounts.map((a) => a.label),
          ['Current account', 'Savings account', 'Business account']);
      expect(details.accounts[1].id, 'a2');
      expect(details.accounts[2].accountMasked, '···· 0935');
    });

    test('confirming names the account chosen', () async {
      http.Request? sent;
      final api = apiAnswering(
        200,
        {
          'id': 'a2',
          'institutionCode': 'SIB',
          'institutionName': 'Sudanese Islamic Bank',
          'accountNumber': '197083536098',
          'accountType': 'savings',
          'holderName': 'Mohammed Alamin',
          'currency': 'SDG',
        },
        seen: (request) => sent = request,
      );

      final linked =
          (await api.confirm('84537779', '+249912090910', accountId: 'a2')).valueOrNull!;

      expect(jsonDecode(sent!.body)['accountId'], 'a2');
      expect(linked.accountType, 'savings');
      expect(accountTypeLabel(linked.accountType), 'Savings account');
    });

    test('an account without an identity number shows a dash, not nothing', () {
      final details = BankLinkDetails.fromData({
        'holderName': 'A',
        'idMasked': null,
        'mobileMasked': '*********0910',
        'accountMasked': '···· 1527',
      });

      expect(details.toJson()['idMasked'], '—');
    });

    test('the linked accounts are listed with the number spaced as a bank prints it',
        () async {
      final api = apiAnswering(200, [
        {
          'id': 'abc',
          'institutionCode': 'SIB',
          'institutionName': 'Sudanese Islamic Bank',
          'accountNumber': '216937501527',
          'holderName': 'Mohammed Alamin',
          'currency': 'SDG',
          'linkedAt': '2026-11-19T11:09:30.790Z',
        }
      ]);

      final linked = (await api.linked())!;

      expect(linked, hasLength(1));
      expect(linked.first.displayNumber, '2169 3750 1527');
      expect(linked.first.label, 'SIB');
    });

    test('nothing linked is an empty list, not a failure', () async {
      expect(await apiAnswering(200, []).linked(), isEmpty);
    });
  });

  group('the sign-up phone number', () {
    test('is Pakistan\'s until another country is chosen', () {
      expect(functions.signupCountryField(null, 'dialCode'), '92');
      expect(functions.signupCountryField(null, 'flag'), '🇵🇰');
      expect(PhoneFormat.dialCode, '+92');
      expect(PhoneFormat.toE164('0300 1234567'), '+923001234567');
    });

    test('takes the country that was chosen', () {
      const sudan = {'iso': 'SD', 'dialCode': '249', 'flag': '🇸🇩'};

      expect(functions.signupCountryField(sudan, 'dialCode'), '249');
      expect(functions.signupPhoneComplete('912090910', sudan), isTrue);
      expect(functions.signupPhoneComplete('0912090910', sudan), isTrue);
      expect(functions.signupPhoneComplete('91209', sudan), isFalse);
    });

    test('is ten digits for Pakistan, as it always was', () {
      expect(functions.signupPhoneComplete('3001234567', null), isTrue);
      expect(functions.signupPhoneComplete('300123456', null), isFalse);
      expect(functions.signupPhoneComplete('30012345678', null), isFalse);
    });
  });

  group('sending to a BBAN', () {
    test('the page mode names how the person is looked up', () {
      expect(functions.transferBy('BBAN'), 'bban');
      expect(functions.transferBy('UserName'), 'username');
      expect(functions.transferBy('PhoneNumber'), 'mobile');
    });

    test('a BBAN is sent as its fourteen digits, however it was typed', () {
      for (final typed in ['09012345678901', '090 123456789 01', ' 090-123456789-01 ']) {
        expect(functions.transferValue('BBAN', typed, '+249'), '09012345678901');
      }
    });

    test('only fourteen digits are worth asking the server about', () {
      expect(functions.transferValueComplete('BBAN', '090 123456789 0', '+249'),
          isFalse);
      expect(functions.transferValueComplete('BBAN', '090 123456789 01', '+249'),
          isTrue);
      expect(functions.transferValueComplete('BBAN', '090 123456789 012', '+249'),
          isFalse);
    });

    test('the review shows the number as it is printed', () {
      expect(
        functions.transferVia('BBAN', {'name': 'Amna'}, '09012345678901'),
        '090 123456789 01',
      );
    });

    test('nobody found says what to do next', () {
      expect(
        functions.transferLookupError('BBAN', 404, 'NOT_FOUND', 'x'),
        'We couldn’t find an account with this BBAN. Check the number and try again.',
      );
      expect(functions.transferLookupError('UserName', 404, 'NOT_FOUND', 'x'),
          'This username doesn’t exist.');
    });
  });
}
