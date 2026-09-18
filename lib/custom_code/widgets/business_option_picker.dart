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
/// ## Why the answer goes to App State
///
/// A callback parameter would be the tidier shape, but a custom widget's
/// parameters have to be declared to FlutterFlow, and there is no action-typed
/// parameter in the DSL's type constructors — so a widget with an `onChanged`
/// could not be pushed, and would exist only in the local export. App State is
/// reachable from both sides and needs nothing the DSL cannot express.
///
/// What is written are **keys**, never labels: `PATCH /organizations` validates
/// against its own catalogue, so the label is for reading and the key is for
/// sending.
class BusinessOptionPicker extends StatefulWidget {
  const BusinessOptionPicker({
    super.key,
    this.width,
    this.height,
    this.optionSet,
    this.singleSelect,
    this.layout,
  });

  final double? width;
  final double? height;

  /// Which list to show: `salesChannels` (where the business sells) or anything
  /// else for the categories (what it sells).
  final String? optionSet;

  /// One choice only, for "Where would you like to sell?" — default: false.
  final bool? singleSelect;

  /// `rows` for full-width rows with an icon and a radio, anything else for the
  /// chip cloud.
  ///
  /// Two presentations rather than two widgets: both ask the same question of the
  /// same endpoint and differ only in how a choice is drawn, and a second widget
  /// would be a second copy of the fetching, the selection and the failure
  /// handling — three things that would then have to be fixed twice.
  final String? layout;

  @override
  State<BusinessOptionPicker> createState() => _BusinessOptionPickerState();
}

class _BusinessOptionPickerState extends State<BusinessOptionPicker> {
  static const _chipHeight = 38.0;
  static const _chipRadius = 52.0;
  static const _borderColour = Color(0xFF292E38);

  /// The surface a chip or row sits on, and the lighter one it takes when chosen.
  ///
  /// Taken from the design rather than the theme: both screens are drawn on the
  /// dark artwork and the palette's `secondary` is the brand green, which the
  /// design does not use for a selected option — it lightens the fill instead.
  static const _restFill = Color(0xFF141414);
  static const _chosenFill = Color(0xFF3A3A3C);

  List<BusinessOption> _options = const [];

  /// Seeded from App State so coming back to the screen shows the earlier answer.
  late List<String> _selected = _readSelection();

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

    if (old.optionSet != widget.optionSet) {
      setState(() => _selected = _readSelection());
      _load();
    }
  }

  bool get _isChannels => widget.optionSet == 'salesChannels';

  /// The answer already held for this list.
  ///
  /// The two screens keep theirs in two App State fields rather than one shared
  /// list — a single field would make "changed the channel" and "cleared the
  /// categories" the same event.
  List<String> _readSelection() {
    if (_isChannels) {
      return List<String>.from(FFAppState().selectedSalesChannels);
    }

    return List<String>.from(FFAppState().selectedCategories);
  }

  /// Hands the answer to App State, through `update` rather than the setter.
  ///
  /// The setters assign and tell nobody; `update` notifies. The Continue button
  /// on the page above reads this same list for its colour and its count, so
  /// assigning directly would leave it showing the state the screen opened in
  /// however many rows were ticked.
  void _writeSelection() {
    FFAppState().update(() {
      if (_isChannels) {
        FFAppState().selectedSalesChannels = List<String>.from(_selected);

        // The single key `PATCH /organizations` still takes, kept in step.
        // It goes on being written until that endpoint accepts a list, and is
        // the first choice rather than the last so that picking a second one
        // does not quietly change what gets sent.
        FFAppState().selectedSalesChannel =
            _selected.isEmpty ? '' : _selected.first;
      } else {
        FFAppState().selectedCategories = List<String>.from(_selected);
      }
    });
  }

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

    _writeSelection();
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
              : widget.layout == 'rows'
                  // Scrollable, because the back office maintains this list and
                  // may add to it. A screen that fitted five channels has no
                  // reason to fit nine, and the ones past the fold would simply
                  // not be reachable.
                  ? ListView.separated(
                      padding: EdgeInsets.zero,
                      // Sized by its content and not scrollable itself: the page
                      // around it scrolls, so a list that also scrolled would be
                      // a second scrollable inside the first, and a drag would
                      // have to guess which one it meant. The page is the right
                      // one to scroll — the title and the Continue button have
                      // to come with the rows when the catalogue is long.
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _options.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, index) {
                        final option = _options[index];

                        return _OptionRow(
                          label:
                              option.labelIn(AuthSession.instance.languageCode),
                          icon: _optionIcon(
                            option.icon,
                            size: 26,
                            colour: theme.primaryText,
                          ),
                          chosen: _selected.contains(option.key),
                          onTap: () => _toggle(option),
                          theme: theme,
                        );
                      },
                    )
                  // Sized by its own content, like the Wrap it replaced. The page
                  // node has `enforceCustomWidgetDimensions` cleared, so width and
                  // height arrive null and this lays out to whatever the chips need
                  // — which is the only honest answer when the number of runs
                  // depends on the language and on the catalogue's length.
                  : Wrap(
                      spacing: 9,
                      runSpacing: 12,
                      children: [
                        for (final option in _options)
                          _Chip(
                            label: option
                                .labelIn(AuthSession.instance.languageCode),
                            icon: _optionIcon(
                              option.icon,
                              size: 18,
                              colour: theme.primaryText,
                            ),
                            chosen: _selected.contains(option.key),
                            onTap: () => _toggle(option),
                            theme: theme,
                          ),
                      ],
                    ),
    );
  }
}

/// The icons an option may name, and what they draw.
///
/// A lookup table rather than a reflective one: Flutter's tree shaker keeps only the
/// glyphs it can see referenced, so building `IconData` from a string at runtime ships an
/// icon font with nothing in it. Every name the back office can usefully choose has to
/// appear here, which is the cost of letting it choose at all.
///
/// An unknown name — one added in the back office before this list caught up — draws
/// [_fallbackIcon] rather than nothing, so the row still looks like the others.
const Map<String, IconData> _icons = {
  // The five the sales-channel screen ships with.
  'storefront': Icons.storefront_outlined,
  'shopping_bag': Icons.shopping_bag_outlined,
  'add_reaction': Icons.add_reaction_outlined,
  'language': Icons.language_outlined,
  'badge': Icons.badge_outlined,

  // One for every category in the design, so an option added in the back office
  // has something to pick that matches what the screens already show.
  'restaurant': Icons.restaurant_outlined, // Food
  'checkroom': Icons.checkroom_outlined, // Fashion
  'spa': Icons.spa_outlined, // Beauty
  'home': Icons.home_outlined, // Home
  'devices': Icons.devices_outlined, // Electronics
  'card_giftcard': Icons.card_giftcard_outlined, // Gifts
  'palette': Icons.palette_outlined, // Handmade
  'menu_book': Icons.menu_book_outlined, // Books
  'child_care': Icons.child_care_outlined, // Kids
  'handyman': Icons.handyman_outlined, // Services
  'agriculture': Icons.agriculture_outlined, // Livestock, Agriculture
  'sports_soccer': Icons.sports_soccer_outlined, // Sports
  'directions_car': Icons.directions_car_outlined, // Automotive
  'medical_services': Icons.medical_services_outlined, // Health
  'business_center': Icons.business_center_outlined, // Business
  'more_horiz': Icons.more_horiz, // Others

  // The rest of the seeded catalogue, and a few near neighbours.
  'local_pharmacy': Icons.local_pharmacy_outlined,
  'local_grocery_store': Icons.local_grocery_store_outlined,
  'warehouse': Icons.warehouse_outlined,
  'local_shipping': Icons.local_shipping_outlined,
  'bakery_dining': Icons.bakery_dining_outlined,
  'local_cafe': Icons.local_cafe_outlined,
  'local_florist': Icons.local_florist_outlined,
  'fitness_center': Icons.fitness_center_outlined,
  'pets': Icons.pets_outlined,
  'construction': Icons.construction_outlined,
  'shopping_cart': Icons.shopping_cart_outlined,
  'phone_iphone': Icons.phone_iphone_outlined,
  'diamond': Icons.diamond_outlined,
  'toys': Icons.toys_outlined,
  'chair': Icons.chair_outlined,
  'watch': Icons.watch_outlined,
  'laptop': Icons.laptop_outlined,
  'brush': Icons.brush_outlined,
  'cake': Icons.cake_outlined,
  'liquor': Icons.liquor_outlined,
  'hardware': Icons.hardware_outlined,
  'print': Icons.print_outlined,
  'school': Icons.school_outlined,
  'music_note': Icons.music_note_outlined,
  'camera_alt': Icons.camera_alt_outlined,
  'flight': Icons.flight_outlined,
  'cleaning_services': Icons.cleaning_services_outlined,
  'electrical_services': Icons.electrical_services_outlined,
  'water_drop': Icons.water_drop_outlined,
  'eco': Icons.eco_outlined,
};

const IconData _fallbackIcon = Icons.category_outlined;

/// What an option's `icon` draws, or null when it has none.
///
/// Two kinds of value are accepted, because the design uses both. The rows carry
/// line icons and name them — `storefront`, `badge` — and those come out of
/// [_icons]. The chips carry emoji, and an emoji is just text, so it is drawn as
/// text rather than looked up.
///
/// They are told apart by shape: a Material name is lowercase letters, digits and
/// underscores and nothing else, so anything that is not is treated as a glyph to
/// print. That way the back office can type either into the same field without
/// having to say which it meant.
///
/// An empty value draws nothing at all — the design's "Others" chip has no icon,
/// and a fallback there would invent one.
Widget? _optionIcon(String? name,
    {required double size, required Color colour}) {
  final value = name?.trim() ?? '';
  if (value.isEmpty) return null;

  if (RegExp(r'^[a-z0-9_]+$').hasMatch(value)) {
    return Icon(_icons[value] ?? _fallbackIcon, color: colour, size: size);
  }

  return Text(value, style: TextStyle(fontSize: size * 0.8));
}

/// One full-width row: icon, label, and the circle that says whether it is chosen.
///
/// The shape the sales-channel screen already had. Kept rather than replaced with a chip
/// because the icons carry meaning here — the list is read down, not scanned across.
class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.label,
    required this.icon,
    required this.chosen,
    required this.onTap,
    required this.theme,
  });

  final String label;
  final Widget? icon;
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
          width: double.infinity,
          height: 86,
          decoration: BoxDecoration(
            // Lightened rather than outlined when chosen, which is what the design
            // does — the icon and the label stay legible either way.
            color: chosen
                ? _BusinessOptionPickerState._chosenFill
                : _BusinessOptionPickerState._restFill,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
          child: Row(
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 16)],
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                    color: theme.primaryText,
                    fontSize: 17,
                    letterSpacing: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // An empty ring until chosen, then a filled tick — the design's own
              // way of saying "this one", and the same shape whether one row is
              // chosen or several.
              chosen
                  ? Icon(Icons.check_circle, size: 24, color: theme.primaryText)
                  : Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF4A4A4A),
                          width: 1.5,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      );
}

/// One chip. Sized by its own text rather than a fixed width, which is what lets the
/// list come from the server — the old screen carried a hand-measured width per chip.
class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.icon,
    required this.chosen,
    required this.onTap,
    required this.theme,
  });

  final String label;
  final Widget? icon;
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
            color: chosen
                ? _BusinessOptionPickerState._chosenFill
                : _BusinessOptionPickerState._restFill,
            borderRadius:
                BorderRadius.circular(_BusinessOptionPickerState._chipRadius),
            border: Border.all(
              color: _BusinessOptionPickerState._borderColour,
              width: 1,
            ),
          ),
          // No `alignment`. A Container carrying one expands to whatever the parent
          // offers instead of sizing to its child — so every chip took the Wrap's
          // full width, one per row, and the cloud became a list. The padding is
          // what centres the label, and it leaves the chip as wide as its text.
          // Taken from the design, which packs three chips to a row at 390 wide.
          // Every dp here is one the cloud does not have for the next chip, so a
          // roomier chip is a chip that wraps a row earlier.
          padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
          child: Row(
            // Sized to the chip's own contents. Without this the Row takes the
            // Wrap's full width and the cloud collapses into a list — the same
            // trap the Container's `alignment` set, one layer in.
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 6)],
              Text(
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
            ],
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
            // Same reason as the chip: an alignment here would stretch the button
            // across the screen.
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
