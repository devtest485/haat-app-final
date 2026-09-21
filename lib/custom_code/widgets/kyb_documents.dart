// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:file_selector/file_selector.dart';

import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/kyc_api.dart';

/// What the business has to produce, in the order a merchant would reach for them.
///
/// The keys are the backend's: `POST /kyc/organization/documents` validates the kind
/// against its own list and refuses anything filed against the wrong subject, so a
/// screen that sent its own labels would be refused with a message about a document
/// nobody recognises.
const _kinds = <({String kind, String label, String hint})>[
  (
    kind: 'trade_licence',
    label: 'Trade licence',
    hint: 'The licence the business trades under',
  ),
  (
    kind: 'tax_certificate',
    label: 'Tax certificate',
    hint: 'Your tax registration certificate',
  ),
  (
    kind: 'proof_of_address',
    label: 'Proof of address',
    hint: 'A bill or lease showing the premises',
  ),
];

/// The business's documents: what is in, what is missing, and a way to send one.
///
/// The screen it replaces was a picture of a box saying "Upload Documents" and nothing
/// behind it — a merchant could tap it all day and the back office would never see a
/// thing. This lists what verification actually needs, marks off what has arrived, and
/// sends each file to the case the reviewers open.
///
/// ## Once it is submitted it is not theirs
///
/// The backend refuses changes on a case that is with the back office, so when the case
/// stops being editable this says so rather than offering an upload that would come
/// back refused.
class KybDocuments extends StatefulWidget {
  const KybDocuments({
    super.key,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;

  @override
  State<KybDocuments> createState() => _KybDocumentsState();
}

class _KybDocumentsState extends State<KybDocuments> {
  KycCase? _case;
  String _busy = '';
  String _problem = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final result = await AuthSession.instance.kyc.businessCase();
    if (!mounted) return;

    setState(() {
      if (result is ApiSuccess<KycCase>) {
        _case = result.value;
        _problem = '';
      } else {
        _problem = result.messageIn(AuthSession.instance.languageCode);
      }
    });
  }

  Future<void> _pick(String kind) async {
    if (_busy.isNotEmpty) return;

    // Images and PDFs, which is exactly what the backend accepts — a licence is
    // usually a scan, and a photograph of one the other half of the time. The system
    // document picker rather than the gallery, because a PDF is not in the gallery.
    const documents = XTypeGroup(
      label: 'Documents',
      extensions: <String>['jpg', 'jpeg', 'png', 'webp', 'pdf'],
      mimeTypes: <String>[
        'image/jpeg',
        'image/png',
        'image/webp',
        'application/pdf',
      ],
    );

    final file = await openFile(acceptedTypeGroups: const [documents]);
    if (file == null) return;

    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) return;

    setState(() {
      _busy = kind;
      _problem = '';
    });

    final result = await AuthSession.instance.kyc.uploadBusinessDocument(
      kind: kind,
      bytes: bytes,
      filename: file.name,
    );

    if (!mounted) return;

    setState(() {
      _busy = '';
      if (result is ApiSuccess<KycCase>) {
        _case = result.value;
      } else {
        // The server's own words: it knows whether the file was too large, the wrong
        // format, or the case simply is not the merchant's any more.
        _problem = result.messageIn(AuthSession.instance.languageCode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final held = _case;
    final editable = held?.editable ?? true;

    return Container(
      width: widget.width ?? double.infinity,
      constraints: BoxConstraints(minHeight: widget.height ?? 200),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (held != null && !editable)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _statusLine(held.status),
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
          for (final entry in _kinds) _row(entry, held, editable, theme),
          if (_problem.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                _problem,
                style: TextStyle(color: theme.error, fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }

  Widget _row(
    ({String kind, String label, String hint}) entry,
    KycCase? held,
    bool editable,
    FlutterFlowTheme theme,
  ) {
    final uploaded = held?.has(entry.kind) ?? false;
    final busy = _busy == entry.kind;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        onTap: editable && !busy ? () => _pick(entry.kind) : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF242424),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: uploaded ? theme.primary : Colors.white24,
            ),
          ),
          child: Row(
            children: [
              Icon(
                uploaded ? Icons.check_circle : Icons.attach_file,
                color: uploaded ? theme.primary : Colors.white70,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      uploaded ? 'Uploaded' : entry.hint,
                      style:
                          const TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (busy)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (editable)
                Text(
                  uploaded ? 'Replace' : 'Upload',
                  style: TextStyle(color: theme.primary, fontSize: 13),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// What the case's state means to the person who sent it.
  String _statusLine(String status) => switch (status) {
        'submitted' => 'Sent for review. You will hear from us shortly.',
        'in_review' => 'Being reviewed. Nothing more is needed from you.',
        'approved' => 'Your business is verified.',
        'rejected' => 'Something was not accepted. You can send it again.',
        'expired' => 'These documents are out of date. Please send them again.',
        _ => '',
      };
}
