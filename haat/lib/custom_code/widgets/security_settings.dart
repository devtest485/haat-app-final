// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';

/// The passcode and the fingerprint, from inside the app.
///
/// Both used to be offered once, during onboarding, and nowhere after it. A
/// merchant who tapped "Not now", or who signed in to an existing account on
/// a new phone, had no way to turn either on — and so never saw "Login with
/// Passcode" or the fingerprint on the sign-in screen, however long they used
/// the app.
///
/// Shown as a bottom sheet from the home screen, in the same style as the
/// sign-out sheet beside it.
class SecuritySettings extends StatefulWidget {
  const SecuritySettings({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<SecuritySettings> createState() => _SecuritySettingsState();
}

class _SecuritySettingsState extends State<SecuritySettings> {
  final _passcode = TextEditingController();
  final _confirm = TextEditingController();
  final _password = TextEditingController();

  bool _loading = true;
  bool _hasPasscode = false;
  bool _hasFingerprint = false;
  bool _editingPasscode = false;
  bool _busy = false;
  String? _error;
  String? _notice;

  AuthSession get _session => AuthSession.instance;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _passcode.dispose();
    _confirm.dispose();
    _password.dispose();
    super.dispose();
  }

  /// Reads both from their sources of truth: the server for the passcode, the phone
  /// for the fingerprint key. Neither is remembered here.
  Future<void> _load() async {
    await _session.refreshCredentials();
    final hasKey = await _session.hasBiometricKey();
    if (!mounted) return;

    setState(() {
      _hasPasscode = _session.credentials?.hasPasscode ?? false;
      _hasFingerprint = hasKey;
      _loading = false;
    });
  }

  Future<void> _savePasscode() async {
    final passcode = _passcode.text;

    if (!RegExp(r'^\d{6}$').hasMatch(passcode)) {
      setState(() => _error = 'The passcode is six digits.');
      return;
    }
    if (passcode != _confirm.text) {
      setState(() => _error = 'The two passcodes do not match.');
      return;
    }
    if (_hasPasscode && _password.text.isEmpty) {
      setState(() => _error = 'Enter your password to change the passcode.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final result = await _session.setPasscode(
      passcode,
      password: _hasPasscode ? _password.text : null,
    );
    if (!mounted) return;

    if (result.isSuccess) {
      _passcode.clear();
      _confirm.clear();
      _password.clear();
      setState(() {
        _busy = false;
        _editingPasscode = false;
        _notice = _hasPasscode ? 'Passcode changed.' : 'Passcode set.';
        _hasPasscode = true;
      });
      return;
    }

    setState(() {
      _busy = false;
      _error = result.messageIn(_session.languageCode);
    });
  }

  Future<void> _enableFingerprint() async {
    setState(() {
      _busy = true;
      _error = null;
      _notice = null;
    });

    final outcome = await haatEnableBiometrics();
    final hasKey = await _session.hasBiometricKey();
    if (!mounted) return;

    setState(() {
      _busy = false;
      _hasFingerprint = hasKey;
      if (outcome == '') {
        _notice = 'Fingerprint login is on.';
      } else if (outcome != 'CANCELLED') {
        _error = outcome;
      }
    });
  }

  TextStyle _style(double size, FontWeight weight, Color color) =>
      GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color);

  Widget _digits(TextEditingController controller, String hint) => TextField(
        controller: controller,
        obscureText: true,
        keyboardType: TextInputType.number,
        maxLength: 6,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: _style(16, FontWeight.w500, Colors.black),
        decoration: _decoration(hint),
      );

  InputDecoration _decoration(String hint) => InputDecoration(
        hintText: hint,
        counterText: '',
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      );

  Widget _button(String label, VoidCallback? onTap, {bool filled = true}) =>
      InkWell(
        onTap: _busy ? null : onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: filled ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            border: filled ? null : Border.all(color: Colors.black26),
          ),
          child: Text(
            label,
            style: _style(
              14,
              FontWeight.w500,
              filled ? Colors.white : Colors.black,
            ),
          ),
        ),
      );

  Widget _row({
    required IconData icon,
    required String title,
    required String state,
    Widget? action,
  }) =>
      Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFA6E59D), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: _style(15, FontWeight.w500, Colors.black)),
                const SizedBox(height: 2),
                Text(state, style: _style(12, FontWeight.w400, Colors.black54)),
              ],
            ),
          ),
          if (action != null) action,
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
              FlutterFlowTheme.of(context).designToken.radius.sm),
          topRight: Radius.circular(
              FlutterFlowTheme.of(context).designToken.radius.sm),
        ),
      ),
      child: SafeArea(
        top: false,
        child: _loading
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: FlutterFlowTheme.of(context).tertiary,
                    ),
                  ),
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Security',
                    textAlign: TextAlign.center,
                    style: _style(17, FontWeight.w500, Colors.black),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'How you sign back in on this phone.',
                    textAlign: TextAlign.center,
                    style: _style(13, FontWeight.w400, Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  _row(
                    icon: Icons.pin_outlined,
                    title: 'Passcode',
                    state: _hasPasscode
                        ? 'On — "Login with Passcode" is offered'
                        : 'Not set',
                    action: _editingPasscode
                        ? null
                        : _button(
                            _hasPasscode ? 'Change' : 'Set passcode',
                            () => setState(() {
                              _editingPasscode = true;
                              _error = null;
                              _notice = null;
                            }),
                            filled: !_hasPasscode,
                          ),
                  ),
                  if (_editingPasscode) ...[
                    const SizedBox(height: 16),
                    _digits(_passcode, 'New 6-digit passcode'),
                    const SizedBox(height: 10),
                    _digits(_confirm, 'Enter it again'),
                    if (_hasPasscode) ...[
                      const SizedBox(height: 10),
                      TextField(
                        controller: _password,
                        obscureText: true,
                        style: _style(16, FontWeight.w500, Colors.black),
                        decoration: _decoration('Your password'),
                      ),
                    ],
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _button(
                          'Cancel',
                          () => setState(() {
                            _editingPasscode = false;
                            _error = null;
                          }),
                          filled: false,
                        ),
                        const SizedBox(width: 10),
                        _button(_busy ? 'Saving…' : 'Save', _savePasscode),
                      ],
                    ),
                  ],
                  const SizedBox(height: 20),
                  _row(
                    icon: Icons.fingerprint_rounded,
                    title: 'Fingerprint login',
                    state: _hasFingerprint ? 'On for this phone' : 'Off',
                    action: _hasFingerprint
                        ? null
                        : _button('Turn on', _enableFingerprint),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style:
                          _style(13, FontWeight.w500, const Color(0xFFDC0D17)),
                    ),
                  ],
                  if (_notice != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      _notice!,
                      textAlign: TextAlign.center,
                      style:
                          _style(13, FontWeight.w500, const Color(0xFF2E7D32)),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
