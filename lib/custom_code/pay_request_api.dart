import '/custom_code/api_client.dart';
import '/custom_code/api_config.dart';
import '/custom_code/api_result.dart';
import '/custom_code/organization_api.dart' show logoUrlFor;
import '/custom_code/sale_cart.dart';
import '/custom_code/transfer_api.dart';

BigInt? _minorOrNull(Object? value) =>
    value == null ? null : BigInt.tryParse('$value');

/// A payment request this business made: a QR or a link for one amount, paid once.
class PaymentRequest {
  const PaymentRequest({
    required this.id,
    required this.code,
    required this.channel,
    required this.merchantName,
    required this.currency,
    required this.amountMinor,
    required this.status,
    this.description,
    this.invoiceReference,
    this.expiresAt,
    this.paidAt,
    this.confirmOnPhone = false,
  });

  final String id;

  /// What the QR and the link carry — and nothing else: who is paid and how much are
  /// read from HAAT when it is opened, never from the QR.
  final String code;

  /// `dynamic_qr`, `payment_link` or `nfc` (tap to pay).
  final String channel;
  final String merchantName;
  final String currency;
  final BigInt amountMinor;
  final String status;
  final String? description;
  final String? invoiceReference;
  final DateTime? expiresAt;
  final DateTime? paidAt;

  /// A tap whose amount the customer approves on their own phone, being above what a
  /// tap pays alone.
  final bool confirmOnPhone;

  bool get isPaid => status == 'paid';

  /// The address shared and drawn in the QR. Opens HAAT on a phone that has it, and a
  /// page saying who is asking for how much on one that does not.
  String get link => payLinkFor(code);

  factory PaymentRequest.fromData(Map<String, dynamic> data) => PaymentRequest(
        id: data['id'] as String? ?? '',
        code: data['code'] as String? ?? '',
        channel: data['channel'] as String? ?? 'dynamic_qr',
        merchantName: data['merchantName'] as String? ?? '',
        currency: data['currency'] as String? ?? 'SDG',
        amountMinor: _minorOrNull(data['amountMinor']) ?? BigInt.zero,
        status: data['status'] as String? ?? 'open',
        description: data['description'] as String?,
        invoiceReference: data['invoiceReference'] as String?,
        expiresAt:
            DateTime.tryParse(data['expiresAt'] as String? ?? '')?.toLocal(),
        paidAt: DateTime.tryParse(data['paidAt'] as String? ?? '')?.toLocal(),
        confirmOnPhone: data['confirmOnPhone'] as bool? ?? false,
      );
}

/// Who is asking to be paid, as HAAT knows them — never as the QR claims.
class PaymentRequester {
  const PaymentRequester({
    required this.name,
    required this.handle,
    required this.verified,
    this.username,
    this.mobileMasked,
    this.logoUrl,
  });

  final String name;
  final String handle;
  final String? username;

  /// The end of their number only: `+249 •••• 4567`.
  final String? mobileMasked;
  final String? logoUrl;
  final bool verified;

  String get initials {
    final words = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '?';
    if (words.length == 1) return words.first.substring(0, 1).toUpperCase();

    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }

  factory PaymentRequester.fromData(Map<String, dynamic> data) =>
      PaymentRequester(
        name: data['name'] as String? ?? '',
        handle: data['handle'] as String? ?? '',
        username: data['username'] as String?,
        mobileMasked: data['mobileMasked'] as String?,
        logoUrl: logoUrlFor(data['logoPath'] as String?),
        verified: data['verified'] as bool? ?? false,
      );
}

/// A request as the business about to pay it from its wallet sees it.
class PaymentRequestPreview {
  const PaymentRequestPreview({
    required this.code,
    required this.channel,
    required this.currency,
    required this.status,
    required this.payable,
    required this.requester,
    this.amountMinor,
    this.feeMinor,
    this.totalMinor,
    this.description,
    this.invoiceReference,
    this.expiresAt,
    this.refusal,
    this.limitReason,
    this.limitMinor,
    this.remainingMinor,
  });

  final String code;
  final String channel;
  final String currency;

  /// `open`, `paid`, `cancelled` or `expired`.
  final String status;
  final BigInt? amountMinor;

  /// What this business's bank charges for paying it, on top of the amount.
  final BigInt? feeMinor;
  final BigInt? totalMinor;
  final String? description;
  final String? invoiceReference;
  final DateTime? expiresAt;
  final PaymentRequester requester;

  /// Whether this business can pay it now; when not, [refusal] says why.
  final bool payable;

  /// `not_open`, `own_request`, `other_bank`, `no_amount`, `no_rule` or `over_limit`.
  final String? refusal;

  /// With `over_limit`, which of the bank's limits: `daily_limit`, `above_maximum`,
  /// `below_minimum` or `fee_exceeds_amount`, with its figure and, for the daily cap,
  /// what is left of it today.
  final String? limitReason;
  final BigInt? limitMinor;
  final BigInt? remainingMinor;

  bool get isInvoice => channel == 'invoice';

  factory PaymentRequestPreview.fromData(Map<String, dynamic> data) =>
      PaymentRequestPreview(
        code: data['code'] as String? ?? '',
        channel: data['channel'] as String? ?? '',
        currency: data['currency'] as String? ?? 'SDG',
        status: data['status'] as String? ?? 'open',
        amountMinor: _minorOrNull(data['amountMinor']),
        feeMinor: _minorOrNull(data['feeMinor']),
        totalMinor: _minorOrNull(data['totalMinor']),
        description: data['description'] as String?,
        invoiceReference: data['invoiceReference'] as String?,
        expiresAt:
            DateTime.tryParse(data['expiresAt'] as String? ?? '')?.toLocal(),
        payable: data['payable'] as bool? ?? false,
        refusal: data['refusal'] as String?,
        limitReason: (data['limit'] as Map?)?['reason'] as String?,
        limitMinor: _minorOrNull((data['limit'] as Map?)?['limitMinor']),
        remainingMinor:
            _minorOrNull((data['limit'] as Map?)?['remainingMinor']),
        requester: PaymentRequester.fromData(
          (data['requester'] as Map?)?.cast<String, dynamic>() ?? const {},
        ),
      );
}

/// Payment requests: making a QR or a link to be paid, and paying another business's
/// from this one's wallet.
class PayRequestApi {
  PayRequestApi(this._client);

  final ApiClient _client;

  /// A QR ([link] false) or a link for [amountMinor], paid once, short-lived.
  ///
  /// [reference] is kept across a retry, so a request the server made but never
  /// answered is not made twice.
  Future<ApiResult<PaymentRequest>> create({
    required bool link,
    required BigInt amountMinor,
    required String currency,
    required String reference,
    String? description,
  }) =>
      _client.post(
        link ? '/payment-links' : '/qr-codes',
        idempotencyKey: reference,
        body: {
          'amountMinor': amountMinor.toString(),
          'currency': currency,
          if (description != null && description.trim().isNotEmpty)
            'description': description.trim(),
          if (SaleCart.linesFor(amountMinor) case final lines?) 'lines': lines,
        },
        parse: (envelope) => PaymentRequest.fromData(envelope.object),
      );

  /// A request for [amountMinor] to be paid to this business by whoever holds their
  /// phone to this one, approving it there. Lasts five minutes.
  Future<ApiResult<PaymentRequest>> createTap({
    required BigInt amountMinor,
    required String currency,
    required String reference,
  }) =>
      _client.post(
        '/tap-payments',
        idempotencyKey: reference,
        body: {
          'amountMinor': amountMinor.toString(),
          'currency': currency,
          if (SaleCart.linesFor(amountMinor) case final lines?) 'lines': lines,
        },
        parse: (envelope) => PaymentRequest.fromData(envelope.object),
      );

  /// Pays tap request [code] from this business to the phone that answered with
  /// [keyId] and [signature]. The same tap again returns the first payment.
  Future<ApiResult<TransferReceipt>> chargeTap({
    required String code,
    required String keyId,
    required String signature,
  }) =>
      _client.post(
        '/pay/${Uri.encodeComponent(code)}/tap',
        body: {'keyId': keyId, 'signature': signature},
        parse: (envelope) => TransferReceipt.fromData(envelope.object),
      );

  /// A value for this phone's biometric key to sign, unlocking tapping under
  /// [reference].
  Future<ApiResult<String>> tapUnlockChallenge(String reference) =>
      _client.post(
        '/pay/tap-unlock/challenge',
        body: {'reference': reference},
        parse: (envelope) => envelope.object['challenge'] as String? ?? '',
      );

  /// Lets this phone pay by tap for the next five minutes, allowed by the [passcode]
  /// or a [biometricSignature] over the challenge for [reference]. The tap itself then
  /// asks nobody anything, so it is answered while the phones are still together.
  Future<ApiResult<void>> tapUnlock({
    required String reference,
    String? passcode,
    String? biometricSignature,
  }) =>
      _client.post(
        '/pay/tap-unlock',
        body: {
          'reference': reference,
          if (biometricSignature != null)
            'biometricSignature': biometricSignature
          else
            'passcode': passcode,
        },
        parse: (_) {},
      );

  /// Lets this phone be paid by tap: registers the public half of its tap key, and
  /// returns the id it answers a merchant's phone with.
  Future<ApiResult<String>> registerTapKey(String publicKey) => _client.post(
        '/pay/tap-key',
        body: {'publicKey': publicKey},
        parse: (envelope) => envelope.object['keyId'] as String? ?? '',
      );

  /// This business's requests, newest first — how the one on screen learns it was paid.
  Future<ApiResult<List<PaymentRequest>>> list({int limit = 20}) => _client.get(
        '/payment-requests',
        query: {'limit': '$limit'},
        parse: (envelope) => envelope.list
            .whereType<Map<String, dynamic>>()
            .map(PaymentRequest.fromData)
            .toList(),
      );

  /// Stops a request from being paid.
  Future<ApiResult<void>> cancel(String id) => _client.post(
        '/payment-requests/$id/cancel',
        parse: (_) {},
      );

  /// Who [code] pays and how much, read from HAAT — and whether this business can pay it.
  Future<ApiResult<PaymentRequestPreview>> preview(String code) => _client.get(
        '/pay/${Uri.encodeComponent(code)}/wallet',
        parse: (envelope) => PaymentRequestPreview.fromData(envelope.object),
      );

  /// A value for this phone's biometric key to sign, approving paying exactly [code]
  /// under [reference].
  Future<ApiResult<String>> challenge({
    required String code,
    required String reference,
  }) =>
      _client.post(
        '/pay/${Uri.encodeComponent(code)}/wallet/challenge',
        body: {'reference': reference},
        parse: (envelope) => envelope.object['challenge'] as String? ?? '',
      );

  /// Pays [code] from the wallet, allowed by the [passcode] or a [biometricSignature]
  /// over the [challenge] for it. The same [reference] again returns the first payment.
  Future<ApiResult<TransferReceipt>> pay({
    required String code,
    required String reference,
    String? passcode,
    String? biometricSignature,
  }) =>
      _client.post(
        '/pay/${Uri.encodeComponent(code)}/wallet',
        idempotencyKey: reference,
        body: {
          'reference': reference,
          if (biometricSignature != null)
            'biometricSignature': biometricSignature
          else
            'passcode': passcode,
        },
        parse: (envelope) => TransferReceipt.fromData(envelope.object),
      );
}

/// The shareable address for [code]: a page on HAAT's server that opens the app.
String payLinkFor(String code) => '${ApiConfig.baseUrl}/p/$code';

final _codeShape = RegExp(r'^[A-Za-z0-9]{6,12}$');

/// The code in something scanned or opened: a HAAT link (`…/p/CODE`, `…/pay/CODE`,
/// `haat://haat.com/pay/CODE`) or a bare code. Null for anything else — a QR from
/// another app, a website — so it is never mistaken for a payment.
String? payCodeFrom(String? scanned) {
  final text = scanned?.trim() ?? '';
  if (text.isEmpty) return null;
  if (_codeShape.hasMatch(text)) return text.toUpperCase();

  final uri = Uri.tryParse(text);
  if (uri == null) return null;

  final segments = uri.pathSegments.where((part) => part.isNotEmpty).toList();
  final at = segments.lastIndexWhere((part) => part == 'p' || part == 'pay');
  if (at < 0 || at + 1 >= segments.length) return null;

  // Only HAAT's own addresses: the app's scheme, or the server it talks to.
  final ours = uri.scheme == 'haat' ||
      (uri.scheme == 'https' &&
          uri.host == Uri.tryParse(ApiConfig.baseUrl)?.host);
  if (!ours) return null;

  final code = segments[at + 1];
  return _codeShape.hasMatch(code) ? code.toUpperCase() : null;
}

/// A payment link opened before the app could show it — signed out, or locked — kept
/// until the person is in, then opened.
class PendingPayLink {
  PendingPayLink._();

  static String? _code;
  static String _kind = 'pay';

  /// Holds [code]. [kind] is `pay` for a link to pay, `tap` for a tap already paid
  /// (its receipt is shown), `approve` for a tap to approve on this phone.
  static void hold(String code, {String kind = 'pay'}) {
    _code = code;
    _kind = kind;
  }

  /// What the held code is: `pay`, `tap` or `approve`.
  static String get kind => _kind;

  /// The held code, once; null when there is none.
  static String? take() {
    final code = _code;
    _code = null;
    return code;
  }
}
