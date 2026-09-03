// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AmountInput extends StatefulWidget {
  const AmountInput({
    super.key,
    this.width,
    this.height,
    this.initialAmount,
    this.currency,
    this.placeholder,
    this.autofocus,
    this.showCursorLine,
    this.onAmountChanged,
    this.onValidChanged,
  });

  final double? width;
  final double? height;

  final String? initialAmount;
  final String? currency;
  final String? placeholder;
  final bool? autofocus;
  final bool? showCursorLine;
  final Future Function(String amount)? onAmountChanged;
  final Future Function(bool isValid)? onValidChanged;

  @override
  State<AmountInput> createState() => _AmountInputState();
}

/// iOS zero-prefix fix ke liye custom formatter.
/// Jab bhi text change hota hai:
///   "0"       → "" (sirf zero = hata do, placeholder show hoga)
///   "05"      → "5" (leading zero hata do)
///   "0.5"     → "0.5" (decimal wala zero rakhna hai)
///   "1,500"   → "1,500" (theek hai, kuch mat karo)
class _NoLeadingZeroFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;

    // Khaali string — kuch nahi karna
    if (text.isEmpty) return newValue;

    // Sirf "0" — field khali kar do taake placeholder dikhe
    if (text == '0') {
      return newValue.copyWith(
        text: '',
        selection: const TextSelection.collapsed(offset: 0),
      );
    }

    // "0X" pattern — jab tak decimal point na ho, leading zero hata do
    // Mismatch: "0." ya "0.5" ko mat chhuo (valid decimal)
    if (text.startsWith('0') && text.length > 1 && text[1] != '.') {
      final cleaned = text.replaceFirst(RegExp(r'^0+'), '');
      final offset = cleaned.length;
      return newValue.copyWith(
        text: cleaned,
        selection: TextSelection.collapsed(offset: offset),
      );
    }

    return newValue;
  }
}

class _AmountInputState extends State<AmountInput> {
  static const _numberColor = Color(0xFF111111);
  static const _currencyColor = Color(0xFFBBBBBB);
  static const _lineColor = Color(0x17000000);

  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _lastValid = false;

  @override
  void initState() {
    super.initState();

    // initialAmount me agar "0" ho to field khali rakho — placeholder dikhega
    final initial = widget.initialAmount ?? '';
    final safeInitial = (initial.trim() == '0') ? '' : initial.trim();

    _controller = TextEditingController(text: safeInitial);
    _focusNode = FocusNode();
    _lastValid = _isValid(_controller.text);

    if (widget.autofocus ?? true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  static bool _isValid(String raw) {
    final value = double.tryParse(raw.replaceAll(',', '').trim());
    return value != null && value > 0;
  }

  Future<void> _handleChanged(String raw) async {
    setState(() {});
    await widget.onAmountChanged?.call(raw);
    final valid = _isValid(raw);
    if (valid != _lastValid) {
      _lastValid = valid;
      await widget.onValidChanged?.call(valid);
    }
  }

  double _resolve(
      double? given, double bounded, bool hasBounded, double design) {
    if (given != null && given.isFinite) return given;
    if (hasBounded && bounded.isFinite) return bounded;
    return design;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = _resolve(widget.width, constraints.maxWidth,
            constraints.hasBoundedWidth, 345);
        final h = (widget.height != null && widget.height!.isFinite)
            ? widget.height!
            : 74.0;

        return SizedBox(
          width: w,
          height: h,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, right: 20),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _focusNode.requestFocus(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: IntrinsicWidth(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(minWidth: 36),
                              child: _amountField(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            widget.currency ?? 'SDG',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: _currencyColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (widget.showCursorLine ?? true)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Container(
                        width: 2,
                        height: 47,
                        decoration: BoxDecoration(
                          color: _lineColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _amountField() {
    final numberStyle = GoogleFonts.inter(
      fontSize: 56,
      fontWeight: FontWeight.w400,
      letterSpacing: -3.2,
      height: 1.0,
      color: _numberColor,
    );

    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      onChanged: _handleChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        // پہلے صرف جائز characters allow کرو
        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
        // پھر iOS zero-prefix صاف کرو
        _NoLeadingZeroFormatter(),
      ],
      style: numberStyle,
      showCursor: false,
      cursorColor: Colors.transparent,
      decoration: InputDecoration(
        isCollapsed: true,
        contentPadding: EdgeInsets.zero,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        // hintText صرف placeholder دکھاتا ہے — real value نہیں بنتا
        hintText: widget.placeholder ?? '0',
        hintStyle: numberStyle,
      ),
    );
  }
}
