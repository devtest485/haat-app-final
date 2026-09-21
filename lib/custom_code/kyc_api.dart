import '/custom_code/api_result.dart';
import '/custom_code/api_client.dart';

/// What the device SDK needs to run a capture.
class KycProviderSession {
  const KycProviderSession({
    required this.sessionToken,
    required this.baseUrl,
    this.expiresAt,
    this.purpose,
  });

  /// Where the SDK sends the capture.
  ///
  /// Told to the app by the backend rather than built into it, so moving between the
  /// provider's sandbox and production is a deployment change, not an app release.
  final String baseUrl;

  /// Short-lived, and good for one capture.
  ///
  /// This is deliberately all the device gets. The provider's client key and secret
  /// stay on the backend — a secret shipped to a handset is a secret that has been
  /// published, and the provider's own documentation says as much.
  final String sessionToken;

  final String? expiresAt;
  final String? purpose;

  factory KycProviderSession.fromData(Map<String, dynamic> data) =>
      KycProviderSession(
        sessionToken: data['sessionToken'] as String? ?? '',
        baseUrl: data['baseUrl'] as String? ?? '',
        expiresAt: data['expiresAt'] as String?,
        purpose: data['purpose'] as String?,
      );
}

/// Where a verification stands, according to the backend.
class KycProviderOutcome {
  const KycProviderOutcome({
    required this.result,
    required this.status,
    required this.isComplete,
  });

  /// `VERIFIED`, `REJECTED`, `REVIEW`, or null while the capture is unfinished.
  final String? result;

  /// The provider's own session lifecycle status.
  final String status;

  /// True once there is nothing left to wait for.
  final bool isComplete;

  bool get isVerified => result == 'VERIFIED';
  bool get needsReview => result == 'REVIEW';

  factory KycProviderOutcome.fromData(Map<String, dynamic> data) =>
      KycProviderOutcome(
        result: data['result'] as String?,
        status: data['status'] as String? ?? 'UNKNOWN',
        isComplete: data['isComplete'] == true,
      );
}

/// Identity verification, as far as the app is concerned.
///
/// Ask whether the automated check is on the table, ask the backend to open a session,
/// then — once the SDK has finished with the camera — ask what the provider concluded.
///
/// The app never reads the verdict from the SDK. The SDK's own documentation is blunt
/// about it: act on the verdict your backend fetches, not the copy the app reports. A
/// value that passed through the device is a value the device could have changed.
class KycApi {
  KycApi(this._client);

  final ApiClient _client;

  /// Whether the automated check can run at all.
  ///
  /// An operator switches it off in the back office to stop the platform paying per
  /// check while a build is being tested, and the provider's credentials can simply be
  /// absent. Either way the capture is impossible, and this says so before the app
  /// draws a screen about it.
  ///
  /// Asked rather than discovered. The alternative was to open a session and read the
  /// refusal, which meant a merchant was shown the camera step and asked which document
  /// they were holding before anything admitted the check was never going to run.
  ///
  /// **Only an explicit `false` skips the check**, and that matters twice over.
  ///
  /// A backend that predates this field says nothing, and a build that read silence as
  /// "unavailable" would walk every merchant straight past identity verification the
  /// moment it shipped ahead of the deployment. The same goes for a failed call: a
  /// train tunnel is not an operator's decision.
  ///
  /// So anything short of a clear no means carry on, and `startProviderSession` gives
  /// the real answer a moment later — which is exactly what happened before this
  /// existed. The field only ever saves a merchant from being asked questions about a
  /// check that was never going to run.
  Future<bool> isAutomatedAvailable() async {
    final result = await _client.get(
      '/kyc/user',
      parse: (envelope) => envelope.object['automatedAvailable'] != false,
    );

    return result is! ApiSuccess<bool> || result.value;
  }

  /// Opens a capture session for the signed-in user.
  Future<ApiResult<KycProviderSession>> startSession() => _client.post(
        '/kyc/user/provider-session',
        parse: (envelope) => KycProviderSession.fromData(envelope.object),
      );

  /// Asks what the provider concluded.
  ///
  /// Safe to call repeatedly: there are no webhooks, so asking is the only way to find
  /// out, and the backend's read is idempotent.
  Future<ApiResult<KycProviderOutcome>> collectResult() => _client.post(
        '/kyc/user/provider-result',
        parse: (envelope) => KycProviderOutcome.fromData(envelope.object),
      );
}
