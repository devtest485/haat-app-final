/// Every response from the HAAT backend, successful or not, arrives in one shape.
///
/// ```json
/// {
///   "isSuccess": true,
///   "title": "Signed In",           "title_ar":   "تم تسجيل الدخول",
///   "message": "Welcome back.",     "message_ar": "أهلاً بك مرة أخرى.",
///   "data": { },
///   "responseCode": 200,
///   "errorCode": "VALIDATION_FAILED",
///   "requestId": "cf7109be-…"
/// }
/// ```
///
/// The title and message are written for a person to read and already come in both
/// languages, so a screen shows what the server said rather than inventing its own
/// wording. That is the whole point of the envelope: error text lives in one place and
/// is translated once.
class ApiEnvelope {
  const ApiEnvelope({
    required this.isSuccess,
    required this.title,
    required this.titleAr,
    required this.message,
    required this.messageAr,
    required this.data,
    required this.responseCode,
    this.errorCode,
    this.requestId,
  });

  final bool isSuccess;
  final String title;
  final String titleAr;
  final String message;
  final String messageAr;

  /// The payload. An object for most routes, a list for the collection routes.
  final dynamic data;

  final int responseCode;

  /// Present on failures only — `VALIDATION_FAILED`, `MFA_REQUIRED`, and so on.
  ///
  /// This is the field to branch on. The HTTP status is too coarse (several different
  /// refusals share 401) and the message is prose that will be reworded.
  final String? errorCode;

  /// Quote this when reporting a problem; it ties the app's report to the server's log.
  final String? requestId;

  /// Reads an envelope out of a decoded JSON body.
  ///
  /// Tolerant on purpose. A proxy or a load balancer can interpose a response that
  /// never reached the application, and a client that throws while parsing an error
  /// turns a bad gateway into a crash.
  factory ApiEnvelope.fromJson(Map<String, dynamic> json, int statusCode) {
    String text(String key) {
      final value = json[key];

      return value is String ? value : '';
    }

    return ApiEnvelope(
      isSuccess: json['isSuccess'] == true,
      title: text('title'),
      titleAr: text('title_ar'),
      message: text('message'),
      messageAr: text('message_ar'),
      data: json['data'],
      responseCode: json['responseCode'] is int
          ? json['responseCode'] as int
          : statusCode,
      errorCode:
          json['errorCode'] is String ? json['errorCode'] as String : null,
      requestId:
          json['requestId'] is String ? json['requestId'] as String : null,
    );
  }

  /// Stands in for a response that was not the envelope at all.
  ///
  /// Reached when something between the app and the application answered — a gateway
  /// error page, a captive portal. The message is ours because there is no server
  /// message to show.
  factory ApiEnvelope.unparseable(int statusCode) => ApiEnvelope(
        isSuccess: false,
        title: 'Something Went Wrong',
        titleAr: 'حدث خطأ ما',
        message: 'The server sent a reply we could not read. Please try again.',
        messageAr:
            'أرسل الخادم ردًا لم نتمكن من قراءته. يرجى المحاولة مرة أخرى.',
        data: const <String, dynamic>{},
        responseCode: statusCode,
        errorCode: 'UNREADABLE_RESPONSE',
      );

  /// The payload as an object, or an empty map when it was a list or absent.
  Map<String, dynamic> get object =>
      data is Map<String, dynamic> ? data as Map<String, dynamic> : const {};

  /// The payload as a list, or an empty list when it was an object or absent.
  List<dynamic> get list => data is List ? data as List<dynamic> : const [];

  /// The title in [languageCode], falling back to whichever the server filled in.
  String titleIn(String languageCode) =>
      languageCode == 'ar' ? (titleAr.isEmpty ? title : titleAr) : title;

  /// The message in [languageCode], falling back to whichever the server filled in.
  String messageIn(String languageCode) => languageCode == 'ar'
      ? (messageAr.isEmpty ? message : messageAr)
      : message;
}

/// Error codes the app changes its behaviour for.
///
/// Only the ones that lead somewhere different are listed. Everything else is shown to
/// the user as the message the server wrote, which needs no constant.
abstract final class ApiErrorCode {
  /// The password was right and a second factor is still owed. The envelope's `data`
  /// carries an `mfaToken` to spend on `POST /auth/mfa/verify`.
  static const String mfaRequired = 'MFA_REQUIRED';

  /// Too many failed attempts. `data.retryAfterSeconds` says how long, so the screen
  /// can count down instead of inviting an attempt that is certain to fail.
  static const String accountLocked = 'ACCOUNT_LOCKED';

  /// Automated identity verification is switched off in the back office.
  ///
  /// The one refusal a screen should move **past** rather than report. Nothing is
  /// broken and retrying will not help — an operator has turned the paid check off,
  /// and the merchant carries on to the manual path without being told about a setting
  /// that is none of their concern.
  static const String kycProviderDisabled = 'KYC_PROVIDER_DISABLED';

  /// Not authenticated.
  ///
  /// Note that a rejected sign-in returns this too — the same code covers "your token
  /// expired" and "that password was wrong". So this is not enough on its own to decide
  /// whether to refresh: the client also has to know whether it held a token and
  /// whether the call was itself trying to establish a session. See
  /// `ApiClient._shouldAttemptRefresh`.
  static const String unauthenticated = 'UNAUTHENTICATED';

  /// A field was wrong. `data.unmet` names which rules, where the route provides it.
  static const String validationFailed = 'VALIDATION_FAILED';
}
