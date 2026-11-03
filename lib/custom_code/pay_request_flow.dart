import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '/app_state.dart';
import '/custom_code/api_envelope.dart';
import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/authorize_dialog.dart';
import '/custom_code/pay_request_api.dart';
import '/custom_code/payout_api.dart' show toMinor;
import '/custom_code/transfer_api.dart';
import '/custom_code/wallet_api.dart';
import '/custom_code/widgets/wallet_balance.dart';
import '/flutter_flow/flutter_flow_util.dart';

// What QRpayOutPage, LinkPayOutPage and PayRequestApproval do, for the custom actions and
// widgets on them. The pages keep a request or a preview as JSON — the plain words and
// numbers they show — and hand it back to the actions here.

const _ink = Color(0xFF111111);
const _muted = Color(0xFF6B6B72);
const _page = Color(0xFFF5F5F7);
const _hairline = Color(0xFFE4E4E9);

/// The approval page's route.
const payRequestApprovalRoute = 'PayRequestApproval';

String _money(BigInt minor, String currency) {
  final (whole, fraction) = splitMinor(minor, currency);
  return '$whole$fraction $currency';
}

String _shortReference(String id) => id.split('-').first.toUpperCase();

String _field(dynamic json, String name) {
  final value = json is Map ? json[name] : null;
  final text = value == null ? '' : '$value'.trim();
  return text == 'null' ? '' : text;
}

/// [name] of a request or preview the pages keep, as text; '' when it is not there.
String payRequestField(dynamic json, String name) => _field(json, name);

String _initials(String name) {
  final words =
      name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  if (words.isEmpty) return 'H';
  if (words.length == 1) return words.first[0].toUpperCase();
  return '${words.first[0]}${words.last[0]}'.toUpperCase();
}

void _toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// The `outcome` the PaymentStatus page reads, with `paymentStatus` — Success, Pending
/// or Error — to open it with.
Map<String, dynamic> _statusOutcome(
  String paymentStatus,
  List<(String, String)> lines, {
  required String share,
  String? title,
  String? amount,
  String? currency,
  String? subtitle,
  String? status,
}) =>
    {
      'paymentStatus': paymentStatus,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (subtitle != null) 'subtitle': subtitle,
      if (status != null) 'status': status,
      'details': [
        for (final (label, value) in lines) {'label': label, 'value': value},
      ],
      'shareText': [
        share,
        for (final (label, value) in lines) '$label: $value',
      ].join('\n'),
    };

// ══ Opening a request ══════════════════════════════════════════════════════════════

/// Opens the approval page for another business's request [code].
void openPayRequest(BuildContext context, String code) {
  context.pushNamed(
    payRequestApprovalRoute,
    queryParameters:
        {'code': serializeParam(code, ParamType.String)}.withoutNulls,
  );
}

// ══ Asking to be paid ══════════════════════════════════════════════════════════════

/// Asks whoever holds the phone for the passcode or a fingerprint before asking a
/// customer for [amount] — by tap, QR or link — so a phone left on the counter can't
/// take payments in its owner's name.
///
/// Returns `{ok: true}` once given, `{}` when the person closed the dialog.
Future<Map<String, dynamic>> confirmItsYou(
  BuildContext context,
  String amount,
) async {
  final session = AuthSession.instance;
  final checks = await Future.wait<Object?>([
    session.biometrics.availability(),
    session.wallet.get().timeout(
          const Duration(seconds: 2),
          onTimeout: () => const ApiUnreachable<Wallet>('timeout',
              message: '', messageAr: ''),
        ),
  ]);
  final fingerprint = checks[0] == null;
  final wallet = checks[1];
  final currency = wallet is ApiSuccess<Wallet> ? wallet.value.currency : 'SDG';
  final minor = toMinor(amount, currency);
  if (minor == null || minor <= BigInt.zero) {
    if (context.mounted) _toast(context, 'Enter an amount above zero first.');
    return {};
  }

  String? error;
  while (context.mounted) {
    final credential = await showAuthorizeDialog(
      context,
      amount: _money(minor, currency),
      name: 'your customer',
      preposition: 'from',
      fingerprint: fingerprint,
      verb: 'request',
      biometricTitle: 'Confirm it’s you',
      error: error,
      // Signing anything with the fingerprint key needs the fingerprint: proof
      // enough on this phone that its owner is holding it.
      challenge: () async => ApiSuccess(const Uuid().v4(), _localEnvelope),
    );
    if (!context.mounted || credential == null) return {};
    if (credential.signature != null) return _confirmed(context);

    final checked =
        await session.api.verifyPasscode(passcode: credential.passcode ?? '');
    if (!context.mounted) return {};
    if (checked case ApiSuccess<bool>(value: true)) return _confirmed(context);
    error = switch (checked) {
      ApiUnreachable<bool>() => 'You’re offline. Connect, then try again.',
      ApiSuccess<bool>() => 'That passcode isn’t right. Try again.',
      ApiFailure<bool>() => checked.messageIn(session.languageCode),
    };
  }
  return {};
}

const _localEnvelope = ApiEnvelope(
  isSuccess: true,
  title: '',
  titleAr: '',
  message: '',
  messageAr: '',
  data: <String, dynamic>{},
  responseCode: 200,
);

Map<String, dynamic> _confirmed(BuildContext context) {
  HapticFeedback.selectionClick();
  _toast(context, 'Confirmed — you can take the payment now.');
  return {'ok': true};
}

/// Kept across a retry of the same amount, so a request HAAT made but never answered
/// is not made twice.
final _createReferences = <String, String>{};

/// Makes a one-time QR ([link] false) or payment link for [amount], as typed.
///
/// Returns the request as the page keeps it — id, code, link, invoice, amount,
/// currency, the business's name and logo — or `{error}`, a sentence to show.
Future<Map<String, dynamic>> createPayRequest({
  required String amount,
  required bool link,
}) async {
  final session = AuthSession.instance;
  final wallet = await session.wallet.get();
  final currency = wallet is ApiSuccess<Wallet> ? wallet.value.currency : 'SDG';
  final minor = toMinor(amount, currency);
  if (minor == null || minor <= BigInt.zero) {
    return {'error': 'Enter an amount above zero first.'};
  }

  final slot = '$link|$minor|$currency';
  final reference = _createReferences[slot] ??= const Uuid().v4();
  final created = await session.payRequests.create(
    link: link,
    amountMinor: minor,
    currency: currency,
    reference: reference,
  );
  if (created is! ApiSuccess<PaymentRequest>) {
    // Refused means nothing was made; the next try is a new request. A dropped
    // answer keeps the reference, so the retry finds the one already made.
    if (created is ApiFailure<PaymentRequest>) _createReferences.remove(slot);
    return {'error': created.messageIn(session.languageCode)};
  }
  _createReferences.remove(slot);

  var logo = FFAppState().businessLogoUrl;
  if (logo.isEmpty) {
    final known = await session.organizations.currentLogoUrl();
    if (known is ApiSuccess<String?>) logo = known.value ?? '';
  }
  return _requestJson(created.value, link: link, logoUrl: logo);
}

Map<String, dynamic> _requestJson(
  PaymentRequest r, {
  required bool link,
  required String logoUrl,
}) {
  final (whole, fraction) = splitMinor(r.amountMinor, r.currency);
  return {
    'id': r.id,
    'code': r.code,
    'link': r.link,
    'linkText': r.link.replaceFirst(RegExp(r'^https?://'), ''),
    'isLink': link,
    'merchantName': r.merchantName,
    'initials': _initials(r.merchantName),
    'logoUrl': logoUrl,
    'invoice': r.invoiceReference ?? r.code,
    'invoiceReference': r.invoiceReference ?? '',
    'amount': '$whole$fraction',
    'currency': r.currency,
    'amountMinor': r.amountMinor.toString(),
    'status': r.status,
    if (r.expiresAt != null) 'expiresAt': r.expiresAt!.toIso8601String(),
  };
}

/// Waits on the page that shows [request] until it is paid, or cannot be.
///
/// Asks HAAT every few seconds. Returns the PaymentStatus outcome once paid
/// (`paymentStatus` Success), `{problem}` once it expired or was cancelled, and `{}`
/// once the page is closed.
Future<Map<String, dynamic>> awaitPayRequest(
  BuildContext context,
  dynamic request,
) async {
  final id = _field(request, 'id');
  if (id.isEmpty) return {};
  final link = _field(request, 'isLink') == 'true';
  final what = link ? 'link' : 'QR';
  final expiresAt = DateTime.tryParse(_field(request, 'expiresAt'));

  while (context.mounted) {
    await Future.delayed(const Duration(seconds: 4));
    if (!context.mounted) return {};

    final result = await AuthSession.instance.payRequests.list();
    if (!context.mounted) return {};
    final now = result is ApiSuccess<List<PaymentRequest>>
        ? result.value.where((r) => r.id == id).firstOrNull
        : null;

    if (now != null && now.isPaid) {
      HapticFeedback.mediumImpact();
      WalletBalance.refreshNow();
      final (whole, fraction) = splitMinor(now.amountMinor, now.currency);
      final lines = [
        if (now.invoiceReference != null) ('Invoice', now.invoiceReference!),
        ('Request code', now.code),
        ('Paid by', link ? 'Payment link' : 'QR code'),
        (
          'Date & time',
          dateTimeFormat('d MMM y · HH:mm', now.paidAt ?? DateTime.now())
        ),
      ];
      return _statusOutcome(
        'Success',
        lines,
        title: 'Payment received',
        amount: '$whole$fraction',
        currency: now.currency,
        subtitle: 'Paid into your HAAT wallet',
        share: 'HAAT payment received\n'
            '${_money(now.amountMinor, now.currency)} from a ${link ? 'payment link' : 'QR code'}',
      );
    }
    if (now?.status == 'cancelled') {
      return {
        'problem': 'This $what was cancelled. Tap Try again for a new one.'
      };
    }
    final expired = now?.status == 'expired' ||
        (expiresAt != null && !expiresAt.isAfter(DateTime.now()));
    if (expired) {
      return {
        'problem': 'This $what has expired. Tap Try again for a new one.'
      };
    }
  }
  return {};
}

/// Puts the QR card in Photos, or copies the payment link.
Future<void> keepPayRequest(BuildContext context, dynamic request) async {
  final code = _field(request, 'code');
  if (code.isEmpty) {
    _toast(context, 'One moment — the request is still being made.');
    return;
  }

  if (_field(request, 'isLink') == 'true') {
    await Clipboard.setData(ClipboardData(text: _field(request, 'link')));
    HapticFeedback.selectionClick();
    if (context.mounted) _toast(context, 'Link copied');
    return;
  }

  try {
    if (!await Gal.hasAccess() && !await Gal.requestAccess()) {
      if (context.mounted) {
        _toast(context, 'Allow HAAT to add to Photos in Settings.');
      }
      return;
    }
    final png = await payRequestCardPng(request);
    if (png == null) {
      if (context.mounted) _toast(context, 'Couldn’t draw the QR. Try again.');
      return;
    }
    await Gal.putImageBytes(png, name: 'HAAT-$code');
    HapticFeedback.lightImpact();
    if (context.mounted) _toast(context, 'Saved to Photos');
  } on GalException catch (error) {
    if (context.mounted) _toast(context, error.type.message);
  }
}

String _shareMessage(dynamic request) {
  final link = _field(request, 'isLink') == 'true';
  final expiresAt = DateTime.tryParse(_field(request, 'expiresAt'));
  return [
    '${_field(request, 'merchantName')} is requesting '
        '${_field(request, 'amount')} ${_field(request, 'currency')} on HAAT.',
    '',
    link
        ? 'Tap to pay securely in the HAAT app:'
        : 'Scan the QR with HAAT, or tap to pay securely:',
    _field(request, 'link'),
    '',
    if (_field(request, 'invoiceReference').isNotEmpty)
      'Invoice: ${_field(request, 'invoiceReference')}',
    if (expiresAt != null)
      'Valid until ${dateTimeFormat('d MMM, HH:mm', expiresAt)} · can be paid once.',
  ].join('\n');
}

/// Shares the request: the QR card with a HAAT message, or the link in one.
Future<void> sharePayRequest(BuildContext context, dynamic request) async {
  final code = _field(request, 'code');
  if (code.isEmpty) {
    _toast(context, 'One moment — the request is still being made.');
    return;
  }
  final png = _field(request, 'isLink') == 'true'
      ? null
      : await payRequestCardPng(request);
  await SharePlus.instance.share(ShareParams(
    subject: 'HAAT payment request from ${_field(request, 'merchantName')}',
    text: _shareMessage(request),
    files: png == null ? null : [XFile.fromData(png, mimeType: 'image/png')],
    fileNameOverrides: png == null ? null : ['HAAT-$code.png'],
  ));
}

// ── The card saved and shared ────────────────────────────────────────────────────

Future<ui.Image?> _networkImage(String url) {
  if (url.isEmpty) return Future.value(null);
  final completer = Completer<ui.Image?>();
  final stream =
      CachedNetworkImageProvider(url).resolve(ImageConfiguration.empty);
  late final ImageStreamListener listener;
  listener = ImageStreamListener(
    (info, _) {
      if (!completer.isCompleted) completer.complete(info.image.clone());
      stream.removeListener(listener);
    },
    onError: (_, __) {
      if (!completer.isCompleted) completer.complete(null);
      stream.removeListener(listener);
    },
  );
  stream.addListener(listener);
  return completer.future
      .timeout(const Duration(seconds: 6), onTimeout: () => null);
}

TextPainter _line(
  String text,
  double size, {
  FontWeight weight = FontWeight.w500,
  Color color = _ink,
  double spacing = 0,
  double maxWidth = 312,
  TextAlign align = TextAlign.center,
}) =>
    TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.montserrat(
          fontSize: size,
          fontWeight: weight,
          color: color,
          letterSpacing: spacing,
        ),
      ),
      textAlign: align,
      textDirection: ui.TextDirection.ltr,
      maxLines: 1,
      ellipsis: '…',
    )..layout(maxWidth: maxWidth);

/// Who is asking, the invoice, the QR with the logo in its middle and the amount, as
/// a PNG sharp enough to print.
Future<Uint8List?> payRequestCardPng(dynamic request) async {
  const scale = 3.0;
  const width = 360.0;
  const side = 24.0;
  const qrSize = 216.0;
  final data = _field(request, 'link');
  if (data.isEmpty) return null;

  try {
    await GoogleFonts.pendingFonts().timeout(const Duration(seconds: 3));
  } catch (_) {}
  final logo = await _networkImage(_field(request, 'logoUrl'));
  final name = _field(request, 'merchantName');
  final initials = _field(request, 'initials');

  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder)..scale(scale);
  canvas.drawRect(
      const Rect.fromLTWH(0, 0, width, 1000), Paint()..color = _page);

  const card = Rect.fromLTWH(16, 16, width - 32, 0);
  var y = card.top + side;
  final paint = <void Function(Canvas)>[];

  // Who is asking.
  final title = _line(name, 15,
      weight: FontWeight.w600, maxWidth: 200, align: TextAlign.left);
  final kind =
      _line('Payment request', 11, color: _muted, align: TextAlign.left);
  final brand = _line('HAAT', 13, weight: FontWeight.w700, spacing: 2.4);
  final top = y;
  paint.add((c) {
    _drawBadge(
        c, Rect.fromLTWH(card.left + side, top, 36, 36), logo, initials, 18);
    title.paint(c, Offset(card.left + side + 46, top));
    kind.paint(c, Offset(card.left + side + 46, top + 20));
    brand.paint(c, Offset(card.right - side - brand.width, top + 10));
  });
  y += 36 + 18;
  final rule = y;
  paint.add((c) => c.drawRect(
      Rect.fromLTWH(card.left + side, rule, card.width - side * 2, 1),
      Paint()..color = _hairline));
  y += 1 + 18;

  // The invoice.
  final invoiceLabel = _line('Invoice Number', 11, color: _muted);
  final invoice =
      _line(_field(request, 'invoice'), 22, weight: FontWeight.w600);
  final invoiceTop = y;
  paint.add((c) {
    invoiceLabel.paint(c, Offset((width - invoiceLabel.width) / 2, invoiceTop));
    invoice.paint(c, Offset((width - invoice.width) / 2, invoiceTop + 18));
  });
  y += 18 + invoice.height + 18;

  // The QR.
  final qrTop = y;
  final qr = QrPainter(
    data: data,
    version: QrVersions.auto,
    errorCorrectionLevel: QrErrorCorrectLevel.H,
    gapless: true,
    eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: _ink),
    dataModuleStyle: const QrDataModuleStyle(
      dataModuleShape: QrDataModuleShape.square,
      color: _ink,
    ),
  );
  paint.add((c) {
    c.save();
    c.translate((width - qrSize) / 2, qrTop);
    qr.paint(c, const Size(qrSize, qrSize));
    c.restore();
    const badge = qrSize * 0.22;
    final centre = Offset(width / 2, qrTop + qrSize / 2);
    c.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromCenter(center: centre, width: badge + 8, height: badge + 8),
          const Radius.circular(12)),
      Paint()..color = Colors.white,
    );
    _drawBadge(c, Rect.fromCenter(center: centre, width: badge, height: badge),
        logo, initials, 9);
  });
  y += qrSize + 20;

  // How much.
  final amountLabel = _line('Amount', 11, color: _muted);
  final amount = TextPainter(
    text: TextSpan(children: [
      TextSpan(
        text: '${_field(request, 'amount')} ',
        style: GoogleFonts.montserrat(
            fontSize: 26, fontWeight: FontWeight.w600, color: _ink),
      ),
      TextSpan(
        text: _field(request, 'currency'),
        style: GoogleFonts.montserrat(
            fontSize: 16, fontWeight: FontWeight.w500, color: _muted),
      ),
    ]),
    textDirection: ui.TextDirection.ltr,
    maxLines: 1,
  )..layout(maxWidth: 312);
  final amountTop = y;
  paint.add((c) {
    amountLabel.paint(c, Offset((width - amountLabel.width) / 2, amountTop));
    amount.paint(c, Offset((width - amount.width) / 2, amountTop + 18));
  });
  y += 18 + amount.height + 16;

  // Until when. It is paid by scanning, so there is no code to type.
  final expiresAt = DateTime.tryParse(_field(request, 'expiresAt'));
  final footer = _line(
    [
      'Scan with HAAT to pay',
      if (expiresAt != null)
        'Valid until ${dateTimeFormat('d MMM, HH:mm', expiresAt)}',
    ].join('  ·  '),
    11,
    color: _muted,
  );
  final footerTop = y;
  paint.add(
      (c) => footer.paint(c, Offset((width - footer.width) / 2, footerTop)));
  y += footer.height + side;

  final cardRect = Rect.fromLTRB(card.left, card.top, card.right, y);
  canvas.drawRRect(RRect.fromRectAndRadius(cardRect, const Radius.circular(24)),
      Paint()..color = Colors.white);
  for (final p in paint) {
    p(canvas);
  }

  final height = y + 16;
  final picture = recorder.endRecording();
  final image =
      await picture.toImage((width * scale).round(), (height * scale).round());
  picture.dispose();
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  image.dispose();
  logo?.dispose();
  return bytes?.buffer.asUint8List();
}

void _drawBadge(
    Canvas c, Rect rect, ui.Image? logo, String initials, double radius) {
  final shape = RRect.fromRectAndRadius(rect, Radius.circular(radius));
  c.save();
  c.clipRRect(shape);
  if (logo != null) {
    paintImage(canvas: c, rect: rect, image: logo, fit: BoxFit.cover);
  } else {
    c.drawRect(rect, Paint()..color = _ink);
    final text = _line(initials.isEmpty ? 'H' : initials, rect.height * 0.36,
        weight: FontWeight.w700, color: Colors.white);
    text.paint(
        c,
        Offset(
            rect.center.dx - text.width / 2, rect.center.dy - text.height / 2));
  }
  c.restore();
}

// ══ Paying a request ═══════════════════════════════════════════════════════════════

/// Who is asking for how much, from HAAT, for the approval page.
///
/// Returns `{error}` when it cannot be read. Otherwise the requester (name, handle
/// line, logo, initials), invoice, amount, currency, a summary line (fee, total,
/// until when) and `blocker`: why this business cannot pay it, empty when it can.
Future<Map<String, dynamic>> previewPayRequest(String code) async {
  final session = AuthSession.instance;
  final results = await Future.wait([
    session.payRequests.preview(code),
    session.wallet.get(),
  ]);
  final preview = results[0] as ApiResult<PaymentRequestPreview>;
  final wallet = results[1] as ApiResult<Wallet>;

  if (preview is! ApiSuccess<PaymentRequestPreview>) {
    final missing = preview.errorCode == 'NOT_FOUND' ||
        preview.errorCode == 'PAYMENT_REQUEST_NOT_FOUND';
    return {
      'error': missing
          ? 'This code isn’t a HAAT payment request. Check it with the business that sent it.'
          : preview.messageIn(session.languageCode),
    };
  }

  final p = preview.value;
  final requester = p.requester;
  final handle = requester.username ?? requester.handle;
  final amountMinor = p.amountMinor ?? BigInt.zero;
  final (whole, fraction) = splitMinor(amountMinor, p.currency);
  final fee = p.feeMinor ?? BigInt.zero;
  final total = p.totalMinor ?? amountMinor;
  final blocker =
      _blocker(p, wallet is ApiSuccess<Wallet> ? wallet.value : null);

  return {
    'code': p.code,
    'requesterName': requester.name,
    'verified': requester.verified,
    'handleLine': [
      if (handle.isNotEmpty) '@$handle',
      if (requester.mobileMasked != null) requester.mobileMasked!,
    ].join('  ·  '),
    'logoUrl': requester.logoUrl ?? '',
    'initials': requester.initials,
    'invoice': p.invoiceReference ?? p.code,
    'invoiceReference': p.invoiceReference ?? '',
    'amount': '$whole$fraction',
    'currency': p.currency,
    'total': _money(total, p.currency),
    'summary': [
      fee > BigInt.zero ? 'Fee ${_money(fee, p.currency)}' : 'No fee',
      'Total ${_money(total, p.currency)}',
    ].join('  ·  '),
    'until': p.expiresAt == null || p.status != 'open'
        ? ''
        : 'Valid until ${dateTimeFormat('d MMM, HH:mm', p.expiresAt)}',
    'blocker': blocker ?? '',
    'payable': blocker == null,
  };
}

/// Why this business cannot pay [p], in words; null when it can.
String? _blocker(PaymentRequestPreview p, Wallet? wallet) {
  if (p.status == 'paid') return 'This request has already been paid.';
  if (p.status == 'cancelled') {
    return '${p.requester.name} cancelled this request.';
  }
  if (p.status == 'expired' ||
      (p.expiresAt != null && !p.expiresAt!.isAfter(DateTime.now()))) {
    return 'This request has expired. Ask ${p.requester.name} for a new one.';
  }
  if (!p.payable) {
    return switch (p.refusal) {
      'own_request' =>
        'This is your own request. Share it with the business that’s paying you.',
      'other_bank' =>
        'This request is for a different bank than your HAAT wallet.',
      'no_amount' =>
        'This code has no amount. Ask for a payment QR or link instead.',
      'no_rule' => 'Your bank doesn’t allow this payment yet.',
      'over_limit' => 'This amount is outside what your bank allows.',
      _ => 'This request can’t be paid right now.',
    };
  }
  final total = p.totalMinor ?? p.amountMinor;
  if (total != null &&
      wallet != null &&
      wallet.currency == p.currency &&
      total > wallet.available) {
    return 'Not enough in your wallet. Available: ${_money(wallet.available, wallet.currency)}.';
  }
  return null;
}

/// The payment for each request code, kept until HAAT answers it: a fingerprint
/// retried after a dropped answer, or a second tap, finds the same payment.
final _payReferences = <String, String>{};

/// Asks for the passcode or a fingerprint over this very request, then pays it.
///
/// Returns the PaymentStatus outcome with `paymentStatus` — Success, Pending or
/// Error — or `{}` when the person closed the dialog. HAAT pays a request once, to the
/// business that made it, whatever the QR or link said.
Future<Map<String, dynamic>> approvePayRequest(
  BuildContext context,
  dynamic preview,
) async {
  final code = _field(preview, 'code');
  if (code.isEmpty || _field(preview, 'payable') != 'true') return {};

  final session = AuthSession.instance;
  final name = _field(preview, 'requesterName');
  final fingerprint = await session.biometrics.availability() == null;
  String? refusal;

  while (context.mounted) {
    final reference = _payReferences[code] ??= const Uuid().v4();
    final credential = await showAuthorizeDialog(
      context,
      amount: _field(preview, 'total'),
      name: name,
      fingerprint: fingerprint,
      verb: 'pay',
      biometricTitle: 'Confirm payment',
      error: refusal,
      // Read when the fingerprint is used, so it signs the reference then in force.
      challenge: () =>
          session.payRequests.challenge(code: code, reference: reference),
    );
    if (!context.mounted || credential == null) return {};

    final result = await session.payRequests.pay(
      code: code,
      reference: reference,
      passcode: credential.passcode,
      biometricSignature: credential.signature,
    );

    if (result is ApiSuccess<TransferReceipt>) {
      _payReferences.remove(code);
      HapticFeedback.mediumImpact();
      WalletBalance.refreshNow();
      return _receiptOutcome(result.value, preview);
    }

    if (result is ApiFailure<TransferReceipt>) {
      final field = result.data['field'];
      // A refused credential keeps the reference: nothing moved.
      if (field == 'passcode' || field == 'biometric') {
        refusal = result.messageIn(session.languageCode);
        continue;
      }
      // Refused for any other reason: nothing was paid, so the next try is new.
      _payReferences.remove(code);
    }
    // A dropped connection keeps the reference, so a retry cannot pay twice.
    HapticFeedback.heavyImpact();
    final offline = result is ApiUnreachable<TransferReceipt>;
    final reason = offline
        ? 'You’re offline. Nothing was paid twice — try again once you’re connected.'
        : result.messageIn(session.languageCode);
    return _statusOutcome(
      'Error',
      [
        ('Amount', _field(preview, 'total')),
        ('Request code', code),
        ('Reference number', _shortReference(reference)),
        ('Date & Time', dateTimeFormat('d MMM y · HH:mm', DateTime.now())),
        if (reason.trim().isNotEmpty) ('Reason', reason.trim()),
      ],
      status: 'failed',
      share: 'HAAT payment, not completed',
    );
  }
  return {};
}

Map<String, dynamic> _receiptOutcome(TransferReceipt receipt, dynamic preview) {
  final code = _field(preview, 'code');
  final invoice = _field(preview, 'invoiceReference');
  final when = dateTimeFormat('d MMM y · HH:mm', receipt.occurredAt);

  if (receipt.isHeld) {
    return _statusOutcome(
      'Pending',
      [
        ('Amount', _money(receipt.amountMinor, receipt.currency)),
        if (receipt.feeMinor > BigInt.zero)
          ('Fee', _money(receipt.feeMinor, receipt.currency)),
        ('From', 'HAAT wallet'),
        ('Receiver Name', receipt.recipientName),
        ('Request code', code),
        ('Reference number', _shortReference(receipt.transactionId)),
        ('Date & Time', when),
      ],
      share: 'HAAT payment, waiting for approval',
    );
  }
  if (receipt.isRejected) {
    return _statusOutcome(
      'Error',
      [
        ('Amount', _money(receipt.amountMinor, receipt.currency)),
        ('Reference number', _shortReference(receipt.transactionId)),
        ('Date & Time', when),
        if (receipt.reason != null && receipt.reason!.trim().isNotEmpty)
          ('Reason', receipt.reason!.trim()),
      ],
      status: 'rejected',
      share: 'HAAT payment, not completed',
    );
  }

  final (whole, fraction) = splitMinor(receipt.amountMinor, receipt.currency);
  return _statusOutcome(
    'Success',
    [
      ('Paid to', receipt.recipientName),
      if (receipt.recipientUsername != null)
        ('Username', '@${receipt.recipientUsername}'),
      if (invoice.isNotEmpty) ('Invoice', invoice),
      ('Request code', code),
      if (receipt.feeMinor > BigInt.zero) ...[
        ('Fee', _money(receipt.feeMinor, receipt.currency)),
        ('Total from wallet', _money(receipt.totalMinor, receipt.currency)),
      ],
      ('Reference number', _shortReference(receipt.transactionId)),
      ('Date & time', when),
    ],
    title: 'Payment sent',
    amount: '$whole$fraction',
    currency: receipt.currency,
    subtitle: '${receipt.recipientName} · HAAT payment',
    share: 'HAAT payment receipt\n'
        'Paid ${_money(receipt.amountMinor, receipt.currency)} to ${receipt.recipientName}',
  );
}

// ══ Pieces the pages show ══════════════════════════════════════════════════════════

/// A logo, or the initials on ink while there is none.
class PayRequestLogo extends StatelessWidget {
  const PayRequestLogo({
    super.key,
    required this.url,
    required this.initials,
    required this.size,
    this.radius,
  });

  final String url;
  final String initials;
  final double size;

  /// Rounded square; a circle when null.
  final double? radius;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      color: _ink,
      child: Text(
        initials.isEmpty ? 'H' : initials,
        style: GoogleFonts.montserrat(
          fontSize: size * 0.36,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
    final image = url.isEmpty
        ? fallback
        : CachedNetworkImage(
            imageUrl: url,
            width: size,
            height: size,
            fit: BoxFit.cover,
            placeholder: (_, __) => fallback,
            errorWidget: (_, __, ___) => fallback,
          );

    return radius == null
        ? ClipOval(child: SizedBox.square(dimension: size, child: image))
        : ClipRRect(
            borderRadius: BorderRadius.circular(radius!),
            child: SizedBox.square(dimension: size, child: image),
          );
  }
}

/// The request's QR, the business's logo in its middle, drawn at the highest error
/// correction so the logo never stops it from being read. A quiet placeholder until
/// the request is made.
class PayRequestQrView extends StatelessWidget {
  const PayRequestQrView({super.key, required this.request, this.size = 173});

  final dynamic request;
  final double size;

  @override
  Widget build(BuildContext context) {
    final data = _field(request, 'link');
    if (data.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: _page,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.qr_code_2_rounded, size: 56, color: _hairline),
      );
    }

    final badge = size * 0.22;
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          QrImageView(
            data: data,
            size: size,
            padding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            errorCorrectionLevel: QrErrorCorrectLevel.H,
            semanticsLabel: 'Payment QR code',
            eyeStyle:
                const QrEyeStyle(eyeShape: QrEyeShape.square, color: _ink),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: _ink,
            ),
          ),
          Container(
            width: badge + 8,
            height: badge + 8,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: PayRequestLogo(
              url: _field(request, 'logoUrl'),
              initials: _field(request, 'initials'),
              size: badge,
              radius: 7,
            ),
          ),
        ],
      ),
    );
  }
}
