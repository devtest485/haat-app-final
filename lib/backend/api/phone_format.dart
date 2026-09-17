/// The phone number format the sign-up screen collects.
///
/// The design hard-codes a single country — the flag and dial code are painted into
/// the screen rather than chosen — so the app has one dial code, in one place. The
/// backend accepts any international number, so widening this later is a UI change and
/// not a contract change.
abstract final class PhoneFormat {
  /// Matches the `🇵🇰 + 92` shown on the phone number screen.
  static const String dialCode = '+92';

  /// How many digits the screen expects after the dial code.
  static const int nationalDigits = 10;

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

  /// Whether [typed] has the number of digits the screen asks for.
  static bool isComplete(String typed) =>
      typed.replaceAll(RegExp(r'\D'), '').length == nationalDigits;
}
