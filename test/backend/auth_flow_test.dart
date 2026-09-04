import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:haat/backend/api/api_client.dart';
import 'package:haat/backend/api/api_envelope.dart';
import 'package:haat/backend/api/api_result.dart';
import 'package:haat/backend/api/auth_api.dart';
import 'package:haat/backend/auth/device_identity.dart';
import 'package:haat/backend/auth/token_store.dart';

/// Walks the sign-up and sign-in flows against a real backend.
///
/// The point is the contract. Most of this app can be checked by reading it, but "does
/// the field the screen reads exist in the response" cannot — and getting that wrong
/// produces a screen that looks right and shows nothing. So these talk to a running
/// gateway: a mock would only prove the app agrees with itself.
///
/// **They need the backend up.** From the API repository:
///
/// ```
/// npm run db:dev                      # then, in other terminals:
/// npm run start:identity-service
/// npm run start:dev
/// ```
///
/// With nothing listening every test fails with that instruction, which is the honest
/// outcome for an integration test — a silent skip would report green for a suite that
/// checked nothing.
void main() {
  // `flutter test` has no platform channels, so the keystore is unavailable. TokenStore
  // is written to degrade to memory rather than throw, and these tests lean on that —
  // which incidentally proves the degradation works.
  TestWidgetsFlutterBinding.ensureInitialized();

  // The widget-test harness installs an HttpOverrides that answers every request with
  // an empty 400, so that an ordinary test cannot reach the network by accident.
  // Reaching it is the entire point here, so it is removed.
  HttpOverrides.global = null;

  const base = 'http://localhost:3000/api/v1';

  late TokenStore tokens;
  late ApiClient client;
  late AuthApi api;

  setUpAll(() async {
    if (await _reachable(base)) return;

    fail(
      'No HAAT backend at $base.\n'
      'Start it first: npm run db:dev, then the identity service and the gateway.',
    );
  });

  setUp(() async {
    tokens = TokenStore();
    // Pinned to `base` rather than taken from ApiConfig.
    //
    // The app's configured URL is the deployed API now, and these tests register
    // accounts, set passwords and open sessions. Letting them inherit that would mean
    // `flutter test` quietly filling the real server with test merchants.
    client = ApiClient(tokens: tokens, baseUrl: base);
    api = AuthApi(client, DeviceIdentity(tokens));
  });

  tearDown(() => client.close());

  /// A number nobody else in this run will use.
  String freshMobile() {
    final stamp = DateTime.now().microsecondsSinceEpoch.toString();

    return '+24991${stamp.substring(stamp.length - 7)}';
  }

  String freshHandle(String prefix) =>
      '$prefix${DateTime.now().microsecondsSinceEpoch % 100000000}';

  /// Registers, verifies, and adopts the session — the state most tests start from.
  Future<AuthTokens> signedUp(String mobile) async {
    final started = await api.register(mobile: mobile, fullName: 'Flow Test');
    expect(started, isA<ApiSuccess<RegistrationStarted>>(),
        reason: 'register failed: ${started.messageIn('en')}');

    final code = started.valueOrNull!.devOtpCode;
    expect(code, isNotNull,
        reason: 'a development backend returns the code so tests can use it');

    final verified = await api.verifyOtp(mobile: mobile, code: code!);
    expect(verified, isA<ApiSuccess<AuthTokens>>(),
        reason: 'verify failed: ${verified.messageIn('en')}');

    final issued = verified.valueOrNull!;
    await tokens.save(
      accessToken: issued.accessToken,
      refreshToken: issued.refreshToken,
      userId: issued.userId,
    );

    return issued;
  }

  group('the envelope', () {
    test('a refusal carries both languages, a code and a request id', () async {
      final result = await api.register(mobile: 'nonsense', fullName: 'X');

      // The failure path on purpose: that is where the app shows text it did not write.
      expect(result, isA<ApiFailure<RegistrationStarted>>());

      final envelope = (result as ApiFailure<RegistrationStarted>).envelope;
      expect(envelope.isSuccess, isFalse);
      expect(envelope.title, isNotEmpty);
      expect(envelope.titleAr, isNotEmpty, reason: 'Arabic title missing');
      expect(envelope.message, isNotEmpty);
      expect(envelope.messageAr, isNotEmpty, reason: 'Arabic message missing');
      expect(envelope.errorCode, ApiErrorCode.validationFailed);
      expect(envelope.requestId, isNotNull);
      expect(envelope.responseCode, 400);
    });

    test('the Arabic text differs from the English', () async {
      final result = await api.register(mobile: 'nonsense');

      expect(result.messageIn('ar'), isNotEmpty);
      expect(result.messageIn('ar'), isNot(result.messageIn('en')));
      expect(result.titleIn('ar'), isNot(result.titleIn('en')));
    });
  });

  group('signing up', () {
    test('runs from a phone number to a claimed handle', () async {
      final mobile = freshMobile();
      final issued = await signedUp(mobile);

      expect(issued.accessToken, isNotEmpty);
      expect(issued.refreshToken, isNotEmpty);
      expect(issued.deviceId, isNotEmpty,
          reason: 'the session list needs a device to group by');

      final before = await api.credentialStatus();
      expect(before, isA<ApiSuccess<CredentialStatus>>());
      expect(before.valueOrNull!.hasPassword, isFalse);
      expect(before.valueOrNull!.mobileVerified, isTrue);

      final password = await api.setPassword(password: 'Str0ng!Passw0rd');
      expect(password, isA<ApiSuccess<DateTime?>>(),
          reason: 'setPassword failed: ${password.messageIn('en')}');

      final passcode = await api.setPasscode(passcode: '194837');
      expect(passcode, isA<ApiSuccess<DateTime?>>(),
          reason: 'setPasscode failed: ${passcode.messageIn('en')}');

      final handle = freshHandle('flow');

      final check = await api.checkUsername(handle);
      expect(check, isA<ApiSuccess<UsernameCheck>>());
      expect(check.valueOrNull!.available, isTrue);
      expect(check.valueOrNull!.unmet, isEmpty);

      final claimed = await api.claimUsername(handle);
      expect(claimed, isA<ApiSuccess<String>>(),
          reason: 'claimUsername failed: ${claimed.messageIn('en')}');

      // What the app reads to decide whether onboarding is done.
      final after = await api.credentialStatus();
      expect(after.valueOrNull!.hasPassword, isTrue);
      expect(after.valueOrNull!.hasPasscode, isTrue);
      expect(after.valueOrNull!.username, handle);
    });

    test('a weak password is refused, and says which rules it broke', () async {
      await signedUp(freshMobile());

      final result = await api.setPassword(password: 'password');

      expect(result, isA<ApiFailure<DateTime?>>());
      expect(result.errorCode, ApiErrorCode.validationFailed);
      // The app's own validatePassword mirrors these rules. If the two ever drift, a
      // client that agreed with itself but not the server would refuse a password the
      // server would have taken, or show this failure to somebody who did nothing
      // wrong — so the field names are part of the contract.
      expect((result as ApiFailure<DateTime?>).data['unmet'], isNotNull);
    });

    test('a wrong code does not open a session', () async {
      final mobile = freshMobile();
      await api.register(mobile: mobile);

      final result = await api.verifyOtp(mobile: mobile, code: '000000');

      expect(result, isA<ApiFailure<AuthTokens>>());
      expect(result.valueOrNull, isNull);
    });

    test('a taken handle answers "unavailable" rather than failing', () async {
      await signedUp(freshMobile());

      final handle = freshHandle('dup');
      await api.claimUsername(handle);

      final check = await api.checkUsername(handle);

      expect(check, isA<ApiSuccess<UsernameCheck>>(),
          reason: 'a taken handle is a successful answer, not an error');
      expect(check.valueOrNull!.available, isFalse);
    });

    test('a malformed handle names the rule instead of just refusing', () async {
      await signedUp(freshMobile());

      // Starts with a digit, which the backend's format rules reject. The screen turns
      // `unmet` into a sentence, so it has to arrive.
      final check = await api.checkUsername('9nope');

      expect(check, isA<ApiSuccess<UsernameCheck>>());
      expect(check.valueOrNull!.available, isFalse);
      expect(check.valueOrNull!.unmet, isNotEmpty);
    });
  });

  group('signing in', () {
    test('works with the phone number, and with the handle', () async {
      final mobile = freshMobile();
      const password = 'An0ther!Passw0rd';
      final handle = freshHandle('both');

      final issued = await signedUp(mobile);
      await api.setPassword(password: password);
      await api.claimUsername(handle);

      // Both, because the app offers both: a merchant has a number, an
      // employer-created account has only a handle.
      final byMobile = await api.signIn(mobile: mobile, password: password);
      expect(byMobile, isA<ApiSuccess<AuthTokens>>(),
          reason: 'phone sign-in failed: ${byMobile.messageIn('en')}');

      final byHandle = await api.signIn(username: handle, password: password);
      expect(byHandle, isA<ApiSuccess<AuthTokens>>(),
          reason: 'handle sign-in failed: ${byHandle.messageIn('en')}');

      expect(byHandle.valueOrNull!.userId, issued.userId);
      expect(byMobile.valueOrNull!.userId, issued.userId);
    });

    test('a wrong password and an unknown number give the same answer', () async {
      final mobile = freshMobile();
      await signedUp(mobile);
      await api.setPassword(password: 'Correct!Passw0rd');

      final wrongPassword =
          await api.signIn(mobile: mobile, password: 'Wrong!Passw0rd');
      final unknownNumber =
          await api.signIn(mobile: freshMobile(), password: 'Wrong!Passw0rd');

      expect(wrongPassword, isA<ApiFailure<AuthTokens>>());
      expect(unknownNumber, isA<ApiFailure<AuthTokens>>());

      // The property that matters. Telling them apart would turn sign-in into a way to
      // ask which numbers are registered, so the app must not rely on the difference
      // either.
      expect(wrongPassword.messageIn('en'), unknownNumber.messageIn('en'));
      expect(wrongPassword.errorCode, unknownNumber.errorCode);
    });

    test('sending two identifiers is refused rather than resolved', () async {
      final result = await client.post<AuthTokens>(
        '/auth/sign-in',
        authenticated: false,
        body: {
          'mobile': '+249911234567',
          'username': 'someone',
          'password': 'Whatever!1',
        },
        parse: (envelope) => AuthTokens.fromData(envelope.object),
      );

      // The app picks one before sending; this checks the backend does not quietly
      // choose for a client that gets it wrong.
      expect(result, isA<ApiFailure<AuthTokens>>());
    });
  });

  group('the client', () {
    test('refreshes an expired access token and retries once', () async {
      final issued = await signedUp(freshMobile());

      // A token the server will reject, beside the real refresh token. This is the
      // state the app is in on most launches — closed for longer than an access token
      // lives.
      await tokens.save(
        accessToken: 'not.a.valid.token',
        refreshToken: issued.refreshToken,
        userId: issued.userId,
      );

      final result = await api.credentialStatus();

      expect(result, isA<ApiSuccess<CredentialStatus>>(),
          reason: 'the client should refresh and retry without the screen knowing');
      expect(tokens.accessToken, isNot('not.a.valid.token'));
      // Rotated on use, so the stored pair must have been replaced or the next refresh
      // presents a token that has already been spent.
      expect(tokens.refreshToken, isNot(issued.refreshToken));
    });

    test('runs one refresh for several calls that fail together', () async {
      final issued = await signedUp(freshMobile());

      // Counted rather than inferred from whether the calls succeeded. The development
      // database is PGlite, which serves one connection at a time, so three
      // simultaneous reads can fail for reasons that have nothing to do with
      // refreshing — and a test that could not tell the two apart would be measuring
      // the database.
      final counting = _CountingClient();
      final counted = ApiClient(tokens: tokens, inner: counting, baseUrl: base);
      addTearDown(counted.close);
      final countedApi = AuthApi(counted, DeviceIdentity(tokens));

      await tokens.save(
        accessToken: 'not.a.valid.token',
        refreshToken: issued.refreshToken,
        userId: issued.userId,
      );

      // Three at once. Without the single-flight guard each fires its own refresh, and
      // because the backend rotates the token on use, two would present one already
      // spent — signing the user out via the very mechanism meant to keep them in.
      await Future.wait([
        countedApi.credentialStatus(),
        countedApi.credentialStatus(),
        countedApi.credentialStatus(),
      ]);

      expect(counting.refreshCalls, 1,
          reason: 'three calls, one refresh — anything more races itself');
      expect(tokens.refreshToken, isNot(issued.refreshToken),
          reason: 'the rotated token has to be the one that was kept');
    });

    test('a revoked session is not retried forever', () async {
      final issued = await signedUp(freshMobile());

      await tokens.save(
        accessToken: 'not.a.valid.token',
        refreshToken: 'not.a.valid.refresh.token',
        userId: issued.userId,
      );

      var expired = false;
      client.onSessionExpired = () => expired = true;

      final result = await api.credentialStatus();

      expect(result, isA<ApiFailure<CredentialStatus>>());
      expect(expired, isTrue,
          reason: 'the session is gone, and the app has to be told so it can '
              'send the user to sign in rather than failing every call');
      expect(tokens.hasSession, isFalse, reason: 'dead tokens should be cleared');
    });

    test('an unreachable server is told apart from a refusal', () async {
      // Port 1: nothing is listening, so no envelope can come back and the wording
      // has to be the app's own.
      final offline = ApiClient(
        tokens: TokenStore(),
        baseUrl: 'http://127.0.0.1:1',
      );
      addTearDown(offline.close);

      final result = await offline.get<bool>(
        '/auth/credentials',
        authenticated: false,
        parse: (_) => true,
      );

      expect(result, isA<ApiUnreachable<bool>>());
      expect(result.messageIn('en'), contains('could not reach'));
      expect(result.messageIn('ar'), isNotEmpty);
      expect(result.errorCode, isNull,
          reason: 'there was no server to supply one');
    });
  });

  group('the device', () {
    test('reports one fingerprint however often it is asked', () async {
      // With no keystore the write silently fails, so this is the case that used to
      // mint a new id per call and register one handset as many.
      final store = TokenStore();
      final first = await store.deviceFingerprint();
      final second = await store.deviceFingerprint();

      expect(first, isNotEmpty);
      expect(second, first);
    });

    test('survives signing out, so one phone stays one device', () async {
      final store = TokenStore();
      final before = await store.deviceFingerprint();

      await store.clear();

      expect(await store.deviceFingerprint(), before);
    });
  });
}

/// A real client that also counts how many times the refresh endpoint was called.
class _CountingClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  int refreshCalls = 0;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    if (request.url.path.endsWith('/auth/refresh')) refreshCalls += 1;

    return _inner.send(request);
  }

  @override
  void close() {
    _inner.close();
    super.close();
  }
}

/// Whether anything is listening, so the suite can say so once instead of timing out
/// on every test.
Future<bool> _reachable(String base) async {
  try {
    final uri = Uri.parse(base);
    final socket = await Socket.connect(
      uri.host,
      uri.port,
      timeout: const Duration(seconds: 2),
    );
    socket.destroy();

    return true;
  } catch (_) {
    return false;
  }
}
