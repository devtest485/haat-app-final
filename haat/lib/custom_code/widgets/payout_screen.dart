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

import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/payout_api.dart';
import '/custom_code/wallet_api.dart';

/// Sending the business's available money to its own bank account.
///
/// Reached from Transfer › To my bank account, with the amount already typed. The
/// design's transfer screens found the receiver by a bank lookup that does not exist
/// yet, so the account is asked for here instead: the bank, the name on the account,
/// and its number.
///
/// Asking sets the amount and HAAT's fee aside at once; HAAT sends it and records the
/// bank's reference. The list underneath is every payout so far, and one still waiting
/// can be withdrawn.
///
/// The reference is made once per payout and kept until it succeeds, so tapping Send
/// again after a timeout asks once rather than setting the money aside twice.
class PayoutScreen extends StatefulWidget {
  const PayoutScreen({super.key, this.width, this.height, this.initialAmount});

  final double? width;
  final double? height;

  /// The amount typed on the screen before, as typed: `"740.50"`.
  final String? initialAmount;

  @override
  State<PayoutScreen> createState() => _PayoutScreenState();
}

class _PayoutScreenState extends State<PayoutScreen> {
  final _amount = TextEditingController();
  final _bank = TextEditingController();
  final _name = TextEditingController();
  final _number = TextEditingController();
  final _note = TextEditingController();

  List<WalletLine>? _lines;
  WalletLine? _from;
  List<Payout>? _payouts;

  bool _sending = false;
  String? _error;
  Payout? _asked;
  String _reference = const Uuid().v4();

  @override
  void initState() {
    super.initState();
    _amount.text = (widget.initialAmount ?? '').replaceAll(',', '').trim();
    for (final field in [_amount, _bank, _name, _number]) {
      field.addListener(() => setState(() {}));
    }
    _load();
  }

  @override
  void dispose() {
    for (final field in [_amount, _bank, _name, _number, _note]) {
      field.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    final session = AuthSession.instance;
    final wallet = await session.wallet.get();
    final payouts = await session.payouts.list();
    if (!mounted) return;

    setState(() {
      if (wallet is ApiSuccess<Wallet>) {
        _lines = wallet.value.lines;
        final keep = _from == null
            ? null
            : _lines!
                .where((line) => line.institutionId == _from!.institutionId)
                .firstOrNull;
        _from = keep ?? (_lines!.isEmpty ? null : _lines!.first);
      }
      if (payouts is ApiSuccess<List<Payout>>) _payouts = payouts.value;
    });
  }

  String get _currency => _from?.currency ?? 'SDG';

  BigInt? get _minor => toMinor(_amount.text, _currency);

  bool get _ready =>
      !_sending &&
      _from != null &&
      _minor != null &&
      _bank.text.trim().length >= 2 &&
      _name.text.trim().length >= 2 &&
      _number.text.replaceAll(RegExp(r'\s'), '').length >= 4;

  String _money(BigInt minor, String currency) {
    final (whole, fraction) = splitMinor(minor, currency);

    return '$whole$fraction $currency';
  }

  Future<void> _send() async {
    final from = _from;
    final minor = _minor;
    if (from == null || minor == null) return;

    FocusScope.of(context).unfocus();
    setState(() {
      _sending = true;
      _error = null;
      _asked = null;
    });

    final result = await AuthSession.instance.payouts.request(
      institutionId: from.institutionId,
      currency: from.currency,
      amountMinor: minor,
      bankName: _bank.text,
      accountName: _name.text,
      accountNumber: _number.text,
      note: _note.text,
      reference: _reference,
    );
    if (!mounted) return;

    setState(() {
      _sending = false;
      if (result is ApiSuccess<Payout>) {
        _asked = result.value;
        _reference = const Uuid().v4();
        _amount.clear();
        _note.clear();
      } else {
        _error = result.messageIn('en');
      }
    });

    if (result is ApiSuccess<Payout>) await _load();
  }

  Future<void> _cancel(Payout payout) async {
    setState(() => _error = null);
    final result = await AuthSession.instance.payouts.cancel(payout.id);
    if (!mounted) return;

    if (result is ApiSuccess<Payout>) {
      await _load();
    } else {
      setState(() => _error = result.messageIn('en'));
    }
  }

  TextStyle _text(double size,
          {FontWeight weight = FontWeight.w400, Color? color}) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        color: color ?? Colors.black,
      );

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Scaffold(
      backgroundColor: theme.secondaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text('Send to your bank',
            style: _text(18, weight: FontWeight.w600)),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(15, 4, 15, 40),
          children: [
            Text(
              'From your available balance. HAAT sends it and records the bank’s reference. '
              'The fee comes on top of the amount.',
              style: _text(13, color: const Color(0x99000000)),
            ),
            const SizedBox(height: 16),
            _card(children: [
              _label('From'),
              _fromPicker(),
              const SizedBox(height: 14),
              _label('Amount ($_currency)'),
              _field(_amount, hint: '500.00', number: true),
              if (_amount.text.isNotEmpty && _minor == null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    'A positive amount with at most ${placesOf(_currency)} decimal places.',
                    style: _text(12, color: theme.error),
                  ),
                ),
            ]),
            const SizedBox(height: 12),
            _card(children: [
              _label('Your bank'),
              _field(_bank, hint: 'Bank of Khartoum'),
              const SizedBox(height: 14),
              _label('Name on the account'),
              _field(_name, hint: 'As the bank has it'),
              const SizedBox(height: 14),
              _label('Account number or IBAN'),
              _field(_number, hint: 'SD00 0000 0000 0000'),
              const SizedBox(height: 14),
              _label('Note (optional)'),
              _field(_note, hint: 'September takings'),
            ]),
            const SizedBox(height: 18),
            _button(),
            if (_error != null) ...[
              const SizedBox(height: 12),
              _notice(_error!, theme.error),
            ],
            if (_asked != null) ...[
              const SizedBox(height: 12),
              _askedCard(_asked!, theme),
            ],
            const SizedBox(height: 26),
            Text('Your payouts', style: _text(16, weight: FontWeight.w600)),
            const SizedBox(height: 10),
            ..._history(theme),
          ],
        ),
      ),
    );
  }

  Widget _fromPicker() {
    final lines = _lines;
    if (lines == null) return Text('Loading…', style: _text(14));
    if (lines.isEmpty) {
      return Text('There is no wallet yet, so nothing to send.',
          style: _text(14));
    }

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        value: _from?.institutionId,
        items: [
          for (final line in lines)
            DropdownMenuItem(
              value: line.institutionId,
              child: Text(
                '${line.institutionCode} · ${_money(line.availableMinor, line.currency)} available',
                style: _text(14, weight: FontWeight.w500),
              ),
            ),
        ],
        onChanged: (id) => setState(
          () => _from = lines.firstWhere((line) => line.institutionId == id),
        ),
      ),
    );
  }

  Widget _card({required List<Widget> children}) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: children),
      );

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: _text(12,
                weight: FontWeight.w500, color: const Color(0x99000000))),
      );

  Widget _field(TextEditingController controller,
          {required String hint, bool number = false}) =>
      TextField(
        controller: controller,
        keyboardType: number
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        style: _text(15, weight: FontWeight.w500),
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          hintStyle: _text(15, color: const Color(0x44000000)),
          filled: true,
          fillColor: const Color(0xFFF5F5F7),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      );

  Widget _button() {
    final minor = _minor;
    final label = _sending
        ? 'Sending…'
        : minor == null
            ? 'Send'
            : 'Send ${_money(minor, _currency)}';

    return GestureDetector(
      onTap: _ready ? _send : null,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _ready ? Colors.black : const Color(0x28000000),
          borderRadius: BorderRadius.circular(106.67),
        ),
        child: Text(label,
            style: _text(17, weight: FontWeight.w600, color: Colors.white)),
      ),
    );
  }

  Widget _notice(String text, Color color) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text, style: _text(13, color: color)),
      );

  Widget _askedCard(Payout payout, FlutterFlowTheme theme) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.alternate,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${_money(payout.amountMinor, payout.currency)} asked for',
              style: _text(15, weight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              'Fee ${_money(payout.feeMinor, payout.currency)} · '
              '${_money(payout.totalMinor, payout.currency)} set aside in all',
              style: _text(13),
            ),
            Text(
              'To ${payout.bankName} ${payout.maskedAccount}. HAAT will send it and record the bank’s reference.',
              style: _text(13, color: const Color(0x99000000)),
            ),
          ],
        ),
      );

  List<Widget> _history(FlutterFlowTheme theme) {
    final payouts = _payouts;
    if (payouts == null) return [Text('Loading…', style: _text(14))];
    if (payouts.isEmpty) {
      return [
        Text(
          'No payouts yet. Money you send to your bank account shows here.',
          style: _text(13, color: const Color(0x99000000)),
        ),
      ];
    }

    return [
      for (final payout in payouts)
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _money(payout.amountMinor, payout.currency),
                      style: _text(15, weight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${payout.bankName} ${payout.maskedAccount} · '
                      '${dateTimeFormat('d MMM, HH:mm', payout.requestedAt)}',
                      style: _text(12, color: const Color(0x99000000)),
                    ),
                    if (payout.bankReference != null)
                      Text('Ref ${payout.bankReference}',
                          style: _text(12, color: const Color(0x99000000))),
                    if (payout.reason != null)
                      Text(payout.reason!,
                          style: _text(12, color: theme.error)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _statusPill(payout.status, theme),
                  if (payout.status == PayoutStatus.requested)
                    TextButton(
                      onPressed: () => _cancel(payout),
                      child: Text('Cancel',
                          style: _text(13, weight: FontWeight.w600)),
                    ),
                ],
              ),
            ],
          ),
        ),
    ];
  }

  Widget _statusPill(PayoutStatus status, FlutterFlowTheme theme) {
    final color = switch (status) {
      PayoutStatus.requested => const Color(0xFFB7791F),
      PayoutStatus.paid => theme.success,
      PayoutStatus.rejected => theme.error,
      PayoutStatus.cancelled => const Color(0xFF6B7280),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(status.label,
          style: _text(12, weight: FontWeight.w600, color: color)),
    );
  }
}
