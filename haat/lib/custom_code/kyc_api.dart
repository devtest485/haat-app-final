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
/// One document on a case, as the app needs to show it.
///
/// No bytes: the phone that uploaded it has no reason to fetch it back, and the body
/// is fetched one document at a time by the back office through a separately audited
/// call. What a merchant needs to see is that it arrived.
class KycDocument {
  const KycDocument({
    required this.kind,
    required this.contentType,
    required this.byteSize,
    required this.uploadedAt,
  });

  /// `trade_licence`, `tax_certificate`, `proof_of_address` for a business.
  final String kind;
  final String contentType;
  final int byteSize;
  final String uploadedAt;

  factory KycDocument.fromData(Map<String, dynamic> data) => KycDocument(
        kind: data['kind'] as String? ?? '',
        contentType: data['contentType'] as String? ?? '',
        byteSize: (data['byteSize'] as num?)?.toInt() ?? 0,
        uploadedAt: data['uploadedAt'] as String? ?? '',
      );
}

/// A verification case — the business's, in the screens that use this.
class KycCase {
  const KycCase({
    required this.status,
    required this.editable,
    required this.complete,
    required this.documents,
  });

  /// `draft`, `submitted`, `in_review`, `approved`, `rejected`, `expired`.
  final String status;

  /// Whether the merchant may still change it. False once it is with the back office,
  /// which is what stops the screen offering an upload that would be refused.
  final bool editable;

  /// Every required document is in, so submitting would be accepted.
  final bool complete;

  final List<KycDocument> documents;

  bool has(String kind) => documents.any((document) => document.kind == kind);

  factory KycCase.fromData(Map<String, dynamic> data) => KycCase(
        status: data['status'] as String? ?? 'draft',
        editable: data['editable'] as bool? ?? true,
        complete: data['complete'] as bool? ?? false,
        documents: (data['documents'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(KycDocument.fromData)
            .toList(),
      );
}

class KycApi {
  KycApi(this._client);

  final ApiClient _client;

  /// The business's case, opened by the backend if this is the first look at it.
  ///
  /// Separate from the person's case above: a merchant proves who they are with a
  /// national ID and a selfie, and proves the business exists with a trade licence.
  /// The backend keeps them as two cases for that reason, and refuses a document filed
  /// against the wrong one.
  Future<ApiResult<KycCase>> businessCase() => _client.get(
        '/kyc/organization',
        parse: (envelope) => KycCase.fromData(envelope.object),
      );

  /// Sends one business document, replacing whatever was filed under that kind.
  ///
  /// The type is read from the file's own bytes by the backend, not from the name, so
  /// a photograph renamed `.pdf` is refused rather than filed as one.
  Future<ApiResult<KycCase>> uploadBusinessDocument({
    required String kind,
    required List<int> bytes,
    required String filename,
  }) =>
      _client.postFile(
        '/kyc/organization/documents',
        bytes: bytes,
        filename: filename,
        fields: {'kind': kind},
        parse: (envelope) => KycCase.fromData(envelope.object),
      );

  /// Hands the case to the back office.
  ///
  /// Refused while anything is outstanding, and the refusal names what is missing —
  /// which is the message worth showing, rather than one this app invents.
  Future<ApiResult<KycCase>> submitBusinessCase() => _client.post(
        '/kyc/organization/submit',
        parse: (envelope) => KycCase.fromData(envelope.object),
      );

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
