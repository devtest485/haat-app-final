import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:uuid/uuid.dart';

import '/custom_code/token_store.dart';
import '/custom_code/api_config.dart';
import '/custom_code/api_envelope.dart';
import '/custom_code/api_result.dart';

/// Talks to the HAAT backend.
///
/// Four things happen here so that no screen has to think about them: the bearer token
/// is attached, writes carry an idempotency key, an expired access token is refreshed
/// once and the call retried, and every failure comes back as a value rather than an
/// exception.
class ApiClient {
  ApiClient({required TokenStore tokens, http.Client? inner, String? baseUrl})
      : _tokens = tokens,
        _http = inner ??
            IOClient(
                HttpClient()..connectionTimeout = ApiConfig.connectTimeout),
        _baseUrl = baseUrl;

  final TokenStore _tokens;
  final http.Client _http;

  /// Overrides [ApiConfig.baseUrl] for this client only.
  ///
  /// Exists for tests that need a client pointed somewhere specific — a dead port, a
  /// stub server — without changing the address the rest of the app is using.
  final String? _baseUrl;

  String get _base => _baseUrl ?? ApiConfig.baseUrl;
  final _uuid = const Uuid();

  /// The language the backend should answer in. Every message comes back in both, so
  /// this only decides which one a screen reads by default.
  String languageCode = 'en';

  /// Called when the session is gone for good — a refresh was refused, so the user has
  /// to sign in again. Set by [AuthSession].
  void Function()? onSessionExpired;

  /// A refresh in progress, shared by every caller that needs one.
  ///
  /// Without this, three requests failing at once fire three refreshes. The backend
  /// rotates the refresh token on each use, so the second would present a token the
  /// first had already spent — and the user is signed out by the very mechanism meant
  /// to keep them signed in. One refresh, everyone waits for it.
  Future<bool>? _refreshInFlight;

  Future<ApiResult<T>> get<T>(
    String path, {
    required T Function(ApiEnvelope) parse,
    Map<String, String>? query,
    bool authenticated = true,
  }) =>
      _send(
        method: 'GET',
        path: path,
        query: query,
        parse: parse,
        authenticated: authenticated,
      );

  Future<ApiResult<T>> post<T>(
    String path, {
    required T Function(ApiEnvelope) parse,
    Map<String, dynamic>? body,
    bool authenticated = true,

    /// Reuse a key across retries of the same logical action, so a request the server
    /// carried out but never acknowledged is not carried out twice. Omit it and one is
    /// generated per call, which is right for a fresh attempt.
    String? idempotencyKey,
  }) =>
      _send(
        method: 'POST',
        path: path,
        body: body,
        parse: parse,
        authenticated: authenticated,
        idempotencyKey: idempotencyKey ?? _uuid.v4(),
      );

  Future<ApiResult<T>> delete<T>(
    String path, {
    required T Function(ApiEnvelope) parse,
    bool authenticated = true,
  }) =>
      _send(
          method: 'DELETE',
          path: path,
          parse: parse,
          authenticated: authenticated);

  Future<ApiResult<T>> patch<T>(
    String path, {
    required T Function(ApiEnvelope) parse,
    Map<String, dynamic>? body,
    bool authenticated = true,
  }) =>
      _send(
        method: 'PATCH',
        path: path,
        body: body,
        parse: parse,
        authenticated: authenticated,
        idempotencyKey: _uuid.v4(),
      );

  Future<ApiResult<T>> _send<T>({
    required String method,
    required String path,
    required T Function(ApiEnvelope) parse,
    Map<String, dynamic>? body,
    Map<String, String>? query,
    bool authenticated = true,
    String? idempotencyKey,
    bool isRetry = false,
  }) async {
    // Cheap after the first call, and it is what guarantees the configured base URL is
    // in hand before a URL is built from it.
    await ApiConfig.load();

    final uri = Uri.parse('$_base$path').replace(
      queryParameters: (query == null || query.isEmpty) ? null : query,
    );

    final headers = <String, String>{
      'Accept': 'application/json',
      'Accept-Language': languageCode,
      if (body != null) 'Content-Type': 'application/json',
      if (idempotencyKey != null) 'Idempotency-Key': idempotencyKey,
      // The bank this app was built for: accounts are looked up within it.
      if (ApiConfig.bankCode.isNotEmpty) 'X-Haat-Bank': ApiConfig.bankCode,
    };

    final token = _tokens.accessToken;
    if (authenticated && token != null)
      headers['Authorization'] = 'Bearer $token';

    http.Response response;
    try {
      response = await _http
          .send(_request(method, uri, headers, body))
          .then(http.Response.fromStream)
          .timeout(ApiConfig.timeout);
    } on TimeoutException catch (error) {
      return ApiUnreachable.tooSlow<T>(error);
    } on SocketException catch (error) {
      return ApiUnreachable.offline<T>(error);
    } on http.ClientException catch (error) {
      return ApiUnreachable.offline<T>(error);
    } on HandshakeException catch (error) {
      return ApiUnreachable.offline<T>(error);
    }

    final envelope = _decode(response);

    if (_shouldAttemptRefresh(envelope,
        authenticated: authenticated, isRetry: isRetry)) {
      if (await _refresh()) {
        return _send(
          method: method,
          path: path,
          parse: parse,
          body: body,
          query: query,
          authenticated: authenticated,
          // The same key, because this is the same logical action retried.
          idempotencyKey: idempotencyKey,
          isRetry: true,
        );
      }
    }

    if (!envelope.isSuccess) return ApiFailure<T>(envelope);

    try {
      return ApiSuccess<T>(parse(envelope), envelope);
    } catch (_) {
      // The call succeeded and the payload was not what this version expects — a
      // backend that has moved on. Reported as a failure rather than thrown, so the
      // screen shows a message instead of a red frame.
      return ApiFailure<T>(ApiEnvelope.unparseable(envelope.responseCode));
    }
  }

  http.Request _request(
    String method,
    Uri uri,
    Map<String, String> headers,
    Map<String, dynamic>? body,
  ) {
    final request = http.Request(method, uri);
    request.headers.addAll(headers);
    if (body != null) request.body = json.encode(body);

    return request;
  }

  ApiEnvelope _decode(http.Response response) {
    try {
      final decoded = json.decode(utf8.decode(response.bodyBytes));

      return decoded is Map<String, dynamic>
          ? ApiEnvelope.fromJson(decoded, response.statusCode)
          : ApiEnvelope.unparseable(response.statusCode);
    } catch (_) {
      return ApiEnvelope.unparseable(response.statusCode);
    }
  }

  /// Whether a 401 is worth one refresh attempt.
  ///
  /// `UNAUTHENTICATED` covers two unrelated things: an access token that has expired,
  /// and a password that was wrong. Refreshing on the second would be pointless — there
  /// is no session yet — so three conditions all have to hold: the call was
  /// authenticated, we actually hold a refresh token, and this is not already the retry.
  bool _shouldAttemptRefresh(
    ApiEnvelope envelope, {
    required bool authenticated,
    required bool isRetry,
  }) =>
      authenticated &&
      !isRetry &&
      envelope.responseCode == 401 &&
      _tokens.hasSession;

  /// Exchanges the refresh token for a new pair. At most one runs at a time.
  /// Uploads one file as `multipart/form-data`, under the field name [field].
  ///
  /// Takes bytes rather than a path. A path is a thing only a phone has — in a browser
  /// there is no file system to read from, only the bytes the picker handed over — so
  /// working from bytes is what lets the same upload run on both.
  ///
  /// Retried once on a 401 after a refresh, like every other call here. The body is
  /// rebuilt for the retry: a multipart request is a stream, and a stream is spent the
  /// first time it is sent.
  Future<ApiResult<T>> postFile<T>(
    String path, {
    required List<int> bytes,
    required String filename,
    required T Function(ApiEnvelope) parse,
    String field = 'file',

    /// Text parts sent beside the file — a KYC upload names the document's kind
    /// this way, in the same request as the file it describes.
    Map<String, String> fields = const {},
    bool isRetry = false,
  }) async {
    await ApiConfig.load();

    final request = http.MultipartRequest('POST', Uri.parse('$_base$path'))
      ..headers.addAll({
        'Accept': 'application/json',
        'Accept-Language': languageCode,
        'Idempotency-Key': _uuid.v4(),
      })
      ..fields.addAll(fields)
      ..files.add(
        // No content type sent. The server reads the kind of file from its own
        // bytes and ignores the label, so claiming one here would only be a second
        // opinion nobody consults.
        http.MultipartFile.fromBytes(field, bytes, filename: filename),
      );

    final token = _tokens.accessToken;
    if (token != null) request.headers['Authorization'] = 'Bearer $token';

    http.Response response;
    try {
      response = await _http
          .send(request)
          .then(http.Response.fromStream)
          .timeout(ApiConfig.timeout);
    } on TimeoutException catch (error) {
      return ApiUnreachable.tooSlow<T>(error);
    } on http.ClientException catch (error) {
      return ApiUnreachable.offline<T>(error);
    }

    final envelope = _decode(response);

    if (_shouldAttemptRefresh(envelope,
            authenticated: true, isRetry: isRetry) &&
        await _refresh()) {
      return postFile(
        path,
        bytes: bytes,
        filename: filename,
        parse: parse,
        field: field,
        fields: fields,
        isRetry: true,
      );
    }

    return envelope.isSuccess
        ? ApiSuccess<T>(parse(envelope), envelope)
        : ApiFailure<T>(envelope);
  }

  /// Mints a new access token now, rather than waiting for one to be refused.
  ///
  /// Every other refresh here is reactive: a 401 comes back and the call is retried.
  /// That is the right shape for an *expired* token and the wrong one for a token that
  /// is merely out of date — after registering a business the account gains permissions
  /// its current token was minted without, and the token does not fail, it just does
  /// less than it should. Waiting for a 401 there means the next call is refused for a
  /// reason the merchant did nothing to cause.
  ///
  /// Shares the in-flight guard with the reactive path, so a refresh already under way
  /// is awaited rather than duplicated.
  Future<bool> refreshSession() => _refresh();

  Future<bool> _refresh() {
    final existing = _refreshInFlight;
    if (existing != null) return existing;

    final attempt = _performRefresh();
    _refreshInFlight = attempt;

    return attempt.whenComplete(() => _refreshInFlight = null);
  }

  Future<bool> _performRefresh() async {
    final refreshToken = _tokens.refreshToken;
    if (refreshToken == null) return false;

    http.Response response;
    try {
      final request = http.Request(
        'POST',
        Uri.parse('$_base/auth/refresh'),
      );
      request.headers.addAll({
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      });
      request.body = json.encode({'refreshToken': refreshToken});

      response = await _http
          .send(request)
          .then(http.Response.fromStream)
          .timeout(ApiConfig.timeout);
    } catch (_) {
      // Could not reach the server. The session is not known to be invalid, so it is
      // left alone and the original call reports the failure instead of signing the
      // user out for being on a bad train.
      return false;
    }

    final envelope = _decode(response);

    if (!envelope.isSuccess) {
      // The server rejected the refresh token: revoked, expired, or already used.
      // This session is over, and pretending otherwise means every later call fails
      // the same way.
      await _tokens.clear();
      onSessionExpired?.call();

      return false;
    }

    final data = envelope.object;
    final access = data['accessToken'];
    final refresh = data['refreshToken'];

    if (access is! String || refresh is! String) return false;

    await _tokens.replaceTokens(accessToken: access, refreshToken: refresh);

    return true;
  }

  void close() => _http.close();
}
