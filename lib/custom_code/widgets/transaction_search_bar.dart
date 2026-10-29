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

class TransactionSearchBar extends StatefulWidget {
  const TransactionSearchBar({
    super.key,
    this.width,
    this.height,
    this.hintText,
    this.iconColor,
    this.fillColor,
    this.onChanged,
  });

  final double? width;
  final double? height;
  final String? hintText;
  final Color? iconColor;
  final Color? fillColor;
  final Future Function(String query)? onChanged;

  @override
  State<TransactionSearchBar> createState() => _TransactionSearchBarState();
}

class _TransactionSearchBarState extends State<TransactionSearchBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _open = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 380),
    reverseDuration: const Duration(milliseconds: 260),
  );
  late final Animation<double> _grow = CurvedAnimation(
    parent: _open,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );
  late final Animation<double> _fill = CurvedAnimation(
    parent: _open,
    curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
  );
  late final Animation<double> _text = CurvedAnimation(
    parent: _open,
    curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
  );
  late final Animation<double> _close = CurvedAnimation(
    parent: _open,
    curve: const Interval(0.55, 1.0, curve: Curves.easeOutBack),
  );

  final _controller = TextEditingController();
  final _focus = FocusNode();
  Timer? _debounce;
  String _sent = '';

  bool get _isOpen =>
      _open.status == AnimationStatus.forward ||
      _open.status == AnimationStatus.completed;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_typed);
    _focus.addListener(() {
      if (mounted) setState(() {}); // The border darkens while typing.

      // Tapping away from an empty field puts the icon back; a query stays open so
      // the list it filters keeps saying why it is shorter.
      if (!_focus.hasFocus && _controller.text.trim().isEmpty && _isOpen) {
        _collapse();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focus.dispose();
    _open.dispose();
    super.dispose();
  }

  void _typed() {
    setState(() {}); // The clear affordance follows whether there is text.

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 180), () {
      _send(_controller.text.trim());
    });
  }

  void _send(String query) {
    if (query == _sent) return;
    _sent = query;
    widget.onChanged?.call(query);
  }

  void _expand() {
    if (_isOpen) {
      _focus.requestFocus();
      return;
    }
    HapticFeedback.selectionClick();
    _open.forward();

    // The field only exists once the pill is wide enough to hold it.
    Future.delayed(const Duration(milliseconds: 140), () {
      if (mounted && _isOpen) _focus.requestFocus();
    });
  }

  void _collapse() {
    _debounce?.cancel();
    _focus.unfocus();
    if (_controller.text.isNotEmpty) _controller.clear();
    _send('');
    _open.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final ink = widget.iconColor ?? theme.primaryBackground;
    final fill = widget.fillColor ?? theme.primaryText;
    final size = widget.height ?? 40.0;

    if (MediaQuery.of(context).disableAnimations) {
      _open.duration = Duration.zero;
      _open.reverseDuration = Duration.zero;
    }

    return SizedBox(
      width: widget.width,
      height: size,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final full = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width;

          return Align(
            alignment: AlignmentDirectional.centerEnd,
            child: AnimatedBuilder(
              animation: _open,
              builder: (context, _) {
                final width = size + (full - size) * _grow.value;
                final roomForText = width > size * 2 + 24;

                return Container(
                  width: width,
                  height: size,
                  decoration: BoxDecoration(
                    color: fill.withValues(alpha: _fill.value),
                    borderRadius: BorderRadius.circular(size / 2),
                    border: Border.all(
                      color: Color.lerp(
                        Colors.transparent,
                        _focus.hasFocus
                            ? ink.withValues(alpha: 0.28)
                            : const Color(0x14000000),
                        _fill.value,
                      )!,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.06 * _fill.value),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Semantics(
                        button: true,
                        label: 'Search transactions',
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _expand,
                          child: SizedBox(
                            width: size,
                            height: size,
                            child: Transform.scale(
                              scale: 1 - 0.12 * _grow.value,
                              child: Icon(Icons.search_sharp,
                                  color: ink, size: 24),
                            ),
                          ),
                        ),
                      ),
                      if (roomForText)
                        Expanded(
                          child: FadeTransition(
                            opacity: _text,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.06, 0),
                                end: Offset.zero,
                              ).animate(_text),
                              child: TextField(
                                controller: _controller,
                                focusNode: _focus,
                                textInputAction: TextInputAction.search,
                                onSubmitted: (_) => _focus.unfocus(),
                                cursorColor: const Color(0xFF00DA76),
                                cursorWidth: 1.6,
                                style: theme.bodyMedium.override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: theme.bodyMedium.fontStyle,
                                  ),
                                  color: ink,
                                  fontSize: 14.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: theme.bodyMedium.fontStyle,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  hintText:
                                      widget.hintText ?? 'Search transactions',
                                  hintStyle: theme.bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.normal,
                                      fontStyle: theme.bodyMedium.fontStyle,
                                    ),
                                    color: const Color(0xC257636C),
                                    fontSize: 14.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: theme.bodyMedium.fontStyle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (roomForText)
                        ScaleTransition(
                          scale: _close,
                          child: Semantics(
                            button: true,
                            label: _controller.text.isEmpty
                                ? 'Close search'
                                : 'Clear search',
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                // Clear first, close second: one tap empties a
                                // query, the next puts the icon back.
                                if (_controller.text.isNotEmpty) {
                                  _controller.clear();
                                  _debounce?.cancel();
                                  _send('');
                                  _focus.requestFocus();
                                } else {
                                  _collapse();
                                }
                              },
                              child: SizedBox(
                                width: size,
                                height: size,
                                child: Center(
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 160),
                                    transitionBuilder: (child, animation) =>
                                        RotationTransition(
                                      turns: Tween<double>(begin: 0.75, end: 1)
                                          .animate(animation),
                                      child: FadeTransition(
                                          opacity: animation, child: child),
                                    ),
                                    child: Container(
                                      key: ValueKey(_controller.text.isEmpty),
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: _controller.text.isEmpty
                                            ? Colors.transparent
                                            : const Color(0x14000000),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close_rounded,
                                        color: ink,
                                        size:
                                            _controller.text.isEmpty ? 20 : 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
