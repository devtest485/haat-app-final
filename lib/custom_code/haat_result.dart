import '/custom_code/api_result.dart';

/// How a ported entry point reports an outcome to a FlutterFlow action chain.
///
/// A chain cannot read a field out of a JSON return — the DSL has no JSON-path
/// expression — so an outcome has to be a scalar the chain can branch on
/// directly. Everything here therefore answers with a String, and the branch is
/// a single equality test.
///
/// This class is for the FlutterFlow side only. The app's own screens hold the
/// [ApiResult] and keep the type.
class HaatResult {
  const HaatResult._();

  /// Empty when the call succeeded; otherwise the message the server wrote.
  ///
  /// The failure text is the backend's own wording, in the language it was
  /// asked for, rather than something this app invented — so what the user
  /// reads is what support sees in the logs.
  static String messageOrEmpty<T>(ApiResult<T> result, String languageCode) =>
      result.isSuccess ? '' : result.messageIn(languageCode);
}
