import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/biometric_key_store.dart';

const _page = Color(0xFFF5F5F7);
const _ink = Color(0xFF111111);
const _muted = Color(0xFF6B6B72);
const _hairline = Color(0xFFE4E4E9);
const _greenDeep = Color(0xFF00794A);
const _danger = Color(0xFFD93025);

TextStyle _type(
  double size, {
  FontWeight weight = FontWeight.w400,
  Color color = _ink,
  double? height,
  double letterSpacing = 0,
}) =>
    GoogleFonts.montserrat(
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );

/// Asks for the passcode or fingerprint that allows moving [amount] to [name].
///
/// [verb] finishes "Use your passcode to …": `send` for a transfer, `pay` for a
/// payment request, `request` before asking to be paid ([preposition] `from`).
/// [challenge] is read when the fingerprint is used, so it names the reference in
/// force then. Null when the person closed it.
Future<PayCredential?> showAuthorizeDialog(
  BuildContext context, {
  required String amount,
  required String name,
  required bool fingerprint,
  required Future<ApiResult<String>> Function() challenge,
  String verb = 'send',
  String biometricTitle = 'Confirm transfer',
  String preposition = 'to',
  String? error,
}) =>
    showGeneralDialog<PayCredential>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cancel',
      barrierColor: const Color(0x66000000),
      transitionDuration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 200),
      pageBuilder: (_, __, ___) => AuthorizeDialog(
        amount: amount,
        name: name,
        fingerprint: fingerprint,
        error: error,
        verb: verb,
        biometricTitle: biometricTitle,
        preposition: preposition,
        challenge: challenge,
      ),
      transitionBuilder: (_, animation, __, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);

        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween(begin: 0.96, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );

/// How the person allowed the send: one of the two is set.
class PayCredential {
  const PayCredential.passcode(String this.passcode) : signature = null;
  const PayCredential.fingerprint(String this.signature) : passcode = null;

  final String? passcode;

  /// The phone's hardware key over the server's challenge for this very send.
  final String? signature;
}

/// The passcode, or the fingerprint, that allows the send.
///
/// Nothing is checked here: the passcode goes to the server with the send, and the
/// fingerprint signs a challenge the server bound to this recipient, amount and
/// reference. A refusal of either comes back here as [error].
class AuthorizeDialog extends StatefulWidget {
  const AuthorizeDialog({
    super.key,
    required this.amount,
    required this.name,
    required this.fingerprint,
    required this.challenge,
    this.verb = 'send',
    this.biometricTitle = 'Confirm transfer',
    this.preposition = 'to',
    this.error,
  });

  final String amount;
  final String name;

  /// Whether this phone can use a fingerprint at all.
  final bool fingerprint;
  final Future<ApiResult<String>> Function() challenge;
  final String? error;

  /// What the money is doing: `send`, or `pay`.
  final String verb;
  final String biometricTitle;

  /// Between the amount and [name]: `to`, or `from` for a request.
  final String preposition;

  @override
  State<AuthorizeDialog> createState() => AuthorizeDialogState();
}

class AuthorizeDialogState extends State<AuthorizeDialog>
    with SingleTickerProviderStateMixin {
  final _passcode = TextEditingController();
  final _focus = FocusNode();
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 380),
  );

  late String? _error = widget.error;

  /// Whether [_error] is about the fingerprint, so the passcode boxes stay unmarked.
  bool _fingerprintFailed = false;
  bool _scanning = false;

  @override
  void initState() {
    super.initState();
    _passcode.addListener(() => setState(() {
          if (_passcode.text.isNotEmpty) _error = null;
        }));
    _focus.addListener(() => setState(() {}));

    if (_error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        HapticFeedback.heavyImpact();
        _shake.forward(from: 0);
      });
    }
  }

  @override
  void dispose() {
    _passcode.dispose();
    _focus.dispose();
    _shake.dispose();
    super.dispose();
  }

  Future<void> _entered() async {
    // Long enough for the last dot to land before the dialog goes.
    await Future<void>.delayed(const Duration(milliseconds: 140));
    if (!mounted || _passcode.text.length != 6) return;

    Navigator.of(context).pop(PayCredential.passcode(_passcode.text));
  }

  Future<void> _useFingerprint() async {
    if (_scanning) return;
    _focus.unfocus();
    setState(() {
      _scanning = true;
      _error = null;
    });

    // A phone without a key, a key the server never registered, or one the phone threw
    // away when its fingerprints changed: each is set up again here, once, exactly as
    // turning fingerprint on in Security would, and the send carries on.
    var enrolled = false;
    Future<bool> enrol() async {
      enrolled = true;
      final enrolment = await AuthSession.instance.enableBiometrics();
      if (enrolment is BiometricEnrolled) return true;
      if (mounted) {
        _refuse(
          enrolment is BiometricRefused
              ? enrolment.reason
              : BiometricUnavailable.platformError,
          resignIn: enrolment is BiometricRefused && enrolment.detail != null,
        );
      }
      return false;
    }

    if (!await AuthSession.instance.hasBiometricKey() && !await enrol()) return;

    while (mounted) {
      final challenge = await widget.challenge();
      if (!mounted) return;
      if (challenge is ApiFailure<String> &&
          challenge.data['field'] == 'biometric' &&
          !enrolled) {
        if (!await enrol()) return;
        continue;
      }
      if (challenge is! ApiSuccess<String> || challenge.value.isEmpty) {
        setState(() {
          _scanning = false;
          _fingerprintFailed = true;
          _error = challenge.messageIn('en');
        });
        return;
      }

      final signed = await AuthSession.instance.biometrics.sign(
        challenge.value,
        title: widget.biometricTitle,
        reason:
            '${widget.verb[0].toUpperCase()}${widget.verb.substring(1)} ${widget.amount} ${widget.preposition} ${widget.name}',
        negative: 'Use passcode',
      );
      if (!mounted) return;

      if (signed is BiometricSigned) {
        Navigator.of(context).pop(PayCredential.fingerprint(signed.signature));
        return;
      }

      final reason = signed is BiometricSignRefused
          ? signed.reason
          : BiometricUnavailable.platformError;
      if (reason == BiometricUnavailable.keyInvalidated && !enrolled) {
        if (!await enrol()) return;
        continue;
      }
      _refuse(reason);
      return;
    }
  }

  void _refuse(BiometricUnavailable reason, {bool resignIn = false}) {
    setState(() {
      _scanning = false;
      _fingerprintFailed = true;
      _error = switch (reason) {
        // They chose the passcode: nothing went wrong.
        BiometricUnavailable.cancelled => null,
        _ when resignIn =>
          'Sign out and in again to use fingerprint on this phone. Use your passcode for now.',
        BiometricUnavailable.keyInvalidated =>
          'The fingerprints on this phone changed. Use your passcode, then turn fingerprint on again in Security.',
        BiometricUnavailable.notEnrolled ||
        BiometricUnavailable.noHardware =>
          'No fingerprint is set up on this phone. Use your passcode.',
        _ => 'Fingerprint isn’t available right now. Use your passcode.',
      };
    });
    if (reason == BiometricUnavailable.cancelled) _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Confirm it’s you',
                        style: _type(20,
                            weight: FontWeight.w600,
                            height: 1.2,
                            letterSpacing: -0.2)),
                  ),
                  IconButton(
                    tooltip: 'Cancel',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded,
                        size: 22, color: _muted),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text.rich(
                  TextSpan(
                    style: _type(13, color: _muted, height: 1.5),
                    children: [
                      TextSpan(
                          text: widget.fingerprint
                              ? 'Use your passcode or fingerprint to ${widget.verb} '
                              : 'Enter your passcode to ${widget.verb} '),
                      TextSpan(
                          text: widget.amount,
                          style: _type(13, weight: FontWeight.w600)),
                      TextSpan(text: ' ${widget.preposition} '),
                      TextSpan(
                          text: widget.name,
                          style: _type(13, weight: FontWeight.w600)),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Passcode', style: _type(13, weight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    _passcodeBoxes(),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      child: _error == null
                          ? const SizedBox(width: double.infinity)
                          : Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.error_outline_rounded,
                                      size: 18, color: _danger),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(_error!,
                                        style: _type(13,
                                            color: _danger, height: 1.4)),
                                  ),
                                ],
                              ),
                            ),
                    ),
                    if (widget.fingerprint) ...[
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(
                              child: Divider(color: _hairline, height: 1)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('or',
                                style: _type(12,
                                    weight: FontWeight.w500, color: _muted)),
                          ),
                          const Expanded(
                              child: Divider(color: _hairline, height: 1)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _fingerprintButton(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fingerprintButton() => Semantics(
        button: true,
        label: 'Use fingerprint',
        child: Material(
          color: Colors.white,
          shape: const StadiumBorder(
              side: BorderSide(color: _hairline, width: 1.2)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: _scanning ? null : _useFingerprint,
            child: SizedBox(
              height: 52,
              child: Center(
                child: _scanning
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.2, color: _ink),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.fingerprint_rounded,
                              size: 24, color: _greenDeep),
                          const SizedBox(width: 10),
                          Text('Use fingerprint',
                              style: _type(15, weight: FontWeight.w600)),
                        ],
                      ),
              ),
            ),
          ),
        ),
      );

  Widget _passcodeBoxes() {
    final typed = _passcode.text.length;

    return AnimatedBuilder(
      animation: _shake,
      builder: (context, child) => Transform.translate(
        offset: Offset(
            math.sin(_shake.value * math.pi * 5) * 8 * (1 - _shake.value), 0),
        child: child,
      ),
      child: Stack(
        children: [
          Row(
            children: [
              for (var i = 0; i < 6; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 140),
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _page,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            _error != null && !_fingerprintFailed && typed == 0
                                ? _danger
                                : i == typed && _focus.hasFocus
                                    ? _ink
                                    : Colors.transparent,
                        width: 1.4,
                      ),
                    ),
                    child: AnimatedScale(
                      scale: i < typed ? 1 : 0,
                      duration: const Duration(milliseconds: 140),
                      curve: Curves.easeOutBack,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                            color: _ink, shape: BoxShape.circle),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          // The real field, invisible over the boxes: the system keyboard, paste and
          // accessibility all work as on any other field. With a fingerprint to offer
          // the keyboard waits for a tap, so both choices stay in view.
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: _passcode,
                focusNode: _focus,
                autofocus: !widget.fingerprint,
                obscureText: true,
                keyboardType: TextInputType.number,
                enableInteractiveSelection: false,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                onChanged: (value) {
                  if (value.length == 6) _entered();
                },
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
