import 'package:flutter/material.dart';

import '/flutter_flow/flutter_flow_theme.dart';
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
    required NavigatorState navigator,
    required Color surface,
    required Color onSurface,
    required Color muted,
    required Color error,
    required Color success,
  })  : _navigator = navigator,
        _surface = surface,
        _onSurface = onSurface,
        _muted = muted,
        _error = error,
        _success = success;

  /// The navigator the sheet is shown on.
  ///
  /// Captured rather than the Scaffold's messenger because a bottom sheet needs a
  /// context to be shown from, and the root navigator's own context outlives any screen
  /// that started the request — which is the whole problem described above.
  final NavigatorState _navigator;

  final Color _surface;
  final Color _onSurface;
  final Color _muted;
  final Color _error;
  final Color _success;

  /// Captures everything needed to report later. Call before the request.
  ///
  /// The colours are read here too, for the same reason as the navigator:
  /// `FlutterFlowTheme.of` is an ancestor lookup.
  factory ApiFeedback.of(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return ApiFeedback._(
      navigator: Navigator.of(context, rootNavigator: true),
      // `secondary` rather than `secondaryBackground`: the latter is near-white in this
      // theme while `primaryText` is white, which renders a sheet nobody can read. This
      // is the dark card colour the rest of the app puts on its black ground.
      surface: theme.secondary,
      onSurface: theme.primaryText,
      muted: theme.secondaryText,
      error: theme.error,
      success: theme.tertiary,
    );
  }

  /// Shows the outcome of [result], in the session's language.
  ///
  /// Returns when the sheet has been dismissed. A caller that navigates afterwards must
  /// await it: pushing a route while the sheet is up takes the sheet away with it, and
  /// the reason the screen was trying to give never gets read.
  Future<void> show(ApiResult<dynamic> result, {bool onlyOnFailure = true}) {
    if (onlyOnFailure && result.isSuccess) return Future<void>.value();

    final language = AuthSession.instance.languageCode;

    return _show(
      title: result.titleIn(language),
      message: result.messageIn(language),
      isError: !result.isSuccess,
    );
  }

  /// Shows a message this app wrote, for the cases with no server response to quote —
  /// a device with no biometric hardware, a field the user has not filled in.
  Future<void> notice(String message, {bool isError = false}) => _show(
        title: isError ? 'Please check' : 'Done',
        message: message,
        isError: isError,
      );

  /// Asks the user to pick one of [options], and resolves with what they chose.
  ///
  /// Null when the sheet is dismissed without a choice, which is a decision like any
  /// other — a caller must not treat it as a default.
  ///
  /// Here rather than on the screen that needs it because a question and a refusal are
  /// the same furniture: both are a sheet the app raises, and having two of them drift
  /// apart in colour and spacing is how an app starts to look assembled rather than
  /// designed.
  Future<T?> choose<T>({
    required String title,
    required String message,
    required List<({T value, String label, String? detail})> options,
  }) {
    return showModalBottomSheet<T>(
      context: _navigator.context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _ChoiceSheet<T>(
        title: title,
        message: message,
        options: options,
        accent: _success,
        surface: _surface,
        onSurface: _onSurface,
        muted: _muted,
      ),
    );
  }

  Future<void> _show({
    required String title,
    required String message,
    required bool isError,
  }) {
    // Nothing is looked up here, so a screen that has since gone away is not a problem:
    // the navigator was captured while its context was certainly alive.
    return showModalBottomSheet<void>(
      context: _navigator.context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _FeedbackSheet(
        title: title,
        message: message,
        accent: isError ? _error : _success,
        surface: _surface,
        onSurface: _onSurface,
        muted: _muted,
      ),
    );
  }
}

/// The sheet itself.
///
/// A sheet rather than a snack bar because the backend writes a real sentence for every
/// refusal — "the code has expired", "that handle is taken" — and a bar that slides away
/// after three seconds is the wrong place to put a sentence somebody has to read and act
/// on. This waits to be dismissed.
class _FeedbackSheet extends StatelessWidget {
  const _FeedbackSheet({
    required this.title,
    required this.message,
    required this.accent,
    required this.surface,
    required this.onSurface,
    required this.muted,
  });

  final String title;
  final String message;
  final Color accent;
  final Color surface;
  final Color onSurface;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      // The sheet sits over the gesture bar on a phone with no buttons, so its own
      // padding has to clear whatever the system reserves down there.
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: muted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                title,
                style: TextStyle(
                  color: accent,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                message,
                style: TextStyle(
                  color: onSurface,
                  fontSize: 15.0,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: onSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: surface,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A sheet that asks a question, built to match [_FeedbackSheet].
///
/// Each option is a row rather than a dropdown, because the list is short and a person
/// holding a document wants to see their own document named on screen — a collapsed
/// picker makes them open it to find out what the app even accepts.
class _ChoiceSheet<T> extends StatelessWidget {
  const _ChoiceSheet({
    required this.title,
    required this.message,
    required this.options,
    required this.accent,
    required this.surface,
    required this.onSurface,
    required this.muted,
  });

  final String title;
  final String message;
  final List<({T value, String label, String? detail})> options;
  final Color accent;
  final Color surface;
  final Color onSurface;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    color: muted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                title,
                style: TextStyle(
                  color: accent,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                message,
                style: TextStyle(color: onSurface, fontSize: 15.0, height: 1.45),
              ),
              const SizedBox(height: 20.0),
              for (final option in options)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(option.value),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 14.0,
                        ),
                        alignment: AlignmentDirectional.centerStart,
                        backgroundColor: onSurface.withValues(alpha: 0.08),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          side: BorderSide(color: onSurface.withValues(alpha: 0.18)),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option.label,
                            style: TextStyle(
                              color: onSurface,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (option.detail != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                option.detail!,
                                style: TextStyle(color: muted, fontSize: 13.0),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
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
