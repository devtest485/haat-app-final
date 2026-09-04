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
    this.initialValue,
    this.useLightStyle, // NEW PARAMETER
    this.onChanged,
    this.onCompleted,
  });

  final double? width;
  final double? height;

  /// Kitne digits ka OTP hai — default: 6
  final int? otpLength;

  /// Digits to start with, filled into the boxes on first build.
  ///
  /// Used in development to save typing a code the backend already handed back. It
  /// does **not** submit: `onCompleted` is left for the user to trigger, so the screen
  /// behaves the same as if the digits had been typed.
  final String? initialValue;

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

  /// One per box, for the KeyboardListener that catches backspace.
  ///
  /// Held here rather than created in build. A FocusNode is a listenable that owns
  /// platform focus state, and this widget rebuilds on every keystroke — so building
  /// them inline created six new nodes per digit typed, none of them ever disposed,
  /// and replaced the node under a field that was mid-layout. That is what showed up
  /// as "RenderEditable NEEDS-LAYOUT DETACHED" while typing a code.
  late List<FocusNode> _keyListenerNodes;

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

    _keyListenerNodes = List.generate(
      _length,
      (_) => FocusNode(skipTraversal: true),
    );

    _applyInitialValue();

    if (widget.autoFocus ?? true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _focusNodes.isNotEmpty) {
          _focusNodes.first.requestFocus();
        }
      });
    }
  }

  /// Fills the boxes from [OtpVerify.initialValue], if it is the right length.
  ///
  /// Setting a controller's text does not fire the field's `onChanged`, so the parent
  /// is told separately — otherwise the page would hold an empty code while the boxes
  /// showed a full one, and its Continue button would stay disabled.
  ///
  /// `onCompleted` is deliberately not called. Submitting on the user's behalf would
  /// skip the screen entirely, and the screen is one of the things worth testing.
  void _applyInitialValue() {
    final initial = widget.initialValue;
    if (initial == null || initial.length != _length) return;

    const zero = 0x30;
    const nine = 0x39;
    final digitsOnly =
        initial.codeUnits.every((unit) => unit >= zero && unit <= nine);
    if (!digitsOnly) return;

    for (var index = 0; index < _length; index += 1) {
      _controllers[index].text = initial[index];
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.onChanged?.call(initial);
    });
  }

  @override
  void didUpdateWidget(OtpVerify oldWidget) {
    super.didUpdateWidget(oldWidget);

    // A resend issues a new code, so the boxes have to follow. Without this they keep
    // showing the previous one, which then fails verification — and the reason is not
    // visible on screen.
    if (widget.initialValue != oldWidget.initialValue) _applyInitialValue();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }

    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }

    for (final focusNode in _keyListenerNodes) {
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
      // `onChanged` above was awaited, and the handler behind it can navigate — the
      // verification page submits the code as soon as the sixth digit lands. So by
      // here this widget may already be gone, and reading FocusScope from a defunct
      // context is what surfaced as "RenderEditable NEEDS-LAYOUT DETACHED".
      if (!mounted) return;

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
                  focusNode: _keyListenerNodes[index],
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
