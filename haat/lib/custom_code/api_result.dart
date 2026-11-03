import '/custom_code/api_envelope.dart';

/// The outcome of a call, in the three shapes a caller actually has to tell apart.
///
/// The split that matters is the last one. "The server refused" and "the server was
/// never reached" look the same to a screen that only checks a boolean, and they need
/// opposite responses: a refusal has a message worth showing and usually means fix the
/// input, while an unreachable server means try again and has no server message at all,
/// so the app has to supply the wording itself.
sealed class ApiResult<T> {
  const ApiResult();

  /// The value on success, or null.
  T? get valueOrNull => switch (this) {
        ApiSuccess<T>(:final value) => value,
        _ => null,
      };

  bool get isSuccess => this is ApiSuccess<T>;

  /// Text to put in front of the user, in [languageCode], whatever went wrong.
  String messageIn(String languageCode) => switch (this) {
        ApiSuccess<T>(:final envelope) => envelope.messageIn(languageCode),
        ApiFailure<T>(:final envelope) => envelope.messageIn(languageCode),
        ApiUnreachable<T>(:final message, :final messageAr) =>
          languageCode == 'ar' ? messageAr : message,
      };

  /// Heading to pair with [messageIn].
  String titleIn(String languageCode) => switch (this) {
        ApiSuccess<T>(:final envelope) => envelope.titleIn(languageCode),
        ApiFailure<T>(:final envelope) => envelope.titleIn(languageCode),
        ApiUnreachable<T>() =>
          languageCode == 'ar' ? 'لا يوجد اتصال' : 'No Connection',
      };

  /// The server's error code, or null when the server was not reached.
  String? get errorCode => switch (this) {
        ApiFailure<T>(:final envelope) => envelope.errorCode,
        _ => null,
      };
}

/// The server said yes, and [value] is the parsed payload.
final class ApiSuccess<T> extends ApiResult<T> {
  const ApiSuccess(this.value, this.envelope);

  final T value;

  /// Kept because the success message is worth showing too — the backend writes one
  /// for every route, in both languages.
  final ApiEnvelope envelope;
}

/// The server said no, and said why.
final class ApiFailure<T> extends ApiResult<T> {
  const ApiFailure(this.envelope);

  final ApiEnvelope envelope;

  /// `data` on a failure is not always empty: a lockout carries `retryAfterSeconds`,
  /// an MFA challenge carries `mfaToken`, a rejected field carries `unmet`.
  Map<String, dynamic> get data => envelope.object;
}

/// The server was never reached, or answered too late to matter.
final class ApiUnreachable<T> extends ApiResult<T> {
  const ApiUnreachable(this.cause,
      {required this.message, required this.messageAr});

  /// The underlying exception, for logging. Never shown to a user: a
  /// `SocketException` naming a port helps nobody holding a phone.
  final Object cause;

  final String message;
  final String messageAr;

  /// No route was reached, so nothing was created or changed — with one caveat worth
  /// knowing: a request that timed out may still have been carried out by the server,
  /// and the reply is what went missing. Every write in this app therefore sends an
  /// idempotency key, so retrying is safe.
  static ApiUnreachable<T> offline<T>(Object cause) => ApiUnreachable<T>(
        cause,
        message:
            'We could not reach HAAT. Check your connection and try again.',
        messageAr: 'لم نتمكن من الوصول إلى هات. تحقق من اتصالك وحاول مرة أخرى.',
      );

  static ApiUnreachable<T> tooSlow<T>(Object cause) => ApiUnreachable<T>(
        cause,
        message: 'HAAT took too long to answer. Please try again.',
        messageAr: 'استغرق هات وقتًا طويلاً للرد. يرجى المحاولة مرة أخرى.',
      );
}
