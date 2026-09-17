// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:google_fonts/google_fonts.dart';

import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/organization_api.dart';

/// The chip cloud on the two business-setup screens, filled from the backend.
///
/// ## Why this is a custom widget
///
/// The chips are a `Wrap`: they are different widths and flow onto as many runs as
/// they need. FlutterFlow's `Wrap` takes a fixed list of children — only `ListView`
/// and `GridView` accept a data source — so a backend-driven chip cloud cannot be
/// built in the editor without turning it into a grid of equal cells, which is a
/// different design. This keeps the design and moves the data.
///
/// ## Why it fetches its own options
///
/// The list and the chips that render it are one thing; a chip cloud with nothing in
/// it is not a state this screen can show. Routing the fetch through an action and an
/// App State list would also throw away the half that matters — App State would carry
/// the labels, and [BusinessOption.key] is what `PATCH /organizations` validates.
///
/// So [onChanged] reports **keys**, never labels. The screen keeps them, shows the
/// count, and submits them unchanged.
class BusinessOptionPicker extends StatefulWidget {
  const BusinessOptionPicker({
    super.key,
    this.width,
    this.height,
    this.optionSet,
    this.singleSelect,
    this.selected,
    this.onChanged,
  });

  final double? width;
  final double? height;

  /// Which list to show: `categories` (what the business sells) or `salesChannels`
  /// (where it sells). Anything else shows the categories.
  final String? optionSet;

  /// One choice only, for "Where would you like to sell?" — default: false.
  final bool? singleSelect;

  /// Keys already chosen, so returning to the screen shows the earlier answer.
  final List<String>? selected;

  /// The chosen keys, every time they change. Keys, not labels.
  final Future Function(List<String> selectedKeys)? onChanged;

  @override
  State<BusinessOptionPicker> createState() => _BusinessOptionPickerState();
}

class _BusinessOptionPickerState extends State<BusinessOptionPicker> {
  static const _chipHeight = 38.0;
  static const _chipRadius = 52.0;
  static const _borderColour = Color(0xFF292E38);

  List<BusinessOption> _options = const [];
  late List<String> _selected = List<String>.from(widget.selected ?? const []);

  /// Null while loading, empty once loaded, or the server's own wording on a
  /// failure. The server writes its messages in both languages, so none of them are
  /// invented here.
  String? _problem;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(BusinessOptionPicker old) {
    super.didUpdateWidget(old);

    // The page can hand back a different selection — a Back that restored earlier
    // answers, or a reset. Ignored while the lists match, so a rebuild caused by
    // this widget's own onChanged does not fight the user's next tap.
    final incoming = widget.selected ?? const <String>[];
    if (!_sameMembers(incoming, _selected)) {
      setState(() => _selected = List<String>.from(incoming));
    }

    if (old.optionSet != widget.optionSet) _load();
  }

  static bool _sameMembers(List<String> a, List<String> b) =>
      a.length == b.length && a.toSet().containsAll(b);

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _problem = null;
    });

    final session = AuthSession.instance;
    final result = await session.organizations.setupOptions();

    if (!mounted) return;

    setState(() {
      _loading = false;

      switch (result) {
        case ApiSuccess(:final value):
          _options = widget.optionSet == 'salesChannels'
              ? value.salesChannels
              : value.categories;
          // A list that arrives empty is a backend that answered with nothing to
          // choose from. Saying so beats an empty box with no explanation.
          _problem = _options.isEmpty
              ? 'There is nothing to choose from yet. Please try again shortly.'
              : null;
        case ApiFailure() || ApiUnreachable():
          _options = const [];
          _problem = result.messageIn(session.languageCode);
      }
    });
  }

  void _toggle(BusinessOption option) {
    setState(() {
      if (widget.singleSelect == true) {
        // Tapping the chosen one again clears it, so a merchant who picked the
        // wrong channel is not stuck with it.
        _selected = _selected.contains(option.key) ? [] : [option.key];
      } else if (_selected.contains(option.key)) {
        _selected = List<String>.from(_selected)..remove(option.key);
      } else {
        _selected = List<String>.from(_selected)..add(option.key);
      }
    });

    widget.onChanged?.call(List<String>.from(_selected));
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: _loading
          ? const Align(
              alignment: AlignmentDirectional(-1, -1),
              // Sized explicitly: an unsized indicator inside a Wrap's parent
              // takes whatever it is given, which here is the whole column.
              child: SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(strokeWidth: 4),
              ),
            )
          : _problem != null
              ? _Problem(message: _problem!, onRetry: _load)
              : Wrap(
                  spacing: 9,
                  runSpacing: 12,
                  children: [
                    for (final option in _options)
                      _Chip(
                        label: option.labelIn(AuthSession.instance.languageCode),
                        chosen: _selected.contains(option.key),
                        onTap: () => _toggle(option),
                        theme: theme,
                      ),
                  ],
                ),
    );
  }
}

/// One chip. Sized by its own text rather than a fixed width, which is what lets the
/// list come from the server — the old screen carried a hand-measured width per chip.
class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.chosen,
    required this.onTap,
    required this.theme,
  });

  final String label;
  final bool chosen;
  final VoidCallback onTap;
  final FlutterFlowTheme theme;

  @override
  Widget build(BuildContext context) => InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          height: _BusinessOptionPickerState._chipHeight,
          decoration: BoxDecoration(
            color: chosen ? theme.secondary : Colors.transparent,
            borderRadius:
                BorderRadius.circular(_BusinessOptionPickerState._chipRadius),
            border: Border.all(
              color: _BusinessOptionPickerState._borderColour,
              width: 1,
            ),
          ),
          alignment: AlignmentDirectional.center,
          padding: const EdgeInsetsDirectional.fromSTEB(14, 0, 14, 0),
          child: Text(
            label,
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(
                fontWeight: theme.bodyMedium.fontWeight,
                fontStyle: theme.bodyMedium.fontStyle,
              ),
              color: theme.primaryText,
              fontSize: 15,
              letterSpacing: 0,
            ),
          ),
        ),
      );
}

/// What the server said, and a way to ask again.
class _Problem extends StatelessWidget {
  const _Problem({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: theme.bodyMedium.override(
            font: GoogleFonts.inter(fontStyle: theme.bodyMedium.fontStyle),
            color: theme.primaryText,
            fontSize: 14,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onRetry,
          child: Container(
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(52),
              border: Border.all(
                color: _BusinessOptionPickerState._borderColour,
                width: 1,
              ),
            ),
            alignment: AlignmentDirectional.center,
            padding: const EdgeInsetsDirectional.fromSTEB(18, 0, 18, 0),
            child: Text(
              'Try again',
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                color: theme.primaryText,
                fontSize: 15,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
