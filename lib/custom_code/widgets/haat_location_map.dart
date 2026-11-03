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

import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as ll;

import '/components/locationpermissionsheet/locationpermissionsheet_widget.dart';

/// A real map the merchant moves under a fixed pin to say where a place is.
///
/// OpenStreetMap, so it needs no API key: tiles from tile.openstreetmap.org and
/// addresses from Nominatim, both free under their usage policies (a named
/// User-Agent, about one address lookup a second, and the credit line in the
/// corner). The tiles are drawn grey so the map reads like the design and the
/// green pin stands out.
///
/// The pin stays in the middle and the map moves under it — drag, tap a spot,
/// search, or use the locate button. Tapping the search bar opens HaatPlaceSearch
/// over the page; the place chosen there is where the map lands, under its name. Each time the map comes to rest, [onPicked]
/// gets the point under the pin and its address. Nothing is reported for the
/// starting view: Khartoum is a default, not the merchant's answer.
///
/// [pinStyle] is `store` (green circle with the branch icon) or `dot` (the soft
/// circle used during registration).
class HaatLocationMap extends StatefulWidget {
  const HaatLocationMap({
    super.key,
    this.width,
    this.height,
    this.pinStyle,
    this.hint,
    this.showSearch,
    this.searchHint,
    this.showLocateButton,
    this.controlsBottomInset,
    this.edgeFade,
    this.borderRadius,
    this.notFoundImage,
    this.onPicked,
  });

  final double? width;
  final double? height;
  final String? pinStyle;
  final String? hint;
  final bool? showSearch;
  final String? searchHint;
  final bool? showLocateButton;
  final double? controlsBottomInset;

  /// Height of the dark fades at the top and bottom, so light text and buttons
  /// laid over a full-screen map stay readable; none when null or 0. Drawn here
  /// because a fade laid over the widget would take the map's touches.
  final double? edgeFade;
  final double? borderRadius;

  /// Shown by the search when no place matches.
  final String? notFoundImage;
  final Future Function(LatLng location, String address)? onPicked;

  @override
  State<HaatLocationMap> createState() => _HaatLocationMapState();
}

const _khartoum = ll.LatLng(15.5007, 32.5599);
const _userAgent = 'HAAT/1.0 (com.mycompany.haat)';
const _green = Color(0xFF00DA76);

// Luminance, lifted a little toward white: the light grey map of the design.
const _greyTiles = ColorFilter.matrix(<double>[
  0.18, 0.61, 0.06, 0, 38, //
  0.18, 0.61, 0.06, 0, 38, //
  0.18, 0.61, 0.06, 0, 38, //
  0, 0, 0, 1, 0,
]);

class _Picked {
  const _Picked(this.location, this.name, this.address);

  final LatLng location;
  final String name;
  final String address;
}

class _HaatLocationMapState extends State<HaatLocationMap> {
  final _map = MapController();
  final _search = TextEditingController();
  Timer? _settle;
  int _lookup = 0;
  bool _moving = false;
  bool _locating = false;

  /// What was last typed into the search, so it opens where it was left.
  String _query = '';

  /// The place chosen in the search, reported as is instead of looking up the
  /// address under the pin; any move of the map by hand drops it.
  String? _chosen;

  @override
  void dispose() {
    _settle?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _tell(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));

  void _onEvent(MapEvent event) {
    // Moves made by code (search, locate) report themselves once they land.
    if (event.source == MapEventSource.mapController ||
        event.source == MapEventSource.nonRotatedSizeChange) return;
    if (event is MapEventMoveStart || event is MapEventFlingAnimationStart) {
      _settle?.cancel();
      _chosen = null;
      if (!_moving) setState(() => _moving = true);
    }
    if (event is MapEventMoveEnd ||
        event is MapEventFlingAnimationEnd ||
        event is MapEventFlingAnimationNotStarted ||
        event is MapEventDoubleTapZoomEnd ||
        event is MapEventScrollWheelZoom) {
      _rested();
    }
  }

  void _moveTo(ll.LatLng point, [double? zoom]) {
    _map.move(point, zoom ?? _map.camera.zoom);
    _rested();
  }

  // Waits for the map to stay still before asking for an address, which keeps
  // Nominatim at well under one request a second.
  void _rested() {
    if (_moving) setState(() => _moving = false);
    _settle?.cancel();
    _settle = Timer(const Duration(milliseconds: 700), _report);
  }

  Future<void> _report() async {
    final point = _map.camera.center;
    final ticket = ++_lookup;
    final address = _chosen ?? await _addressAt(point);
    if (!mounted || ticket != _lookup) return;
    if (address.isNotEmpty && _chosen == null) _search.text = address;
    await widget.onPicked
        ?.call(LatLng(point.latitude, point.longitude), address);
  }

  Future<String> _addressAt(ll.LatLng point) async {
    try {
      final response = await http.get(
        Uri.https('nominatim.openstreetmap.org', '/reverse', {
          'format': 'jsonv2',
          'lat': point.latitude.toStringAsFixed(6),
          'lon': point.longitude.toStringAsFixed(6),
          'zoom': '18',
          'accept-language': 'en',
        }),
        headers: {'User-Agent': _userAgent},
      ).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return '';
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return _shortAddress(body);
    } catch (_) {
      return '';
    }
  }

  // "Street 15, Al Amarat, Khartoum" rather than Nominatim's full line, which
  // runs through the state, postcode and country.
  String _shortAddress(Map<String, dynamic> place) {
    final parts = (place['address'] as Map?)?.cast<String, dynamic>() ?? {};
    String? first(List<String> keys) => keys
        .map((key) => parts[key] as String?)
        .firstWhere((value) => value != null && value.isNotEmpty,
            orElse: () => null);
    final road = first(['road', 'pedestrian', 'footway', 'amenity']);
    final number = parts['house_number'] as String?;
    final street = road == null
        ? null
        : (number == null || number.isEmpty ? road : '$road $number');
    final area = first(['neighbourhood', 'suburb', 'quarter', 'city_district']);
    final city = first(['city', 'town', 'village', 'county', 'state']);
    final whole = (place['display_name'] as String? ?? '').split(', ');
    // Nothing nearer than the city: the first lines of the full address say more.
    if (street == null && area == null) return whole.take(3).join(', ');
    return [street, area, city].whereType<String>().toSet().join(', ');
  }

  // The search covers the page, then hands back the place picked — or "here".
  Future<void> _openSearch() async {
    final center = _map.camera.center;
    final picked = await Navigator.of(context).push<Object>(
      PageRouteBuilder<Object>(
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 160),
        pageBuilder: (route, _, __) => HaatPlaceSearch(
          width: double.infinity,
          height: double.infinity,
          initialQuery: _query,
          searchHint: widget.searchHint,
          nearLocation: LatLng(center.latitude, center.longitude),
          notFoundImage: widget.notFoundImage,
          onPicked: (location, name, address) async =>
              Navigator.of(route).pop(_Picked(location, name, address)),
          onUseMyLocation: () async => Navigator.of(route).pop('here'),
        ),
        transitionsBuilder: (_, animation, __, child) {
          final eased =
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: eased,
            child: SlideTransition(
              position: Tween(begin: const Offset(0.0, 0.03), end: Offset.zero)
                  .animate(eased),
              child: child,
            ),
          );
        },
      ),
    );
    if (!mounted) return;
    if (picked == 'here') return _locate();
    if (picked is _Picked) {
      _query = picked.name;
      _chosen = picked.address.isEmpty
          ? picked.name
          : '${picked.name}, ${picked.address}';
      _search.text = picked.name;
      _moveTo(
          ll.LatLng(picked.location.latitude, picked.location.longitude), 17);
    }
  }

  Future<void> _locate() async {
    if (_locating) return;
    _chosen = null;
    setState(() => _locating = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        return _tell('Turn on location, or move the map to the place.');
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        // The app's own sheet first, so the system prompt never comes cold.
        final allowed = await showModalBottomSheet<bool>(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          enableDrag: false,
          context: context,
          builder: (context) => LocationpermissionsheetWidget(),
        );
        if (allowed != true) return;
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return _tell('Location is off for HAAT. Move the map to the place.');
      }
      final here = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      ).timeout(const Duration(seconds: 15));
      if (!mounted) return;
      _moveTo(ll.LatLng(here.latitude, here.longitude), 17);
    } catch (_) {
      if (mounted) _tell('Could not find where you are. Move the map instead.');
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  Widget _pin() {
    if (widget.pinStyle == 'dot') {
      return Container(
        width: 127.0,
        height: 127.0,
        decoration: BoxDecoration(
          color: _green.withValues(alpha: 0.28),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          width: 14.0,
          height: 14.0,
          decoration: BoxDecoration(
            color: _green,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.0),
          ),
        ),
      );
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      width: 50.0,
      height: 50.0,
      transform: Matrix4.translationValues(0.0, _moving ? -8.0 : 0.0, 0.0),
      decoration: BoxDecoration(
        color: _green,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
              color: Color(0x33000000), blurRadius: 8.0, offset: Offset(0, 3)),
        ],
      ),
      alignment: Alignment.center,
      child: Image.asset('assets/images/store.png', width: 22.0, height: 22.0),
    );
  }

  Widget _hintChip() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Text(
          widget.hint!,
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 13.0,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      );

  Widget _searchBar() => Container(
        height: 47.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(29.0),
          border: Border.all(color: const Color(0xFFD9D9D9)),
        ),
        alignment: Alignment.center,
        child: TextField(
          controller: _search,
          readOnly: true,
          showCursor: false,
          onTap: _openSearch,
          textAlignVertical: TextAlignVertical.center,
          style: GoogleFonts.inter(color: Colors.black, fontSize: 14.0),
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
            prefixIcon: const Icon(Icons.search_rounded,
                size: 18.0, color: Colors.black54),
          ),
        ),
      );

  Widget _locateButton() => Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 1.0,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: _locate,
          child: SizedBox(
            width: 45.0,
            height: 45.0,
            child: Center(
              child: _locating
                  ? const SizedBox(
                      width: 18.0,
                      height: 18.0,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.0, color: Colors.black),
                    )
                  // The same crosshair the locate.png asset drew; as an icon it
                  // does not depend on a file a FlutterFlow download leaves out.
                  : const Icon(Icons.my_location,
                      size: 22.0, color: Colors.black),
            ),
          ),
        ),
      );

  Widget _fade(Alignment edge, Color color) => Positioned(
        left: 0.0,
        right: 0.0,
        top: edge == Alignment.topCenter ? 0.0 : null,
        bottom: edge == Alignment.bottomCenter ? 0.0 : null,
        height: widget.edgeFade,
        child: IgnorePointer(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: edge,
                end: edge == Alignment.topCenter
                    ? Alignment.bottomCenter
                    : Alignment.topCenter,
                colors: [color, color.withValues(alpha: 0.0)],
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final bottom = widget.controlsBottomInset ?? 0.0;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 0.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: ColoredBox(
                color: const Color(0xFFEDEDED),
                child: FlutterMap(
                  mapController: _map,
                  options: MapOptions(
                    initialCenter: _khartoum,
                    initialZoom: 14.0,
                    minZoom: 4.0,
                    maxZoom: 19.0,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                    ),
                    onTap: (_, point) => _moveTo(point),
                    onMapEvent: _onEvent,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.mycompany.haat',
                      tileBuilder: (context, tile, _) =>
                          ColorFiltered(colorFilter: _greyTiles, child: tile),
                    ),
                  ],
                ),
              ),
            ),
            if ((widget.edgeFade ?? 0.0) > 0.0) ...[
              _fade(Alignment.topCenter, const Color(0xE6000000)),
              _fade(Alignment.bottomCenter, const Color(0xF2000000)),
            ],
            // The pin marks the middle of the map; the hint hangs under it.
            Positioned.fill(
              child: IgnorePointer(
                child: Center(
                  child: Transform.translate(
                    offset: Offset(0.0, widget.hint != null ? 22.0 : 0.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _pin(),
                        if (widget.hint != null) ...[
                          const SizedBox(height: 16.0),
                          _hintChip(),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (widget.showSearch ?? false)
              Positioned(
                left: 10.0,
                right: 10.0,
                top: 14.0,
                child: _searchBar(),
              ),
            if (widget.showLocateButton ?? true)
              Positioned(
                right: 10.0,
                bottom: 10.0 + bottom,
                child: _locateButton(),
              ),
            Positioned(
              left: 8.0,
              bottom: 6.0 + bottom,
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 1.0),
                  color: const Color(0xB3FFFFFF),
                  child: Text(
                    '© OpenStreetMap',
                    style:
                        GoogleFonts.inter(color: Colors.black54, fontSize: 9.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
