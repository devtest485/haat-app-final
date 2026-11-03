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

import 'dart:convert';

import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart' as ll;

/// Where a branch is, on a small map with the store pin on it.
///
/// The point is the one pinned when the branch was added (`latitude` and
/// `longitude` on [branch]). A branch from before pins were kept is looked up by
/// its address instead; one with neither says it was never pinned. Tapping the
/// map opens the place in the phone's maps app, for directions.
///
/// Same OpenStreetMap tiles, grey filter and credit line as HaatLocationMap.
class HaatBranchMap extends StatefulWidget {
  const HaatBranchMap({
    super.key,
    this.width,
    this.height,
    this.branch,
    this.borderRadius,
  });

  final double? width;
  final double? height;
  final dynamic branch;
  final double? borderRadius;

  @override
  State<HaatBranchMap> createState() => _HaatBranchMapState();
}

const _userAgent = 'HAAT/1.0 (com.mycompany.haat)';

const _green = Color(0xFF00DA76);
const _ink = Color(0xFF111111);
const _muted = Color(0xFF8A8A8A);
const _blank = Color(0xFFEDEDED);

// Luminance, lifted a little toward white: the light grey map of the design.
const _greyTiles = ColorFilter.matrix(<double>[
  0.18, 0.61, 0.06, 0, 38, //
  0.18, 0.61, 0.06, 0, 38, //
  0.18, 0.61, 0.06, 0, 38, //
  0, 0, 0, 1, 0,
]);

class _HaatBranchMapState extends State<HaatBranchMap> {
  ll.LatLng? _point;
  bool _looking = true;

  @override
  void initState() {
    super.initState();
    _find();
  }

  @override
  void didUpdateWidget(HaatBranchMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_field('branchId', widget.branch) !=
        _field('branchId', oldWidget.branch)) {
      _find();
    }
  }

  static String? _field(String key, dynamic from) {
    if (from is! Map) return null;
    final value = from[key];
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }

  Future<void> _find() async {
    final latitude = double.tryParse(_field('latitude', widget.branch) ?? '');
    final longitude = double.tryParse(_field('longitude', widget.branch) ?? '');
    if (latitude != null && longitude != null) {
      setState(() {
        _point = ll.LatLng(latitude, longitude);
        _looking = false;
      });
      return;
    }
    final address = _field('address', widget.branch);
    if (address == null) {
      setState(() {
        _point = null;
        _looking = false;
      });
      return;
    }
    setState(() => _looking = true);
    final found = await _lookUp(address);
    if (!mounted) return;
    setState(() {
      _point = found;
      _looking = false;
    });
  }

  Future<ll.LatLng?> _lookUp(String address) async {
    try {
      final response = await http.get(
        Uri.https('nominatim.openstreetmap.org', '/search', {
          'format': 'jsonv2',
          'q': address,
          'limit': '1',
          'countrycodes': 'sd',
        }),
        headers: {'User-Agent': _userAgent},
      ).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return null;
      final rows = jsonDecode(response.body) as List<dynamic>;
      if (rows.isEmpty) return null;
      final row = rows.first as Map<String, dynamic>;
      return ll.LatLng(double.parse(row['lat'] as String),
          double.parse(row['lon'] as String));
    } catch (_) {
      return null;
    }
  }

  Future<void> _openInMaps() async {
    final point = _point;
    if (point == null) return;
    final where =
        '${point.latitude.toStringAsFixed(6)},${point.longitude.toStringAsFixed(6)}';
    await launchURL('https://www.google.com/maps/search/?api=1&query=$where');
  }

  Widget _pin() => Container(
        width: 44.0,
        height: 44.0,
        decoration: const BoxDecoration(
          color: _green,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Color(0x33000000),
                blurRadius: 8.0,
                offset: Offset(0, 3)),
          ],
        ),
        alignment: Alignment.center,
        child:
            Image.asset('assets/images/store.png', width: 20.0, height: 20.0),
      );

  Widget _chip(IconData icon, String label) => Container(
        padding: const EdgeInsets.fromLTRB(10.0, 6.0, 12.0, 6.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 6.0,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14.0, color: _ink),
            const SizedBox(width: 6.0),
            Text(
              label,
              style: GoogleFonts.inter(
                color: _ink,
                fontSize: 12.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );

  Widget _map(ll.LatLng point) => Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
              // Keyed by the point so a different branch recentres the map.
              key: ValueKey(point),
              options: MapOptions(
                initialCenter: point,
                initialZoom: 16.0,
                interactionOptions:
                    const InteractionOptions(flags: InteractiveFlag.none),
                onTap: (_, __) => _openInMaps(),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.mycompany.haat',
                  tileBuilder: (context, tile, _) =>
                      ColorFiltered(colorFilter: _greyTiles, child: tile),
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: point,
                      width: 44.0,
                      height: 44.0,
                      child: _pin(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 10.0,
            bottom: 10.0,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20.0),
                onTap: _openInMaps,
                child: _chip(Icons.directions_outlined, 'Directions'),
              ),
            ),
          ),
          Positioned(
            left: 8.0,
            bottom: 6.0,
            child: Text(
              '© OpenStreetMap',
              style: GoogleFonts.inter(color: Colors.black54, fontSize: 9.0),
            ),
          ),
        ],
      );

  Widget _notPinned() => Container(
        color: _blank,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.location_off_outlined, size: 28.0, color: _muted),
            const SizedBox(height: 8.0),
            Text(
              'This branch has no pin on the map yet',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: _muted,
                fontSize: 13.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final point = _point;
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 16.0),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _looking
              ? Container(
                  key: const ValueKey('looking'),
                  color: _blank,
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 20.0,
                    height: 20.0,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.0, color: _green),
                  ),
                )
              : point == null
                  ? KeyedSubtree(
                      key: const ValueKey('none'), child: _notPinned())
                  : KeyedSubtree(key: ValueKey(point), child: _map(point)),
        ),
      ),
    );
  }
}
