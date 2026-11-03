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
import 'package:uuid/uuid.dart';

import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/authorize_dialog.dart';
import '/custom_code/countries.dart';
import '/custom_code/payout_api.dart' show toMinor;
import '/custom_code/transfer_api.dart';
import '/custom_code/wallet_api.dart';
import '/home_screens/add_transfer_funds/payment_review/payment_review_widget.dart';
import '/home_screens/add_transfer_funds/user_info/user_info_widget.dart';
import '/components/no_internet/no_internet_widget.dart';
import '/payment_status/payment_error/payment_error_widget.dart';
import '/payment_status/payment_pending/payment_pending_widget.dart';
import '/payment_status/payment_success/payment_success_widget.dart';

const _ink = Color(0xFF111111);
const _muted = Color(0xFF6B6B72);
const _hairline = Color(0xFFE4E4E9);
const _field = Color(0xFFF5F5F7);
const _danger = Color(0xFFD93025);

/// The field's outline, as on the other transfer screens.
const _outline = Color(0xFFD9D9D9);

/// Sending money to another merchant on HAAT, by `@handle` or by phone number.
///
/// Reached from Transfer › To Username / To Mobile Number, with the amount typed on the
/// screen before. One field: the person is looked up as they are typed, and a handle or
/// number nobody has is said in red under it. Continue names them on a sheet; confirming
/// there opens Review Details, whose Confirm asks for the passcode or fingerprint and
/// sends.
///
/// Nothing here decides who is paid or how much it costs: the server looks the person up
/// again when the money moves, checks the passcode against the lockout and applies the
/// bank's transfer rules. The reference is made once per transfer and kept across a
/// retry after a dropped connection, so the money can never move twice.
class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({
    super.key,
    this.width,
    this.height,
    this.mode,
    this.initialAmount,
  });

  final double? width;
  final double? height;

  /// `username` or `mobile`.
  final String? mode;

  /// The amount typed on the screen before, as typed: `"1250"`.
  final String? initialAmount;

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  late final TransferBy _by =
      widget.mode == 'mobile' ? TransferBy.mobile : TransferBy.username;

  final _to = TextEditingController();
  final _toFocus = FocusNode();

  /// The amount from the screen before, as typed.
  late final String _amount =
      (widget.initialAmount ?? '').replaceAll(',', '').trim();

  Country _country = Country.initial;
  Wallet? _wallet;

  TransferRecipient? _recipient;

  /// The value [_recipient] was found under; anything else typed since is not them.
  String? _foundFor;
  String? _lookupError;
  int _lookups = 0;
  Timer? _debounce;

  /// Continue was tapped and is waiting on the lookup.
  bool _continuing = false;

  String _reference = const Uuid().v4();
  TransferReceipt? _receipt;

  /// A send that did not go through, shown in place of the form until Retry.
  _Failure? _failure;

  @override
  void initState() {
    super.initState();
    _to.addListener(_onToChanged);
    _loadWallet();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _to.dispose();
    _toFocus.dispose();
    super.dispose();
  }

  Future<void> _loadWallet() async {
    final result = await AuthSession.instance.wallet.get();
    if (!mounted) return;
    if (result is ApiSuccess<Wallet>) setState(() => _wallet = result.value);
  }

  // ── Who ──────────────────────────────────────────────────────────────────────────

  String get _value => _by == TransferBy.username
      ? _to.text.trim().replaceFirst(RegExp(r'^@+'), '').toLowerCase()
      : _country.toE164(_to.text);

  bool get _valueComplete => _by == TransferBy.username
      ? RegExp(r'^[a-z0-9._]{3,30}$').hasMatch(_value)
      : _country.isPlausible(_to.text);

  bool get _found => _recipient != null && _foundFor == _value;

  String? _lastValue;

  void _onToChanged() {
    final value = _value;
    if (value == _lastValue) return;
    _lastValue = value;

    _debounce?.cancel();
    _lookups++;
    setState(() {
      _lookupError = null;
      if (_foundFor != value) _recipient = null;
    });

    if (!_valueComplete) return;
    _debounce = Timer(const Duration(milliseconds: 550), _lookup);
  }

  Future<void> _lookup() async {
    final value = _value;
    final ticket = ++_lookups;

    final result = await AuthSession.instance.transfers
        .findRecipient(by: _by, value: value);
    if (!mounted || ticket != _lookups) return;

    setState(() {
      if (result is ApiSuccess<TransferRecipient>) {
        _recipient = result.value;
        _foundFor = value;
        _reference = const Uuid().v4();
      } else {
        _recipient = null;
        _lookupError = result.errorCode == 'NOT_FOUND'
            ? (_by == TransferBy.username
                ? 'This username doesn’t exist.'
                : 'No HAAT account uses this number.')
            : result.messageIn('en');
      }
    });
  }

  // ── How much ─────────────────────────────────────────────────────────────────────

  String get _currency => _wallet?.currency ?? 'SDG';

  BigInt? get _minor => toMinor(_amount, _currency);

  bool get _overBalance {
    final minor = _minor;
    final wallet = _wallet;
    return minor != null && wallet != null && minor > wallet.available;
  }

  String _money(BigInt minor, [String? currency]) {
    final code = currency ?? _currency;
    final (whole, fraction) = splitMinor(minor, code);

    return '$code $whole$fraction';
  }

  // ── Send ─────────────────────────────────────────────────────────────────────────

  String get _via {
    final recipient = _recipient;
    return _by == TransferBy.username
        ? '@${recipient?.username ?? _value}'
        : (recipient?.mobileMasked ?? _value);
  }

  /// The person on a sheet; confirming them opens Review Details.
  Future<void> _continue() async {
    if (_continuing || !_valueComplete || _minor == null) return;
    FocusScope.of(context).unfocus();

    if (!_found) {
      _debounce?.cancel();
      setState(() => _continuing = true);
      await _lookup();
      if (!mounted) return;
      setState(() => _continuing = false);
    }
    final recipient = _recipient;
    if (!_found || recipient == null) return;

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x66000000),
      builder: (sheet) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          UserInfoWidget(
            name: recipient.name,
            subtitle: 'HAAT account · $_via',
            onConfirm: () async => Navigator.of(sheet).pop(true),
          ),
          // The sheet carries on under the gesture bar.
          Container(
            height: MediaQuery.paddingOf(sheet).bottom,
            color: FlutterFlowTheme.of(sheet).secondaryBackground,
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await _review(recipient, _minor!);
  }

  /// Review Details; confirming it sends.
  Future<void> _review(TransferRecipient recipient, BigInt minor) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaymentReviewWidget(
          senderName: FFAppState().displayName.isEmpty
              ? 'You'
              : FFAppState().displayName,
          receiverName: '${recipient.name} · $_via',
          amount: _money(minor),
          fees: 'Set by your bank, shown on the receipt',
          error: _overBalance
              ? 'More than you have available: ${_money(_wallet!.available)}.'
              : null,
          onConfirm: () => _send(recipient, minor),
        ),
      ),
    );
  }

  /// The passcode or fingerprint, then the send. A credential the server refuses
  /// brings the dialog back with the reason; anything else is answered to Review
  /// Details to show. On success the receipt replaces everything above this screen.
  Future<String?> _send(TransferRecipient recipient, BigInt minor) async {
    // Offered wherever the phone can do it; a key it lacks is made when it is used.
    final fingerprint =
        await AuthSession.instance.biometrics.availability() == null;
    final amount = _money(minor);
    String? refusal;

    while (mounted) {
      final credential = await _authorize(
        amount: amount,
        name: recipient.name,
        minor: minor,
        fingerprint: fingerprint,
        error: refusal,
      );
      if (!mounted || credential == null) return null;

      final result = await AuthSession.instance.transfers.send(
        by: _by,
        value: _value,
        amountMinor: minor,
        currency: _currency,
        reference: _reference,
        passcode: credential.passcode,
        biometricSignature: credential.signature,
      );
      if (!mounted) return null;

      if (result is ApiSuccess<TransferReceipt>) {
        HapticFeedback.mediumImpact();
        WalletBalance.refreshNow();
        _showInPlace(() => _receipt = result.value);
        return null;
      }

      final reference = _reference;
      if (result is ApiFailure<TransferReceipt>) {
        final field = result.data['field'];
        // A refused credential keeps the reference — the check comes before anything
        // moves, and a fingerprint retried after a dropped answer must find the same
        // send.
        if (field == 'passcode' || field == 'biometric') {
          refusal = result.messageIn('en');
          continue;
        }
        // Any other refusal means nothing was made: the next attempt is a new send.
        _reference = const Uuid().v4();
      }
      // A dropped connection keeps the reference, so a retry cannot send twice.
      HapticFeedback.heavyImpact();
      _showInPlace(() => _failure = _Failure(
            recipient: recipient,
            minor: minor,
            reference: reference,
            reason: result.messageIn('en'),
            offline: result is ApiUnreachable<TransferReceipt>,
            at: DateTime.now(),
          ));
      return null;
    }
    return null;
  }

  /// Closes Review Details and anything over it, and shows the outcome here.
  void _showInPlace(VoidCallback outcome) {
    final self = ModalRoute.of(context);
    Navigator.of(context).popUntil((route) => route == self);
    setState(outcome);
  }

  /// Back to Review Details for the same person and amount.
  Future<void> _retry(_Failure failure) async {
    setState(() => _failure = null);
    await _review(failure.recipient, failure.minor);
  }

  Future<PayCredential?> _authorize({
    required String amount,
    required String name,
    required BigInt minor,
    required bool fingerprint,
    String? error,
  }) =>
      showAuthorizeDialog(
        context,
        amount: amount,
        name: name,
        fingerprint: fingerprint,
        error: error,
        // Read when the fingerprint is used, so it names the reference then in force.
        challenge: () => AuthSession.instance.transfers.challenge(
          by: _by,
          value: _value,
          amountMinor: minor,
          currency: _currency,
          reference: _reference,
        ),
      );

  void _done() => Navigator.of(context).popUntil((route) => route.isFirst);

  /// The receipt as lines, in the order the success screen lists them.
  List<(String, String)> _receiptLines(TransferReceipt receipt) => [
        if (receipt.recipientUsername != null)
          ('Username', '@${receipt.recipientUsername}'),
        if (receipt.recipientMobileMasked != null)
          ('Mobile number', receipt.recipientMobileMasked!),
        if (receipt.feeMinor > BigInt.zero) ...[
          ('Fee', _money(receipt.feeMinor, receipt.currency)),
          ('Total from wallet', _money(receipt.totalMinor, receipt.currency)),
        ],
        if (receipt.note != null && receipt.note!.trim().isNotEmpty)
          ('Note', receipt.note!.trim()),
        (
          'Reference number',
          receipt.transactionId.split('-').first.toUpperCase()
        ),
        ('Date & time', dateTimeFormat('d MMM y · HH:mm', receipt.occurredAt)),
      ];

  /// No share sheet in the app yet, so the receipt goes to the clipboard to paste
  /// wherever it is needed.
  Future<void> _shareReceipt(TransferReceipt receipt) => _copy([
        'HAAT transfer',
        'Sent ${_money(receipt.amountMinor, receipt.currency)} to ${receipt.recipientName}',
        for (final (label, value) in _receiptLines(receipt)) '$label: $value',
      ]);

  Future<void> _copy(List<String> lines) async {
    await Clipboard.setData(ClipboardData(text: lines.join('\n')));
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Receipt copied')));
  }

  Widget _success(TransferReceipt receipt) {
    final (whole, fraction) = splitMinor(receipt.amountMinor, receipt.currency);

    return PaymentSuccessWidget(
      key: ValueKey(receipt.transactionId),
      title: 'Money sent',
      amount: '$whole$fraction',
      currency: receipt.currency,
      subtitle: '${receipt.recipientName} · HAAT transfer',
      details: _receiptLines(receipt),
      onDone: () async => _done(),
      onShare: () => _shareReceipt(receipt),
    );
  }

  String _shortReference(String id) => id.split('-').first.toUpperCase();

  /// Held for HAAT to approve: the money is set aside, and the bell says when it moves.
  Widget _pending(TransferReceipt receipt) {
    final lines = [
      ('Amount', _money(receipt.amountMinor, receipt.currency)),
      if (receipt.feeMinor > BigInt.zero)
        ('Fee', _money(receipt.feeMinor, receipt.currency)),
      ('From', 'HAAT wallet'),
      (
        'To Account',
        receipt.recipientUsername != null
            ? '@${receipt.recipientUsername}'
            : (receipt.recipientMobileMasked ?? _via)
      ),
      ('Reference number', _shortReference(receipt.transactionId)),
      ('Receiver Name', receipt.recipientName),
      ('Date & Time', dateTimeFormat('d MMM y · HH:mm', receipt.occurredAt)),
    ];

    return PaymentPendingWidget(
      key: ValueKey('pending-${receipt.transactionId}'),
      details: lines,
      primaryLabel: 'Remind me once processed',
      onPrimary: () async {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(
            content: Text('You will be notified once HAAT approves it.'),
          ));
        _done();
      },
      onShare: () => _copy([
        'HAAT transfer, waiting for approval',
        for (final (label, value) in lines) '$label: $value',
      ]),
    );
  }

  /// A send that did not go through: refused, or the held one turned down.
  Widget _error({
    required BigInt minor,
    required String currency,
    required String reference,
    required DateTime at,
    required String? reason,
    required Future<void> Function() onRetry,
  }) =>
      PaymentErrorWidget(
        key: ValueKey('error-$reference'),
        details: [
          ('Amount', _money(minor, currency)),
          ('Reference number', _shortReference(reference)),
          ('Date & Time', dateTimeFormat('d MMM y · HH:mm', at)),
          if (reason != null && reason.trim().isNotEmpty)
            ('Reason', reason.trim()),
        ],
        onRetry: onRetry,
      );

  /// The form, or how the send ended.
  Widget _outcome(BuildContext context) {
    final receipt = _receipt;
    if (receipt != null) {
      if (receipt.isHeld) return _pending(receipt);
      if (!receipt.isRejected) return _success(receipt);

      return _error(
        minor: receipt.amountMinor,
        currency: receipt.currency,
        reference: receipt.transactionId,
        at: receipt.occurredAt,
        reason: receipt.reason,
        onRetry: () async => setState(() {
          _receipt = null;
          _reference = const Uuid().v4();
        }),
      );
    }

    final failure = _failure;
    if (failure == null) return _form(context);
    if (failure.offline) {
      return NoInternetWidget(
        key: const ValueKey('offline'),
        onRetry: () => _retry(failure),
      );
    }

    return _error(
      minor: failure.minor,
      currency: _currency,
      reference: failure.reference,
      at: failure.at,
      reason: failure.reason,
      onRetry: () => _retry(failure),
    );
  }

  // ── Layout ───────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        // The button stays at the bottom, under the keyboard, not riding on it.
        resizeToAvoidBottomInset: false,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: _outcome(context),
        ),
      ),
    );
  }

  /// Laid out like the other transfer screens: the grey header, a back arrow, the
  /// title over its line, one labelled field, and Continue at the bottom.
  Widget _form(BuildContext context) {
    final username = _by == TransferBy.username;

    return GestureDetector(
      key: const ValueKey('form'),
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 162,
            child:
                Image.asset('assets/images/GrayPageBg.png', fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                        bottom: 24 + MediaQuery.viewInsetsOf(context).bottom),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 67),
                        Semantics(
                          button: true,
                          label: 'Back',
                          child: InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () => Navigator.of(context).maybePop(),
                            child: const Icon(Icons.arrow_back,
                                color: Colors.black, size: 24),
                          ),
                        ),
                        const SizedBox(height: 19),
                        Text(
                          username ? 'Enter Username' : 'Enter mobile number',
                          style: _type(30,
                              weight: FontWeight.w600, color: Colors.black),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          username
                              ? 'Please enter the HAAT username'
                              : 'Please enter the HAAT mobile number',
                          style: _type(12,
                              weight: FontWeight.w500,
                              color: Colors.black,
                              height: 1.4),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          username ? 'Username' : 'Wallet Mobile Number',
                          style: _type(13,
                              weight: FontWeight.w500, color: Colors.black),
                        ),
                        const SizedBox(height: 13),
                        username ? _usernameField() : _mobileField(),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          alignment: Alignment.topCenter,
                          child: _lookupError == null
                              ? const SizedBox(width: double.infinity)
                              : Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    _lookupError!,
                                    style: _type(12.5,
                                        weight: FontWeight.w500,
                                        color: _danger,
                                        height: 1.4),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      15, 0, 15, 35 + MediaQuery.paddingOf(context).bottom / 2),
                  child: _primaryButton(
                    label: 'Continue',
                    enabled: _valueComplete &&
                        _minor != null &&
                        _lookupError == null,
                    busy: _continuing,
                    onTap: _continue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// The outlined white box every field on these screens sits in.
  Widget _box({required Widget child}) => Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _outline),
        ),
        alignment: Alignment.center,
        child: child,
      );

  Widget _usernameField() => _box(
        child: _input(
          hint: 'Enter username',
          keyboard: TextInputType.visiblePassword,
          formatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[@a-zA-Z0-9._]')),
            LengthLimitingTextInputFormatter(31),
          ],
          prefix: Padding(
            padding: const EdgeInsetsDirectional.only(start: 14, end: 2),
            child: Text('@',
                style: _type(14, weight: FontWeight.w600, color: Colors.black)),
          ),
        ),
      );

  Widget _mobileField() => Row(
        children: [
          Semantics(
            button: true,
            label: 'Country, ${_country.name} ${_country.dial}',
            child: Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: _outline),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: _pickCountry,
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_country.flag, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(_country.dial,
                          style: _type(14,
                              weight: FontWeight.w500, color: Colors.black)),
                      const SizedBox(width: 2),
                      const Icon(Icons.keyboard_arrow_down_rounded,
                          size: 18, color: _muted),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _box(
              child: _input(
                hint: 'Enter your phone',
                keyboard: TextInputType.phone,
                formatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
                  LengthLimitingTextInputFormatter(17),
                ],
              ),
            ),
          ),
        ],
      );

  Future<void> _pickCountry() async {
    final picked = await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: const Color(0x66000000),
      builder: (_) => _CountrySheet(selected: _country),
    );
    if (picked == null || !mounted) return;

    setState(() => _country = picked);
    _lastValue = null;
    _onToChanged();
    _toFocus.requestFocus();
  }

  Widget _input({
    required String hint,
    TextInputType keyboard = TextInputType.text,
    List<TextInputFormatter> formatters = const [],
    Widget? prefix,
  }) =>
      TextField(
        controller: _to,
        focusNode: _toFocus,
        keyboardType: keyboard,
        autocorrect: false,
        enableSuggestions: false,
        inputFormatters: formatters,
        onSubmitted: (_) => _continue(),
        style: _type(14, weight: FontWeight.w600, color: Colors.black),
        cursorColor: Colors.black,
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          hintStyle: _type(14, color: const Color(0x66000000)),
          prefixIcon: prefix,
          prefixIconConstraints: const BoxConstraints(minWidth: 0),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: InputBorder.none,
        ),
      );
}

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

Widget _primaryButton({
  required String label,
  required bool enabled,
  required VoidCallback onTap,
  bool busy = false,
}) =>
    Semantics(
      button: true,
      enabled: enabled,
      child: GestureDetector(
        onTap: enabled && !busy ? onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: enabled ? Colors.black : const Color(0x28000000),
            borderRadius: BorderRadius.circular(106.67),
          ),
          child: busy
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.2, color: Colors.white),
                )
              : Text(label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                      _type(18, weight: FontWeight.w600, color: Colors.white)),
        ),
      ),
    );

/// Every country, searchable by name, code or dial code.
class _CountrySheet extends StatefulWidget {
  const _CountrySheet({required this.selected});

  final Country selected;

  @override
  State<_CountrySheet> createState() => _CountrySheetState();
}

class _CountrySheetState extends State<_CountrySheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final countries =
        Country.all.where((country) => country.matches(_query)).toList();
    final height = MediaQuery.sizeOf(context).height * 0.82;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: _hairline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text('Choose country',
                        style: _type(18, weight: FontWeight.w600)),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: _ink),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                autofocus: false,
                onChanged: (value) => setState(() => _query = value),
                style: _type(15, weight: FontWeight.w500),
                cursorColor: _ink,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Search country or code',
                  hintStyle: _type(15, color: const Color(0x66000000)),
                  prefixIcon: const Icon(Icons.search_rounded, color: _muted),
                  filled: true,
                  fillColor: _field,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: countries.isEmpty
                  ? Center(
                      child: Text('No country matches “$_query”.',
                          style: _type(14, color: _muted)),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.paddingOf(context).bottom + 12),
                      itemCount: countries.length,
                      itemBuilder: (context, index) {
                        final country = countries[index];
                        final chosen = country.iso == widget.selected.iso;

                        return InkWell(
                          onTap: () => Navigator.of(context).pop(country),
                          child: Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            color: chosen ? const Color(0x0F000000) : null,
                            child: Row(
                              children: [
                                Text(country.flag,
                                    style: const TextStyle(fontSize: 22)),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(country.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: _type(15,
                                          weight: chosen
                                              ? FontWeight.w600
                                              : FontWeight.w500)),
                                ),
                                Text(country.dial,
                                    style: _type(14,
                                        weight: FontWeight.w500,
                                        color: _muted)),
                                if (chosen) ...[
                                  const SizedBox(width: 10),
                                  const Icon(Icons.check_rounded,
                                      size: 18, color: _ink),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A send that did not go through, and what Retry needs to try it again.
class _Failure {
  const _Failure({
    required this.recipient,
    required this.minor,
    required this.reference,
    required this.reason,
    required this.offline,
    required this.at,
  });

  final TransferRecipient recipient;
  final BigInt minor;

  /// The reference it was tried under. Kept for a retry when HAAT was not reached.
  final String reference;
  final String reason;

  /// HAAT was never reached: nothing to explain but the connection.
  final bool offline;
  final DateTime at;
}

