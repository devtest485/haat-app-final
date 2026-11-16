import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haat/custom_code/access_api.dart';
import 'package:haat/custom_code/api_client.dart';
import 'package:haat/custom_code/token_store.dart';
import 'package:haat/flutter_flow/custom_functions.dart' as functions;
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

AccessApi apiAnswering(int status, Map<String, dynamic> body, {void Function(http.Request)? seen}) {
  FlutterSecureStorage.setMockInitialValues({});
  final client = ApiClient(
    tokens: TokenStore(),
    baseUrl: 'http://stub.test/api/v1',
    inner: MockClient((request) async {
      seen?.call(request);
      return http.Response(jsonEncode(body), status, headers: {'content-type': 'application/json'});
    }),
  );
  return AccessApi(client);
}

Map<String, dynamic> envelope(dynamic data, {bool ok = true}) => {
      'isSuccess': ok,
      'title': 't',
      'titleAr': 't',
      'message': 'm',
      'messageAr': 'm',
      'data': data,
      'responseCode': ok ? 200 : 403,
    };

void main() {
  group('AccessApi.mine', () {
    test('reads the permission keys of a cashier', () async {
      http.Request? sent;
      final api = apiAnswering(
        200,
        envelope({
          'permissions': ['payment:create', 'payment:read', 'qr_code:create'],
          'scope': 'branch',
        }),
        seen: (r) => sent = r,
      );

      final result = await api.mine();

      expect(result.isSuccess, isTrue);
      expect(result.valueOrNull, ['payment:create', 'payment:read', 'qr_code:create']);
      expect(sent?.url.path, '/api/v1/rbac/me');
    });

    test('a personal account has none', () async {
      final api = apiAnswering(200, envelope({'permissions': [], 'scope': 'own'}));
      expect((await api.mine()).valueOrNull, isEmpty);
    });

    test('a refusal is not a list of permissions', () async {
      final api = apiAnswering(403, envelope(null, ok: false));
      final result = await api.mine();
      expect(result.isSuccess, isFalse);
      expect(result.valueOrNull, isNull);
    });
  });

  group('canDo', () {
    const cashier = ['payment:create', 'payment:read', 'payment_link:create', 'product:read'];

    test('shows what the role has', () {
      expect(functions.canDo(cashier, 'payment:create'), isTrue);
      expect(functions.canDo(cashier, 'payment_link:create'), isTrue);
    });

    test('hides what the role lacks', () {
      expect(functions.canDo(cashier, 'payout:create'), isFalse);
      expect(functions.canDo(cashier, 'staff:read'), isFalse);
      expect(functions.canDo(cashier, 'product:update'), isFalse);
      expect(functions.canDo(cashier, 'product:create'), isFalse);
    });

    // Not read yet, or an account with no role: nothing is hidden.
    test('hides nothing when access is unknown', () {
      expect(functions.canDo(null, 'payout:create'), isTrue);
      expect(functions.canDo(const [], 'payout:create'), isTrue);
    });
  });
}
