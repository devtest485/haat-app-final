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
import '/custom_code/wallet_api.dart';

/// The home screen's balance, from the books.
///
/// It was `24,580.00 SDG`, drawn into the app — the same figure on every merchant's home
/// screen, including one who had never taken a payment. This is what the business can
/// actually spend: the available balance across its banks.
///
/// Drawn as the design draws it, the whole part large and the fraction small beside the
/// currency. Until the figure arrives it shows a dash rather than a zero, because a zero
/// is a balance and a dash is not yet knowing one.
class WalletBalance extends StatefulWidget {
  const WalletBalance({super.key, this.width, this.height});

  final double? width;
  final double? height;

  @override
  State<WalletBalance> createState() => _WalletBalanceState();
}

class _WalletBalanceState extends State<WalletBalance> {
  Wallet? _wallet;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await AuthSession.instance.wallet.get();
    if (!mounted) return;

    if (result is ApiSuccess<Wallet>) {
      setState(() => _wallet = result.value);

      // The number under the balance is the wallet's own. Written here because this is
      // where the wallet is read; the line beneath listens to App State for it.
      FFAppState().update(() => FFAppState().bban = result.value.displayNumber);
    }
  }

  TextStyle _style(BuildContext context, double size) =>
      FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.inter(
              fontWeight: FontWeight.w300,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            color: FlutterFlowTheme.of(context).primaryText,
            fontSize: size,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w300,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          );

  @override
  Widget build(BuildContext context) {
    final wallet = _wallet;

    if (wallet == null) return Text('—', style: _style(context, 42));

    final (whole, fraction) = splitMinor(wallet.available, wallet.currency);

    return RichText(
      textScaler: MediaQuery.of(context).textScaler,
      text: TextSpan(
        children: [
          TextSpan(text: whole, style: _style(context, 42)),
          TextSpan(text: '$fraction ${wallet.currency}', style: _style(context, 18)),
        ],
      ),
    );
  }
}
