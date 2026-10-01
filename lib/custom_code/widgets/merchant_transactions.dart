// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:intl/intl.dart';

import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/transaction_api.dart';

/// HAAT's green, for the chosen filter and the arrow on money coming in.
///
/// Written out rather than taken from the theme, for the reason [BusinessLogoAvatar]
/// gives: this app's `primary` is `0x4CFFFFFF`, a translucent white, which on this
/// screen's near-white background is nothing at all.
const _haatGreen = Color(0xFF00DA76);

/// The grey the unchosen filters sit in.
const _chipRest = Color(0xFFEFEFEF);

/// The windows the screen offers, as the design drew them.
///
/// A window rather than a page size for all but the first: "last 20" is how many, the
/// rest are how far back, and the backend takes either — so the phone asks for what it
/// is showing instead of fetching everything and hiding most of it.
const _filters = <({String label, int? days, int limit})>[
  (label: 'Last 20 transactions', days: null, limit: 20),
  (label: 'Last week', days: 7, limit: 100),
  (label: 'Last 30 days', days: 30, limit: 100),
  (label: 'Last 3 months', days: 90, limit: 100),
];

/// What has actually moved through the business's account.
///
/// The screen had five rows drawn into it — "Solace Studio · Invoice paid · + SDG
/// 4,200", the same five for every merchant on the platform, including one who had
/// never taken a payment. These are the merchant's own entries, from `GET
/// /transactions`, grouped by day the way the design groups them.
///
/// ## The empty state is the design's, not this widget's
///
/// The page already has a screen drawn for a merchant with nothing yet — the coin, "No
/// Transactions", and a button to start an order. This writes `hasTransactions` into
/// App State and that screen is bound to its opposite, so the two never show at once
/// and neither one had to be redrawn here.
class MerchantTransactions extends StatefulWidget {
  const MerchantTransactions({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<MerchantTransactions> createState() => _MerchantTransactionsState();
}

class _MerchantTransactionsState extends State<MerchantTransactions> {
  List<MerchantTransaction> _rows = const [];
  int _filter = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final chosen = _filters[_filter];

    setState(() => _loading = true);

    final result = await AuthSession.instance.transactions.list(
      limit: chosen.limit,
      since: chosen.days == null
          ? null
          : DateTime.now().subtract(Duration(days: chosen.days!)),
    );

    if (!mounted) return;

    final rows =
        result is ApiSuccess<List<MerchantTransaction>> ? result.value : _rows;

    setState(() {
      _rows = rows;
      _loading = false;
    });

    // What the page's own empty screen is bound to. Written after the answer is in,
    // so a slow network shows the empty screen rather than a blank one — which is
    // also the truthful answer while nothing is known.
    FFAppState().update(() => FFAppState().hasTransactions = rows.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    if (_rows.isEmpty) return const SizedBox.shrink();

    return Container(
      width: widget.width ?? double.infinity,
      // The page gives this block the full width, so the gutter is this widget's to
      // keep — without it the amount on the right sits against the edge of the screen
      // and the last digit is clipped.
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _chips(context),
          const SizedBox(height: 16),
          for (final group in _grouped()) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
              child: Text(
                group.label,
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ),
            for (final row in group.rows) _row(context, row),
          ],
          if (_loading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _chips(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var index = 0; index < _filters.length; index++)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  if (_filter == index) return;
                  setState(() => _filter = index);
                  _load();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    // The design's green on the chosen one, and a grey pill on the
                    // rest. `theme.primary` is deliberately not used: in this app it
                    // is `0x4CFFFFFF`, a translucent white, so the selected chip came
                    // out white on a white screen and the only thing marking it was
                    // the weight of its text.
                    color: index == _filter ? _haatGreen : _chipRest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _filters[index].label,
                    style: TextStyle(
                      color: index == _filter ? Colors.black : Colors.black87,
                      fontSize: 13,
                      fontWeight:
                          index == _filter ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, MerchantTransaction row) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F1F1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              row.incoming ? Icons.south_west : Icons.north_east,
              size: 18,
              color: row.incoming ? _haatGreen : Colors.black87,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  row.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  DateFormat('hh:mm a').format(row.occurredAt),
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          Text(
            '${row.incoming ? '+' : '-'} ${row.amount}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: row.incoming ? Colors.black : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  /// The rows under a heading per day, newest day first — "Today" for today's.
  List<({String label, List<MerchantTransaction> rows})> _grouped() {
    final today = DateUtils.dateOnly(DateTime.now());
    final groups = <String, List<MerchantTransaction>>{};

    for (final row in _rows) {
      final day = DateUtils.dateOnly(row.occurredAt);
      final label = day == today
          ? 'Today'
          : day == today.subtract(const Duration(days: 1))
              ? 'Yesterday'
              : DateFormat('d/M/yy').format(day);

      groups.putIfAbsent(label, () => []).add(row);
    }

    return [
      for (final entry in groups.entries) (label: entry.key, rows: entry.value),
    ];
  }
}
