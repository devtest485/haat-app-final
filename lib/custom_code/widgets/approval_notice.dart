// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';

/// Tells a merchant their business is still waiting for HAAT, or has been stopped.
///
/// Every business starts `pending` at registration, documents or not, and the back
/// office approves it. Until then the app opens as usual — a merchant can look around
/// and send their documents — but taking a payment or asking for a payout is refused
/// by the server. Without this the first they would hear of it is that refusal, in
/// the middle of serving a customer.
///
/// Draws nothing for an approved business, while it is still asking, and when the
/// question could not be answered: a notice that might be wrong is worse than none,
/// and the server still refuses what a pending business may not do.
class ApprovalNotice extends StatefulWidget {
  const ApprovalNotice({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<ApprovalNotice> createState() => _ApprovalNoticeState();
}

class _ApprovalNoticeState extends State<ApprovalNotice> {
  String? _status;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await AuthSession.instance.organizations.currentStatus();
    if (!mounted) return;

    if (result is ApiSuccess<String?>) setState(() => _status = result.value);
  }

  @override
  Widget build(BuildContext context) {
    final status = _status;
    if (status != 'pending' && status != 'suspended') {
      return const SizedBox.shrink();
    }

    final arabic = AuthSession.instance.languageCode == 'ar';
    final suspended = status == 'suspended';
    final colour = suspended
        ? FlutterFlowTheme.of(context).error
        : const Color(0xFFE0A526);

    final title = suspended
        ? (arabic ? 'تم إيقاف نشاطك التجاري' : 'Your business is suspended')
        : (arabic ? 'بانتظار موافقة هات' : 'Waiting for approval');
    final body = suspended
        ? (arabic
            ? 'لا يمكنك استقبال المدفوعات أو طلب التحويلات. تواصل مع دعم هات.'
            : 'You cannot take payments or ask for payouts. Contact HAAT support.')
        : (arabic
            ? 'تراجع هات نشاطك التجاري. يمكنك استخدام التطبيق، وتُفتح المدفوعات والتحويلات بعد الموافقة.'
            : 'HAAT is reviewing your business. You can use the app; payments and payouts open once it is approved.');

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 16.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: colour.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: colour.withValues(alpha: 0.5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              suspended ? Icons.block_rounded : Icons.hourglass_top_rounded,
              color: colour,
              size: 22.0,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: colour,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    body,
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primaryText,
                      fontSize: 12.5,
                      height: 1.35,
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
