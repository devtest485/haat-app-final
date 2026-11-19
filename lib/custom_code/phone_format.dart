import '/app_state.dart';
import '/flutter_flow/custom_functions.dart';

/// The phone number format the sign-up screen collects.
///
/// The country is the one chosen on the sign-up screen — Pakistan's `🇵🇰 + 92` until
/// somebody chooses another, which is what the screen has always shown — and it is kept on
/// the phone, so signing in with the same number later is read under the same code. The
/// backend accepts any international number.
abstract final class PhoneFormat {
  /// The dial code of the country chosen, with its plus.
  static String get dialCode =>
      '+${signupCountryField(FFAppState().signupCountry, 'dialCode')}';

  /// Turns what the user typed into the E.164 form the backend wants.
  ///
  /// Tolerates a leading zero and any spacing or dashes, because people type their
  /// number the way they say it rather than the way a regular expression wants it.
  static String toE164(String typed) {
    final trimmed = typed.trim();
    var digits = trimmed.replaceAll(RegExp(r'\D'), '');

    // Somebody who typed their own country code meant it. Putting the screen's dial
    // code in front of it as well produces a number belonging to nobody — a Sudanese
    // +249 911 000 007 would be sent as +92249911000007.
    if (trimmed.startsWith('+')) return '+$digits';

    if (digits.startsWith(dialCode.substring(1))) {
      digits = digits.substring(dialCode.length - 1);
    }

    while (digits.startsWith('0')) {
      digits = digits.substring(1);
    }

    return '$dialCode$digits';
  }

  /// Whether [typed] is a whole number under the country chosen.
  static bool isComplete(String typed) =>
      signupPhoneComplete(typed, FFAppState().signupCountry);
}
