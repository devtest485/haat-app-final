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

class OtpVerify extends StatefulWidget {
  const OtpVerify({
    super.key,
    this.width,
    this.height,
    this.otpLength,
    this.autoFocus,
    this.useLightStyle, // NEW PARAMETER
    this.onChanged,
    this.onCompleted,
  });

  final double? width;
  final double? height;

  /// Kitne digits ka OTP hai — default: 6
  final int? otpLength;

  /// Page open hote hi pehla box focus ho jaye — default: true
  final bool? autoFocus;

  /// true = Figma wala light style
  /// false = existing/current style
  final bool? useLightStyle;

  /// Har digit type/delete hone par current OTP string wapas bhejta hai
  final Future Function(String otpValue)? onChanged;

  /// Sirf ek baar fire hota hai jab poore digits fill ho jayein
  final Future Function(bool isComplete)? onCompleted;

  @override
  State<OtpVerify> createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  late int _length;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  // Existing/current style
  static const _darkFilledBg = Color(0x24CBCBCB);
  static const _darkFilledBorder = Colors.white;
  static const _darkEmptyBg = Color(0x0FFFFFFF);
  static const _darkEmptyBorder = Color(0x14FFFFFF);

  // New light style — Figma values
  static const _lightFilledBg = Color(0x24FFFFFF);
  static const _lightFilledBorder = Colors.black;
  static const _lightEmptyBg = Color(0x0F9B9B9B);
  static const _lightEmptyBorder = Color(0x14000000);

  static const _boxSize = 52.0;
  static const _gap = 6.0;

  @override
  void initState() {
    super.initState();

    _length = widget.otpLength ?? 6;

    _controllers = List.generate(
      _length,
      (_) => TextEditingController(),
    );

    _focusNodes = List.generate(
      _length,
      (_) => FocusNode(),
    );

    if (widget.autoFocus ?? true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _focusNodes.isNotEmpty) {
          _focusNodes.first.requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  String get _currentOtp {
    return _controllers.map((controller) => controller.text).join();
  }

  Future<void> _handleChange(
    int index,
    String value,
  ) async {
    if (value.length > 1) {
      value = value.characters.last;

      _controllers[index].text = value;

      _controllers[index].selection =
          TextSelection.collapsed(offset: value.length);
    }

    // Next box par focus
    if (value.isNotEmpty && index < _length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    setState(() {});

    final otp = _currentOtp;

    await widget.onChanged?.call(otp);

    // Check all boxes properly filled
    final isComplete = _controllers.every(
      (controller) => controller.text.isNotEmpty,
    );

    if (isComplete) {
      FocusScope.of(context).unfocus();

      await widget.onCompleted?.call(true);
    }
  }

  void _handleBackspace(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();

      setState(() {});

      widget.onChanged?.call(_currentOtp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalGap = _gap * (_length - 1);

    final rowWidth = widget.width ?? (_boxSize * _length + totalGap);

    // NEW:
    // true = Figma light style
    // false = existing style
    final bool isLightStyle = widget.useLightStyle ?? false;

    return SizedBox(
      width: rowWidth,
      height: widget.height ?? _boxSize,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          _length,
          (index) {
            final controller = _controllers[index];

            final isFilled = controller.text.isNotEmpty;

            // -----------------------------
            // COLORS
            // -----------------------------

            final Color boxBackground;

            final Color boxBorder;

            final Color textColor;

            if (isLightStyle) {
              // Figma light design
              boxBackground = isFilled ? _lightFilledBg : _lightEmptyBg;

              boxBorder = isFilled ? _lightFilledBorder : _lightEmptyBorder;

              textColor = Colors.black;
            } else {
              // Existing/current design
              boxBackground = isFilled ? _darkFilledBg : _darkEmptyBg;

              boxBorder = isFilled ? _darkFilledBorder : _darkEmptyBorder;

              textColor = Colors.white;
            }

            return Container(
              width: _boxSize,
              height: _boxSize,
              decoration: BoxDecoration(
                color: boxBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: boxBorder,
                  width: isFilled ? 0.5 : 1,
                ),
              ),
              child: Center(
                child: KeyboardListener(
                  focusNode: FocusNode(
                    skipTraversal: true,
                  ),
                  onKeyEvent: (event) {
                    if (event is KeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.backspace &&
                        controller.text.isEmpty) {
                      _handleBackspace(index);
                    }
                  },
                  child: TextField(
                    controller: controller,
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    cursorColor: textColor,
                    style: GoogleFonts.getFont(
                      'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      height: 14 / 16,
                      color: textColor,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(1),
                    ],
                    onChanged: (value) {
                      _handleChange(index, value);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
