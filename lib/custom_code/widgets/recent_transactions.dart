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

import 'package:intl/intl.dart';

import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/transaction_api.dart';

/// HAAT's green, for the arrow on money coming in.
///
/// The theme's `primary` is `0x4CFFFFFF` in this app — a translucent white, and this
/// card sits on white. See [BusinessLogoAvatar].
const _haatGreen = Color(0xFF00DA76);

/// The last few movements, on the home screen.
///
/// The design drew two rows and the app shipped them: "Solace Studio · Invoice paid ·
/// + SDG 4,200", twice, on the home screen of every merchant on the platform — a
/// merchant who had taken no payment at all was shown two.
///
/// These are the real ones, newest first. Nothing at all when there are none, because
/// a merchant who has not traded yet is better told that by the empty space under a
/// heading than by somebody else's invoices.
class RecentTransactions extends StatefulWidget {
  const RecentTransactions({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  List<MerchantTransaction> _rows = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    // Three: what the design's card has room for without the page scrolling to reach
    // the cards underneath. "View all" is what the rest is for.
    final result = await AuthSession.instance.transactions.list(limit: 3);
    if (!mounted) return;

    if (result is ApiSuccess<List<MerchantTransaction>>) {
      setState(() => _rows = result.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_rows.isEmpty) return const SizedBox.shrink();

    return Container(
      width: widget.width ?? double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [for (final row in _rows) _row(context, row)],
      ),
    );
  }

  Widget _row(BuildContext context, MerchantTransaction row) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F1F1),
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
                  DateFormat('d MMM · hh:mm a').format(row.occurredAt),
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          Text(
            '${row.incoming ? '+' : '-'} ${row.amount}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
