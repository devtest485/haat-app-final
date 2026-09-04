import 'package:flutter/material.dart';

import '../api/api_result.dart';
import '../auth/auth_session.dart';

/// Shows the outcome of a call to the user.
///
/// Every screen reports through here, so failures look the same wherever they happen
/// and the text shown is the text the backend wrote. The envelope already carries a
/// sentence in both languages for every route; re-wording it per screen would mean
/// maintaining the same message in two repositories and getting the Arabic wrong in
/// one of them.
///
/// ## Why this is captured rather than looked up
///
/// It is taken from a context **before** the request, not after. The obvious shape —
/// `await something(); if (context.mounted) context.showSnackBar(...)` — is wrong in a
/// way that only shows up under real use:
///
/// `BuildContext.mounted` stays true while an element is *deactivated*, which is what
/// it is for the rest of the frame in which the user navigates away. `ScaffoldMessenger
/// .of` walks ancestors, and that asserts the element is *active*. So a request still
/// in flight when somebody taps back throws "Looking up a deactivated widget's ancestor
/// is unsafe" — a red screen for pressing back at the wrong moment.
///
/// Capturing the messenger while the context is definitely alive removes the problem
/// rather than narrowing the window: there is no ancestor lookup left to do afterwards.
///
/// ```dart
/// final feedback = ApiFeedback.of(context);
/// final result = await session.signIn(...);
/// if (!mounted) return;
/// feedback.show(result);
/// ```
class ApiFeedback {
  const ApiFeedback._({
    required ScaffoldMessengerState messenger,
    required Color onNeutral,
    required Color neutral,
    required Color onError,
    required Color error,
  })  : _messenger = messenger,
        _onNeutral = onNeutral,
        _neutral = neutral,
        _onError = onError,
        _error = error;

  final ScaffoldMessengerState _messenger;
  final Color _onNeutral;
  final Color _neutral;
  final Color _onError;
  final Color _error;

  /// Captures everything needed to report later. Call before the request.
  ///
  /// The colours are read here too, for the same reason as the messenger: `Theme.of`
  /// is an ancestor lookup.
  factory ApiFeedback.of(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ApiFeedback._(
      messenger: ScaffoldMessenger.of(context),
      onNeutral: scheme.onInverseSurface,
      neutral: scheme.inverseSurface,
      onError: scheme.onError,
      error: scheme.error,
    );
  }

  /// Shows the message from [result], in the session's language.
  void show(ApiResult<dynamic> result, {bool onlyOnFailure = true}) {
    if (onlyOnFailure && result.isSuccess) return;

    _show(
      result.messageIn(AuthSession.instance.languageCode),
      isError: !result.isSuccess,
    );
  }

  /// Shows a message this app wrote, for the cases with no server response to quote —
  /// a device with no biometric hardware, a field the user has not filled in.
  void notice(String message, {bool isError = false}) =>
      _show(message, isError: isError);

  void _show(String message, {required bool isError}) {
    // Nothing is looked up here, so a screen that has since gone away is not a
    // problem: the messenger belongs to the Scaffold above it, which is still there.
    _messenger.showSnackBar(
      SnackBar(
        // Each ground gets the colour meant to read on it. Using one for both put
        // dark red text on a red bar, which was legible only if you knew what it said.
        content: Text(
          message,
          style: TextStyle(color: isError ? _onError : _onNeutral),
        ),
        backgroundColor: isError ? _error : _neutral,
        duration: Duration(seconds: isError ? 5 : 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

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
    var digits = typed.replaceAll(RegExp(r'\D'), '');

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
