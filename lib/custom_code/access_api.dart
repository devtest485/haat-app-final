import '/custom_code/api_client.dart';
import '/custom_code/api_result.dart';

/// What the signed-in person is allowed to do, as `resource:action` keys.
///
/// Read from the server's database rather than from the token, so a role changed a
/// moment ago shows up on the next read. Screens use it only to hide controls the person
/// cannot use — a courtesy, not a security measure: every route still checks the same
/// keys server-side.
class AccessApi {
  AccessApi(this._client);

  final ApiClient _client;

  Future<ApiResult<List<String>>> mine() => _client.get(
        '/rbac/me',
        parse: (envelope) {
          final data = envelope.data;
          final keys =
              data is Map<String, dynamic> ? data['permissions'] : null;

          return (keys is List ? keys : const []).whereType<String>().toList();
        },
      );
}
