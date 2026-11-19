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

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '/app_state.dart';
import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/bank_link_api.dart';
import '/custom_code/bank_link_flow.dart';

enum _Step { details, code, choose, confirm }

/// Linking the business's account at SIB, start to finish, on one screen.
///
/// Five things happen, in this order: the person types the customer or account number
/// and the phone the bank has on file; the bank sends a code to that phone and they type
/// it back; when the customer number has several accounts they choose which one to link;
/// the bank's details are shown back to be confirmed; and the account is linked, which the
/// last screen says.
///
/// It is drawn white when it is opened from the Transfer sheet and black when it is
/// opened from the verification step, which is what [light] says. Where it goes next is
/// not its business: choosing a country, going back, an account that was not found and
/// being done are the page's own actions.
class SaibLinkFlow extends StatefulWidget {
  const SaibLinkFlow({
    super.key,
    this.width,
    this.height,
    this.light,
    this.onPickCountry,
    this.onBack,
    this.onNotFound,
    this.onDone,
  });

  final double? width;
  final double? height;

  /// True for the white screens, false for the black ones.
  final bool? light;

  /// Opens the country sheet. The choice is left in App State (`saibCountry`).
  final Future Function()? onPickCountry;

  /// The arrow on the first screen: back to where this was opened from.
  final Future Function()? onBack;

  /// A number the bank does not know, on the black screens, which have a page for it.
  final Future Function()? onNotFound;

  /// Linked, and the person pressed Continue.
  final Future Function()? onDone;

  @override
  State<SaibLinkFlow> createState() => _SaibLinkFlowState();
}

class _SaibLinkFlowState extends State<SaibLinkFlow> {
  final _number = TextEditingController();
  final _phone = TextEditingController();

  _Step _step = _Step.details;
  bool _linked = false;
  bool _busy = false;

  /// Under the field it belongs to: the number, the code, or the account chosen.
  String _error = '';

  String _mobile = '';
  String _mobileMasked = '';
  String _devCode = '';
  String _code = '';
  bool _codeWrong = false;
  int _secondsLeft = 30;
  Timer? _timer;

  BankLinkDetails? _details;
  String _chosen = '';

  bool get _light => widget.light ?? false;

  @override
  void initState() {
    super.initState();
    for (final field in [_number, _phone]) {
      field.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _number.dispose();
    _phone.dispose();
    super.dispose();
  }

  // ── The country ───────────────────────────────────────────────────────────────

  String _countryField(String field) {
    const sudan = {'dialCode': '249', 'flag': '🇸🇩'};
    final chosen = FFAppState().saibCountry;
    final value = chosen is Map ? '${chosen[field] ?? ''}'.trim() : '';

    return value.isEmpty || value == 'null' ? (sudan[field] ?? '') : value;
  }

  String get _dial => _countryField('dialCode').replaceAll(RegExp(r'\D'), '');

  String get _typedMobile {
    final digits = _phone.text
        .replaceAll(RegExp(r'\D'), '')
        .replaceFirst(RegExp(r'^0+'), '');

    return '+$_dial$digits';
  }

  Future<void> _pickCountry() async {
    await widget.onPickCountry?.call();
    if (mounted) setState(() {});
  }

  // ── The steps ─────────────────────────────────────────────────────────────────

  bool get _canAsk =>
      _number.text.replaceAll(RegExp(r'\D'), '').length >= 6 &&
      _phone.text.replaceAll(RegExp(r'\D'), '').length >= 6;

  Future<void> _ask({bool again = false}) async {
    if (_busy) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = '';
    });

    final number = _number.text.replaceAll(RegExp(r'\D'), '');
    final mobile = again ? _mobile : _typedMobile;
    final result = await AuthSession.instance.bankLinks.request(number, mobile);
    if (!mounted) return;

    final challenge = result.valueOrNull;
    if (challenge == null) {
      final notFound = result.errorCode == 'NOT_FOUND';
      setState(() {
        _busy = false;
        _error = BankLinkFlow.explain(result);
      });
      // The black screens have a page of their own for a number the bank does not know.
      if (notFound && !_light && widget.onNotFound != null) {
        await widget.onNotFound!.call();
      }
      return;
    }

    setState(() {
      _busy = false;
      _mobile = mobile;
      _mobileMasked = challenge.mobileMasked;
      _devCode = challenge.devOtpCode;
      _codeWrong = false;
      _code = '';
      _step = _Step.code;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = 30);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      setState(() => _secondsLeft = (_secondsLeft - 1).clamp(0, 30));
      if (_secondsLeft == 0) timer.cancel();
    });
  }

  Future<void> _resend() async {
    if (_busy || _secondsLeft > 0) return;
    await _ask(again: true);
  }

  Future<void> _verify() async {
    if (_busy || _code.length != 6) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _busy = true;
      _error = '';
      _codeWrong = false;
    });

    final number = _number.text.replaceAll(RegExp(r'\D'), '');
    final result =
        await AuthSession.instance.bankLinks.verify(number, _mobile, _code);
    if (!mounted) return;

    final details = result.valueOrNull;
    if (details == null) {
      setState(() {
        _busy = false;
        _codeWrong = true;
        _error = BankLinkFlow.explain(result);
      });
      return;
    }

    _timer?.cancel();
    setState(() {
      _busy = false;
      _details = details;
      _chosen = details.accounts.length == 1 ? details.accounts.first.id : '';
      // One account is not a question: the details come next. Several are.
      _step = details.accounts.length > 1 ? _Step.choose : _Step.confirm;
    });
  }

  Future<void> _link() async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _error = '';
    });

    final number = _number.text.replaceAll(RegExp(r'\D'), '');
    final result = await AuthSession.instance.bankLinks
        .confirm(number, _mobile, accountId: _chosen);
    if (!mounted) return;

    if (!result.isSuccess) {
      setState(() {
        _busy = false;
        _error = BankLinkFlow.explain(result);
      });
      return;
    }

    await BankLinkFlow.refresh(force: true);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _linked = true;
    });
  }

  Future<void> _back() async {
    FocusScope.of(context).unfocus();
    switch (_step) {
      case _Step.details:
        await widget.onBack?.call();
      case _Step.code:
        _timer?.cancel();
        setState(() {
          _step = _Step.details;
          _error = '';
        });
      case _Step.choose:
      case _Step.confirm:
        // The code was spent on the way here: asking again is the way back.
        setState(() {
          _step = _Step.details;
          _error = '';
        });
    }
  }

  // ── Look ──────────────────────────────────────────────────────────────────────

  Color get _bg => _light ? const Color(0xFFF4F4F6) : Colors.black;
  Color get _ink => _light ? const Color(0xFF111111) : Colors.white;
  Color get _soft => _light ? const Color(0xFF6B6B6B) : const Color(0xFFBDBDBD);
  Color get _field => _light ? Colors.white : const Color(0xFF222222);
  Color get _fieldLine =>
      _light ? const Color(0xFFE3E5E9) : const Color(0xFF262626);
  Color get _go => _light ? Colors.black : Colors.white;
  Color get _goInk => _light ? Colors.white : Colors.black;
  Color get _off => _light ? const Color(0xFFCFCFD4) : const Color(0xFF262626);
  Color get _offInk => _light ? Colors.white : const Color(0xFF6F6F6F);
  static const _bad = Color(0xFFE5484D);

  TextStyle _text(double size,
          {FontWeight weight = FontWeight.w400,
          Color? color,
          double? height}) =>
      GoogleFonts.montserrat(
        fontSize: size,
        fontWeight: weight,
        color: color ?? _ink,
        height: height,
      );

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return Container(
      width: widget.width ?? double.infinity,
      height: widget.height ?? double.infinity,
      color: _bg,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            height: 162,
            child: Image.asset(
              _light
                  ? 'assets/images/GrayPageBg.png'
                  : 'assets/images/GreenPageBg.png',
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              SizedBox(height: top + (_light ? 16 : 10)),
              if (!_light) _progress(),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
                child: Row(
                  children: [
                    InkWell(
                      onTap: _back,
                      child: Icon(Icons.arrow_back, color: _ink, size: 24),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(15, 19, 15, 24),
                  child: switch (_step) {
                    _Step.details => _detailsStep(),
                    _Step.code => _codeStep(),
                    _Step.choose => _chooseStep(),
                    _Step.confirm => _confirmStep(),
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 35),
                child: _continue(),
              ),
            ],
          ),
          if (_linked) _linkedScreen(),
        ],
      ),
    );
  }

  /// Five bars, the first four lit — the sign-up steps this belongs to — and all five
  /// once the details are confirmed.
  Widget _progress() {
    final lit = _step == _Step.confirm ? 5 : 4;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          for (var i = 0; i < 5; i++)
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: i < lit ? Colors.white : const Color(0x33FFFFFF),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _heading(String title, String subtitle) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _text(24, weight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(subtitle, style: _text(12, color: _soft, height: 1.4)),
        ],
      );

  // ── Number and phone ──────────────────────────────────────────────────────────

  Widget _detailsStep() {
    final wrong = _error.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heading(
            'Link your SIB account', 'Enter the details registered with SIB.'),
        const SizedBox(height: 24),
        Text('CIF or account number',
            style: _text(13, weight: FontWeight.w500)),
        const SizedBox(height: 10),
        _input(
          _number,
          hint: 'Enter your CIF or account number',
          maxLength: 12,
          error: wrong,
        ),
        if (wrong) ...[
          const SizedBox(height: 8),
          Text(_error, style: _text(12, color: _bad, height: 1.4)),
        ],
        const SizedBox(height: 20),
        Text('Mobile number', style: _text(13, weight: FontWeight.w500)),
        const SizedBox(height: 10),
        Row(
          children: [
            InkWell(
              onTap: _pickCountry,
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: _field,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _fieldLine),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_countryField('flag'),
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 8),
                    Text('+$_dial', style: _text(13, weight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _input(_phone, hint: 'Enter your phone', maxLength: 12),
            ),
          ],
        ),
      ],
    );
  }

  Widget _input(
    TextEditingController controller, {
    required String hint,
    required int maxLength,
    bool error = false,
  }) =>
      Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: _field,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: error ? _bad : _fieldLine),
        ),
        alignment: Alignment.center,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(maxLength),
          ],
          cursorColor: _ink,
          style: _text(14, weight: FontWeight.w500),
          onChanged: (_) {
            if (_error.isNotEmpty) setState(() => _error = '');
          },
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            hintText: hint,
            hintStyle: _text(14, color: _soft.withValues(alpha: 0.7)),
          ),
        ),
      );

  // ── The code ──────────────────────────────────────────────────────────────────

  String get _maskedPhone {
    final last = _mobileMasked.length >= 4
        ? _mobileMasked.substring(_mobileMasked.length - 4)
        : _mobileMasked;

    return '+$_dial ··· ··· $last';
  }

  Widget _codeStep() {
    final clock = '00:${_secondsLeft.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heading('6-digit code', 'Enter the code SIB sent to $_maskedPhone'),
        const SizedBox(height: 24),
        SizedBox(
          height: 62,
          child: OtpVerify(
            width: double.infinity,
            height: 62,
            autoFocus: true,
            useLightStyle: _light,
            hasError: _codeWrong,
            onChanged: (value) async {
              setState(() {
                _code = value;
                _codeWrong = false;
                _error = '';
              });
            },
            onCompleted: (complete) async {},
          ),
        ),
        if (_codeWrong) ...[
          const SizedBox(height: 8),
          Text(_error, style: _text(12, color: _bad)),
        ] else if (_devCode.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text('Development code: $_devCode', style: _text(13)),
        ],
        const SizedBox(height: 16),
        _secondsLeft > 0
            ? Text('Resend code in $clock',
                style: _text(12, weight: FontWeight.w500))
            : InkWell(
                onTap: _resend,
                child: Text(
                  'Resend code',
                  style: _text(13, weight: FontWeight.w600).copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
        if (!_codeWrong && _error.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(_error, style: _text(12, color: _bad)),
        ],
      ],
    );
  }

  // ── Which account ─────────────────────────────────────────────────────────────

  Widget _chooseStep() {
    final accounts = _details?.accounts ?? const <BankLinkChoice>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heading(
          'Choose an account',
          'We found ${accounts.length} accounts under your CIF. Please choose one account to link to HAAT.',
        ),
        const SizedBox(height: 24),
        for (final account in accounts) ...[
          InkWell(
            onTap: () => setState(() => _chosen = account.id),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: _field,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _chosen == account.id ? _ink : _fieldLine,
                  width: _chosen == account.id ? 1.4 : 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${account.label} · ${account.accountMasked.replaceFirst('····', '···')}',
                      style: _text(13, weight: FontWeight.w500),
                    ),
                  ),
                  _radio(_chosen == account.id),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
        if (_error.isNotEmpty) Text(_error, style: _text(12, color: _bad)),
      ],
    );
  }

  Widget _radio(bool on) => Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: on ? _ink : Colors.transparent,
          border: Border.all(color: on ? _ink : _soft),
        ),
        child: on ? Icon(Icons.check, size: 14, color: _bg) : null,
      );

  // ── What the bank holds ───────────────────────────────────────────────────────

  Widget _confirmStep() {
    final details = _details;
    final account = details?.accounts.where((a) => a.id == _chosen).firstOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _heading(
            'Confirm your details', 'This is what SIB has on file for you.'),
        const SizedBox(height: 24),
        _fact('Full name', details?.holderName ?? '—'),
        _fact('ID number',
            (details?.idMasked ?? '').isEmpty ? '—' : details!.idMasked),
        _fact('Mobile number', _maskedPhone),
        _fact(
            'Business name',
            (details?.businessName ?? '').isEmpty
                ? '—'
                : details!.businessName),
        if (account != null)
          _fact('Account', '${account.label} · ${account.accountMasked}'),
        if (_error.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(_error, style: _text(12, color: _bad)),
        ],
      ],
    );
  }

  Widget _fact(String label, String value) => Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: _field,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: _text(15, weight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(value, style: _text(12, color: _soft)),
          ],
        ),
      );

  // ── The button ────────────────────────────────────────────────────────────────

  bool get _ready => switch (_step) {
        _Step.details => _canAsk,
        _Step.code => _code.length == 6,
        _Step.choose => _chosen.isNotEmpty,
        _Step.confirm => true,
      };

  String get _label {
    if (_busy) {
      return switch (_step) {
        _Step.confirm => 'Linking…',
        _ => 'Checking…',
      };
    }

    return 'Continue';
  }

  Widget _continue() {
    final on = _ready && !_busy;

    return InkWell(
      onTap: !on
          ? null
          : switch (_step) {
              _Step.details => () => _ask(),
              _Step.code => _verify,
              _Step.choose => () => setState(() {
                    _step = _Step.confirm;
                    _error = '';
                  }),
              _Step.confirm => _link,
            },
      borderRadius: BorderRadius.circular(106),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: _ready ? _go : _off,
          borderRadius: BorderRadius.circular(106),
        ),
        alignment: Alignment.center,
        child: Text(
          _label,
          style: _text(18,
              weight: FontWeight.w600, color: _ready ? _goInk : _offInk),
        ),
      ),
    );
  }

  // ── Linked ────────────────────────────────────────────────────────────────────

  Widget _linkedScreen() => Positioned.fill(
        child: Container(
          color: Colors.black,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 128,
                      height: 128,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 128,
                            height: 128,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF0E6B3E),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset(
                              'assets/images/AminBank.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: -2,
                            bottom: 4,
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.black, width: 3),
                              ),
                              child: const Icon(Icons.check_rounded,
                                  size: 20, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Link your SIB account',
                      textAlign: TextAlign.center,
                      style: _text(22,
                          weight: FontWeight.w600, color: Colors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(48, 12, 48, 0),
                      child: Text(
                        'You can now transfer money from HAAT to your SIB account.',
                        textAlign: TextAlign.center,
                        style: _text(14,
                            color: const Color(0xFFBDBDBD), height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 35),
                child: InkWell(
                  onTap: () => widget.onDone?.call(),
                  borderRadius: BorderRadius.circular(106),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(106),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Continue',
                      style: _text(18,
                          weight: FontWeight.w600, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
