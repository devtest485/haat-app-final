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
import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

/// Finds a place by name, over the page, the way a branch is placed on the map.
///
/// Results come as the merchant types, from Photon (OpenStreetMap data, free, made
/// for search-as-you-type), kept to Sudan and ranked near [nearLocation]; Nominatim
/// answers when Photon can't. "Use my current location" is always first. When
/// nothing matches, [notFoundImage] says so with a way out: pin it on the map.
///
/// [onPicked] gets the place's point, its name and the line under it; whoever opened
/// this closes it. The back arrow closes it with nothing chosen.
class HaatPlaceSearch extends StatefulWidget {
  const HaatPlaceSearch({
    super.key,
    this.width,
    this.height,
    this.initialQuery,
    this.searchHint,
    this.nearLocation,
    this.notFoundImage,
    this.onPicked,
    this.onUseMyLocation,
  });

  final double? width;
  final double? height;
  final String? initialQuery;
  final String? searchHint;
  final LatLng? nearLocation;
  final String? notFoundImage;
  final Future Function(LatLng location, String name, String address)? onPicked;
  final Future Function()? onUseMyLocation;

  @override
  State<HaatPlaceSearch> createState() => _HaatPlaceSearchState();
}

const _userAgent = 'HAAT/1.0 (com.mycompany.haat)';

// Sudan, as west, south, east, north.
const _sudan = '21.8,8.6,38.7,22.3';

const _ink = Color(0xFF111111);
const _muted = Color(0xFF8A8A8A);
const _line = Color(0xFFEDEDED);
const _field = Color(0xFFD9D9D9);
const _soft = Color(0xFFF2F2F2);

class _Place {
  const _Place(this.point, this.name, this.address);

  final LatLng point;
  final String name;
  final String address;
}

enum _Status { idle, loading, done, failed }

class _HaatPlaceSearchState extends State<HaatPlaceSearch> {
  late final _query = TextEditingController(text: widget.initialQuery ?? '');
  final _focus = FocusNode();
  Timer? _wait;
  int _ticket = 0;
  _Status _status = _Status.idle;
  List<_Place> _places = const [];

  @override
  void initState() {
    super.initState();
    _lastText = _query.text.trim();
    _query.addListener(_typed);
    if (_lastText.length >= 2) {
      _status = _Status.loading;
      WidgetsBinding.instance.addPostFrameCallback((_) => _look(_lastText));
    }
    // Fetched now so "No places found" never waits on its own picture.
    final image = widget.notFoundImage ?? '';
    if (image.startsWith('http')) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          precacheImage(NetworkImage(image), context, onError: (_, __) {});
        }
      });
    }
  }

  @override
  void dispose() {
    _wait?.cancel();
    _query.dispose();
    _focus.dispose();
    super.dispose();
  }

  String _lastText = '';

  void _typed() {
    final text = _query.text.trim();
    if (text == _lastText) return;
    _lastText = text;
    _wait?.cancel();
    if (text.length < 2) {
      _ticket++;
      setState(() {
        _status = _Status.idle;
        _places = const [];
      });
      return;
    }
    setState(() => _status = _Status.loading);
    _wait = Timer(const Duration(milliseconds: 350), () => _look(text));
  }

  Future<void> _look(String query) async {
    final text = query.trim();
    final ticket = ++_ticket;
    setState(() => _status = _Status.loading);
    List<_Place>? found = await _photon(text);
    found ??= await _nominatim(text);
    if (!mounted || ticket != _ticket) return;
    setState(() {
      _places = found ?? const [];
      _status = found == null ? _Status.failed : _Status.done;
    });
  }

  // Null when the service could not answer; empty when it found nothing.
  Future<List<_Place>?> _photon(String text) async {
    try {
      final near = widget.nearLocation;
      final response = await http.get(
        Uri.https('photon.komoot.io', '/api/', {
          'q': text,
          'limit': '8',
          'lang': 'en',
          'bbox': _sudan,
          if (near != null) 'lat': near.latitude.toStringAsFixed(5),
          if (near != null) 'lon': near.longitude.toStringAsFixed(5),
        }),
        headers: {'User-Agent': _userAgent},
      ).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;
      final features = (jsonDecode(response.body)
              as Map<String, dynamic>)['features'] as List<dynamic>? ??
          const [];
      return _unique(features.map((feature) {
        final map = feature as Map<String, dynamic>;
        final coordinates =
            (map['geometry'] as Map?)?['coordinates'] as List<dynamic>?;
        if (coordinates == null || coordinates.length < 2) return null;
        final p = (map['properties'] as Map?)?.cast<String, dynamic>() ?? {};
        String? of(String key) {
          final value = (p[key] as String?)?.trim();
          return value == null || value.isEmpty ? null : value;
        }

        final street = of('street') == null
            ? null
            : [of('street'), of('housenumber')].whereType<String>().join(' ');
        final name = of('name') ?? street;
        if (name == null) return null;
        return _Place(
          LatLng((coordinates[1] as num).toDouble(),
              (coordinates[0] as num).toDouble()),
          name,
          _join([
            street,
            of('district') ?? of('locality'),
            of('city') ?? of('county'),
            of('state'),
          ], leaving: name),
        );
      }));
    } catch (_) {
      return null;
    }
  }

  Future<List<_Place>?> _nominatim(String text) async {
    try {
      final response = await http.get(
        Uri.https('nominatim.openstreetmap.org', '/search', {
          'format': 'jsonv2',
          'q': text,
          'limit': '8',
          'countrycodes': 'sd',
          'accept-language': 'en',
        }),
        headers: {'User-Agent': _userAgent},
      ).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;
      final rows = jsonDecode(response.body) as List<dynamic>;
      return _unique(rows.map((row) {
        final map = row as Map<String, dynamic>;
        final whole = (map['display_name'] as String? ?? '').split(', ');
        final name = (map['name'] as String?)?.trim();
        final title = name == null || name.isEmpty ? whole.first : name;
        return _Place(
          LatLng(double.parse(map['lat'] as String),
              double.parse(map['lon'] as String)),
          title,
          _join(whole.where((part) => part != 'Sudan').take(4).toList(),
              leaving: title),
        );
      }));
    } catch (_) {
      return null;
    }
  }

  static String _join(List<String?> parts, {required String leaving}) => parts
      .whereType<String>()
      .where((part) => part.isNotEmpty && part != leaving)
      .toSet()
      .take(3)
      .join(', ');

  static List<_Place> _unique(Iterable<_Place?> places) {
    final seen = <String>{};
    return [
      for (final place in places.whereType<_Place>())
        if (seen.add('${place.name}|${place.address}')) place,
    ];
  }

  void _clear() {
    _query.clear();
    _focus.requestFocus();
  }

  Future<void> _pick(_Place place) async {
    _focus.unfocus();
    await widget.onPicked?.call(place.point, place.name, place.address);
  }

  Future<void> _useMyLocation() async {
    _focus.unfocus();
    await widget.onUseMyLocation?.call();
  }

  // ── Pieces ──────────────────────────────────────────────────────────────

  Widget _searchField() => Container(
        height: 48.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(29.0),
          border: Border.all(color: _field),
        ),
        alignment: Alignment.center,
        child: TextField(
          controller: _query,
          focusNode: _focus,
          autofocus: true,
          textInputAction: TextInputAction.search,
          textAlignVertical: TextAlignVertical.center,
          onSubmitted: (text) {
            if (text.trim().length >= 2) _look(text);
          },
          style: GoogleFonts.inter(color: _ink, fontSize: 14.0),
          cursorColor: _ink,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
            hintText: widget.searchHint ?? 'Search a place or address',
            hintStyle: GoogleFonts.inter(
              color: const Color(0xFFBABABA),
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon:
                const Icon(Icons.search_rounded, size: 18.0, color: _ink),
            suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _query,
              builder: (context, value, _) => value.text.isEmpty
                  ? const SizedBox.shrink()
                  : IconButton(
                      tooltip: 'Clear',
                      onPressed: _clear,
                      icon: Container(
                        width: 20.0,
                        height: 20.0,
                        decoration: const BoxDecoration(
                            color: _ink, shape: BoxShape.circle),
                        child: const Icon(Icons.close_rounded,
                            size: 13.0, color: Colors.white),
                      ),
                    ),
            ),
          ),
        ),
      );

  Widget _row({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) =>
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Container(
                width: 36.0,
                height: 36.0,
                decoration:
                    const BoxDecoration(color: _soft, shape: BoxShape.circle),
                child: Icon(icon, size: 18.0, color: _ink),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: _ink,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.1,
                      ),
                    ),
                    if (subtitle != null && subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2.0),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(color: _muted, fontSize: 12.0),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _divider() =>
      const Divider(height: 1.0, thickness: 1.0, indent: 64.0, color: _line);

  Widget _skeleton() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            Container(
              width: 36.0,
              height: 36.0,
              decoration:
                  const BoxDecoration(color: _soft, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 150.0,
                    height: 12.0,
                    decoration: BoxDecoration(
                        color: _soft, borderRadius: BorderRadius.circular(6.0)),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    width: 100.0,
                    height: 10.0,
                    decoration: BoxDecoration(
                        color: _soft, borderRadius: BorderRadius.circular(5.0)),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _illustration() {
    final path = widget.notFoundImage ?? '';
    const fallback =
        Icon(Icons.search_off_rounded, size: 64.0, color: Color(0xFF00DA76));
    if (path.isEmpty) return fallback;
    Widget broken(BuildContext context, Object error, StackTrace? stack) =>
        fallback;
    return path.startsWith('http')
        ? Image.network(path,
            width: 110.0,
            height: 110.0,
            fit: BoxFit.contain,
            errorBuilder: broken)
        : Image.asset(path,
            width: 110.0,
            height: 110.0,
            fit: BoxFit.contain,
            errorBuilder: broken);
  }

  Widget _message(String title, String body, {Widget? action}) => Padding(
        padding: const EdgeInsets.fromLTRB(32.0, 40.0, 32.0, 24.0),
        child: Column(
          children: [
            _illustration(),
            const SizedBox(height: 16.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                color: _ink,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              body,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  color: _muted, fontSize: 13.0, height: 1.45),
            ),
            if (action != null) ...[const SizedBox(height: 12.0), action],
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[
      _row(
        icon: Icons.my_location_rounded,
        title: 'Use my current location',
        onTap: _useMyLocation,
      ),
      if (_status == _Status.loading) ...[
        _divider(),
        _skeleton(),
        _divider(),
        _skeleton(),
      ],
      if (_status == _Status.done)
        for (final place in _places) ...[
          _divider(),
          _row(
            icon: Icons.location_on_outlined,
            title: place.name,
            subtitle: place.address,
            onTap: () => _pick(place),
          ),
        ],
    ];

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Material(
        color: const Color(0xFFF5F5F5),
        child: Stack(
          children: [
            Positioned(
              left: 0.0,
              right: 0.0,
              top: 0.0,
              height: 162.0,
              child: Image.asset('assets/images/GrayPageBg.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) =>
                      const SizedBox.shrink()),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 12.0, 15.0, 0.0),
                    child: Row(
                      children: [
                        IconButton(
                          tooltip: 'Back',
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back,
                              size: 24.0, color: _ink),
                        ),
                        Expanded(child: _searchField()),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding:
                          const EdgeInsets.fromLTRB(15.0, 16.0, 15.0, 32.0),
                      children: [
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Column(children: rows),
                        ),
                        if (_status == _Status.done && _places.isEmpty)
                          _message(
                            'No places found',
                            'Check the spelling, or pin the branch on the map.',
                          ),
                        if (_status == _Status.failed)
                          _message(
                            'Search isn’t available',
                            'Check your connection, or pin the branch on the map.',
                            action: TextButton(
                              onPressed: () => _look(_query.text),
                              style:
                                  TextButton.styleFrom(foregroundColor: _ink),
                              child: Text('Try again',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
