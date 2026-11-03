import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/pay_request_api.dart';
import '/custom_code/pay_request_flow.dart' show unlockTapAgain;
import '/custom_code/payout_api.dart' show toMinor;
import '/custom_code/transfer_api.dart';
import '/custom_code/wallet_api.dart';
import '/custom_code/widgets/wallet_balance.dart';
import '/flutter_flow/flutter_flow_util.dart';

// Tap to pay, both phones. The phone that makes the tap pays the phone held to it:
// its owner unlocks it with the passcode or a fingerprint first (confirmItsYou in
// pay_request_flow.dart), so nothing is asked while the phones are together. The NFC
// half is native — HaatTapService (the phone being paid, answering like a card) and
// TapBridge (the paying phone, reading it) in MainActivity.kt. This is the rest:
// setting a phone up to be tapped, making the request, reading the other phone and
// paying it, and the receipt on the phone that was paid.

const _channel = MethodChannel('com.mycompany.haat/tap');
const _ink = Color(0xFF111111);
const _muted = Color(0xFF6B6B72);
const _danger = Color(0xFFD93025);
const _dangerTint = Color(0xFFFDECEA);

/// The PaymentStatus page's route.
const _statusRoute = 'PaymentStatus';

/// The page that shows a request's invoice, with Approve & pay.
const _approvalRoute = 'PayRequestApproval';

bool get _android => !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

String _field(dynamic json, String name) {
  final value = json is Map ? json[name] : null;
  final text = value == null ? '' : '$value'.trim();
  return text == 'null' ? '' : text;
}

String _money(BigInt minor, String currency) {
  final (whole, fraction) = splitMinor(minor, currency);
  return '$whole$fraction $currency';
}

/// The `outcome` PaymentStatus reads; see `_statusOutcome` in pay_request_flow.dart.
Map<String, dynamic> _outcome(
  List<(String, String)> lines, {
  required String title,
  required BigInt amountMinor,
  required String currency,
  required String subtitle,
  required String share,
}) {
  final (whole, fraction) = splitMinor(amountMinor, currency);
  return {
    'paymentStatus': 'Success',
    'title': title,
    'amount': '$whole$fraction',
    'currency': currency,
    'subtitle': subtitle,
    'details': [
      for (final (label, value) in lines) {'label': label, 'value': value},
    ],
    'shareText': [
      share,
      for (final (label, value) in lines) '$label: $value',
    ].join('\n'),
  };
}

/// The red Transaction Failed screen's `outcome`: nothing was paid, and why.
Map<String, dynamic> _failed(List<(String, String)> lines, String reason) {
  final all = [
    ...lines,
    ('Date & Time', dateTimeFormat('d MMM y · HH:mm', DateTime.now())),
    if (reason.trim().isNotEmpty) ('Reason', reason.trim()),
  ];
  return {
    'paymentStatus': 'Error',
    'status': 'failed',
    'details': [
      for (final (label, value) in all) {'label': label, 'value': value},
    ],
    'shareText': [
      'HAAT payment, not completed',
      for (final (label, value) in all) '$label: $value',
    ].join('\n'),
  };
}

/// Which of the admin's limits a payment is over, in words, with its figures; null
/// for a limit HAAT didn't name. [who] is whose limit: `You` or the customer's name.
String? _limitWords(
  String? reason,
  BigInt? limitMinor,
  BigInt? remainingMinor,
  String currency, {
  required String who,
}) {
  final limit = limitMinor == null ? null : _money(limitMinor, currency);
  final has = who == 'You' ? 'have' : 'has';
  switch (reason) {
    case 'daily_limit':
      final left = remainingMinor == null || remainingMinor <= BigInt.zero
          ? 'Nothing is left for today'
          : '${_money(remainingMinor, currency)} is left for today';
      return '$who $has reached the daily limit'
          '${limit == null ? '' : ' of $limit'} set by the admin. $left; '
          'it resets tomorrow.';
    case 'above_maximum':
      return 'This is above the most the admin allows in one payment'
          '${limit == null ? '' : ' ($limit)'}. Use a smaller amount.';
    case 'below_minimum':
      return 'This is below the smallest payment the admin allows'
          '${limit == null ? '' : ' ($limit)'}.';
    case 'fee_exceeds_amount':
      return 'The fee would be more than the amount. Use a larger amount.';
  }
  return null;
}

/// Opens PaymentStatus with [outcome] over whatever page is up.
void _showStatus(Map<String, dynamic> outcome) {
  final navigator = appNavigatorKey.currentState;
  if (navigator == null) return;
  navigator.context.pushNamed(
    _statusRoute,
    queryParameters: {
      'paymentStatus':
          serializeParam(outcome['paymentStatus'], ParamType.String),
      'outcome': serializeParam(outcome, ParamType.JSON),
    }.withoutNulls,
  );
}

/// Who was paid, as the paying phone shows them: `Amna Osman · •••• 4821`.
String _payeeLine(dynamic payee) => [
      _field(payee, 'payeeName'),
      _field(payee, 'payeeMobileMasked'),
    ].where((part) => part.isNotEmpty).join(' · ');

// ══ Setting a phone up to be tapped ════════════════════════════════════════════════

/// Keeps this phone ready to pay by tap while someone is signed in.
///
/// Signed in, it makes a tap key in the Keystore and registers it with HAAT, once
/// per person; signed out, it forgets it. Nothing to do on a phone that cannot
/// answer a tap, or on iOS, where apps cannot.
class TapToPay {
  TapToPay._();

  static bool _started = false;
  static bool _busy = false;
  static bool _ready = false;
  static AuthStatus? _last;
  static DateTime? _failedAt;

  /// Called once, from the app's start-up action.
  static void start() {
    if (_started || !_android) return;
    _started = true;
    AuthSession.instance.addListener(_sync);
    _sync();
  }

  static Future<void> _sync() async {
    final session = AuthSession.instance;
    final status = session.status;
    if (status != _last) {
      _last = status;
      _ready = false;
      if (status == AuthStatus.signedOut) {
        await _invoke('forget');
        return;
      }
    }
    if (status != AuthStatus.signedIn || _busy || _ready) return;
    // Offline at the last try: the next change after a minute tries again.
    final failed = _failedAt;
    if (failed != null &&
        DateTime.now().difference(failed) < const Duration(minutes: 1)) {
      return;
    }

    final userId = session.userId;
    if (userId == null) return;
    _busy = true;
    try {
      final phone = await _channel.invokeMapMethod<String, dynamic>('status');
      if (phone == null || phone['card'] != true) {
        _ready = true;
        return;
      }
      if (phone['keyId'] != null && phone['userId'] == userId) {
        _ready = true;
        return;
      }

      final publicKey = await _channel.invokeMethod<String>('enrol');
      if (publicKey == null || publicKey.isEmpty) return;
      final registered = await session.payRequests.registerTapKey(publicKey);
      if (registered is ApiSuccess<String> && registered.value.isNotEmpty) {
        await _channel.invokeMethod<bool>(
          'save',
          {'keyId': registered.value, 'userId': userId},
        );
        _ready = true;
        _failedAt = null;
      } else if (registered is ApiFailure<String>) {
        // Not allowed to pay from this business: no key, and no asking again.
        await _invoke('forget');
        _ready = true;
      } else {
        _failedAt = DateTime.now();
      }
    } catch (_) {
      _failedAt = DateTime.now();
    } finally {
      _busy = false;
    }
  }

  static Future<void> _invoke(String method) async {
    try {
      await _channel.invokeMethod<bool>(method);
    } catch (_) {}
  }
}

// ══ Asking to be paid by tap ═══════════════════════════════════════════════════════

/// Kept across a retry of the same amount, so a request HAAT made but never answered
/// is not made twice.
final _createReferences = <String, String>{};

/// Makes a tap request for [amount], as typed.
///
/// Returns the request as TapPayOut keeps it — id, code, invoice, amount, currency,
/// `confirmOnPhone` — or `{error}`, a sentence to show.
Future<Map<String, dynamic>> createTapPayment(String amount) async {
  if (!_android) {
    return {
      'error':
          'Tap to pay works on Android phones with NFC. Use the QR instead.'
    };
  }
  try {
    final phone = await _channel.invokeMapMethod<String, dynamic>('status');
    if (phone?['reader'] != true) {
      return {'error': 'This phone has no NFC. Use the QR instead.'};
    }
  } catch (_) {
    return {'error': 'This phone can’t read NFC. Use the QR instead.'};
  }

  final session = AuthSession.instance;
  final wallet = await session.wallet.get();
  final currency = wallet is ApiSuccess<Wallet> ? wallet.value.currency : 'SDG';
  final minor = toMinor(amount, currency);
  if (minor == null || minor <= BigInt.zero) {
    return {'error': 'Enter an amount above zero first.'};
  }

  final slot = '$minor|$currency';
  final reference = _createReferences[slot] ??= const Uuid().v4();
  final created = await session.payRequests.createTap(
    amountMinor: minor,
    currency: currency,
    reference: reference,
  );
  if (created is ApiFailure<PaymentRequest>) {
    _createReferences.remove(slot);
    if (created.data['field'] == 'unlock') {
      return {
        'error': 'Tap to pay locked again. Go back and choose Tap to pay to '
            'confirm it’s you.'
      };
    }
    // Refused — above what the bank allows, or not allowed at all: the red screen.
    return _failed(
      [('Amount', _money(minor, currency)), ('Paid by', 'Tap to pay')],
      created.messageIn(session.languageCode),
    );
  }
  if (created is! ApiSuccess<PaymentRequest>) {
    return {
      'error':
          'You’re offline, so the tap couldn’t start. Tap here to try again.'
    };
  }
  _createReferences.remove(slot);

  final r = created.value;
  final (whole, fraction) = splitMinor(r.amountMinor, r.currency);
  return {
    'id': r.id,
    'code': r.code,
    'invoice': r.invoiceReference ?? r.code,
    'amount': '$whole$fraction',
    'currency': r.currency,
    'amountMinor': r.amountMinor.toString(),
    'confirmOnPhone': r.confirmOnPhone,
    if (r.expiresAt != null) 'expiresAt': r.expiresAt!.toIso8601String(),
  };
}

/// Reads the phone held to this one and pays it [request]'s amount, while the page is
/// open.
///
/// Keeps reading through a phone pulled away too soon, not set up or not allowed to be
/// paid, saying so in a line at the foot of the screen, and asks for the passcode or
/// fingerprint again if tapping locked meanwhile. Returns the PaymentStatus outcome
/// once paid or refused (the red screen), `{problem}` when it cannot go on — this
/// business's balance too short among them, said in a dialog first — and `{}` once the
/// page is closed.
Future<Map<String, dynamic>> tapToPay(
  BuildContext context,
  dynamic request,
) async {
  final code = _field(request, 'code');
  final amountMinor = BigInt.tryParse(_field(request, 'amountMinor'));
  final currency = _field(request, 'currency');
  if (code.isEmpty || amountMinor == null) return {};
  final expiresAt = DateTime.tryParse(_field(request, 'expiresAt'));
  bool expired() => expiresAt != null && !expiresAt.isAfter(DateTime.now());

  final session = AuthSession.instance;
  final hint = _Hint();
  // Reading only stops from here: the page closing, or the request running out.
  final watch = Timer.periodic(const Duration(milliseconds: 400), (timer) {
    if (!context.mounted || expired()) {
      timer.cancel();
      _channel.invokeMethod<bool>('cancelRead').catchError((_) => false);
    }
  });
  // Kept warm while waiting — the connection open, the sign-in fresh — so the tap is
  // one quick call, with nothing to set up first while the phones are together.
  final warm = Timer.periodic(const Duration(seconds: 20), (timer) {
    if (!context.mounted || expired()) {
      timer.cancel();
    } else {
      session.wallet.get();
    }
  });

  try {
    while (context.mounted) {
      if (expired()) {
        return {'problem': 'This tap has expired. Tap here to start again.'};
      }

      String reply;
      try {
        reply = await _channel.invokeMethod<String>('read', {
              'code': code,
              'amountMinor': amountMinor.toString(),
              'currency': currency,
              // Nobody approves on the other phone: this one was unlocked first.
              'confirm': false,
            }) ??
            '';
      } on PlatformException catch (error) {
        if (!context.mounted) return {};
        switch (error.code) {
          case 'no_nfc':
            return {'problem': 'This phone has no NFC. Use the QR instead.'};
          case 'nfc_off':
            return {
              'problem': 'Turn on NFC in your phone’s settings, then tap here.'
            };
          case 'not_set_up':
            HapticFeedback.heavyImpact();
            hint.show('That phone can’t be paid by tap yet. It needs HAAT open '
                'and signed in once — or use the QR.');
          case 'lost':
            hint.show('Hold the phones together a moment longer.');
          case 'cancelled':
            break;
          default:
            hint.show('Couldn’t read that phone. Try again.');
        }
        continue;
      }
      if (!context.mounted) return {};

      final answer = _decode(reply);
      final keyId = _field(answer, 'k');
      final signature = _field(answer, 's');
      if (keyId.isEmpty || signature.isEmpty) {
        hint.show('Couldn’t read that phone. Try again.');
        continue;
      }

      // HAAT answers while the phones are still together: paid, or why not.
      HapticFeedback.selectionClick();
      hint.show('Paying…', hold: true);
      final charged = await _charge(code, keyId, signature);
      if (!context.mounted) return {};

      if (charged is ApiSuccess<TransferReceipt>) {
        hint.hide();
        HapticFeedback.mediumImpact();
        WalletBalance.refreshNow();
        return _paid(charged.value, request, charged.envelope.object);
      }

      if (charged is ApiFailure<TransferReceipt>) {
        final data = charged.data;
        final field = data['field'];
        final message = charged.messageIn(session.languageCode);
        hint.hide();
        HapticFeedback.heavyImpact();
        // Tapping locked while the page was open: unlock it, then read again.
        if (field == 'unlock') {
          if (await unlockTapAgain(context, _money(amountMinor, currency))) {
            continue;
          }
          return {};
        }
        // That phone, not this request: the next phone may be paid with it.
        if (field == 'tap') {
          hint.show(message);
          continue;
        }
        if (field == 'balance') {
          final wallet = await session.wallet.get();
          if (!context.mounted) return {};
          await showTapNotice(
            context,
            title: 'Not enough balance',
            message: 'You don’t have enough in your HAAT wallet to pay '
                '${_money(amountMinor, currency)} and its fee. Nothing was paid.'
                '${wallet is ApiSuccess<Wallet> ? '\n\nAvailable: ${_money(wallet.value.available, wallet.value.currency)}' : ''}',
          );
          return {
            'problem': 'Not enough balance. Top up, then tap here to try again.'
          };
        }
        // Refused by the rules — above the admin's limit, another bank — or the
        // request ended: the red screen, saying why.
        final invoice = _field(request, 'invoice');
        final why = field == 'limit'
            ? _limitWords(
                _field(data, 'detail'),
                BigInt.tryParse(_field(data, 'limitMinor')),
                BigInt.tryParse(_field(data, 'remainingMinor')),
                currency,
                who: 'You',
              )
            : null;
        return _failed(
          [
            ('Amount', _money(amountMinor, currency)),
            if (_payeeLine(data).isNotEmpty) ('Paid to', _payeeLine(data)),
            if (invoice.isNotEmpty && invoice != code) ('Invoice', invoice),
            ('Request code', code),
            ('Paid by', 'Tap to pay'),
          ],
          why ?? message,
        );
      }
      HapticFeedback.heavyImpact();
      hint.hide();
      return {
        'problem': 'You’re offline, so the payment didn’t go through. '
            'Tap here to try again.'
      };
    }
    return {};
  } finally {
    watch.cancel();
    warm.cancel();
    hint.hide();
    await _channel.invokeMethod<bool>('cancelRead').catchError((_) => false);
  }
}

/// Pays the tap, again on a dropped connection: the server pays a tap request once,
/// so asking twice cannot pay twice.
Future<ApiResult<TransferReceipt>> _charge(
  String code,
  String keyId,
  String signature,
) async {
  late ApiResult<TransferReceipt> result;
  for (var attempt = 0; attempt < 3; attempt++) {
    if (attempt > 0) await Future.delayed(Duration(seconds: attempt * 2));
    result = await AuthSession.instance.payRequests
        .chargeTap(code: code, keyId: keyId, signature: signature);
    if (result is! ApiUnreachable<TransferReceipt>) return result;
  }
  return result;
}

/// The paying phone's screen once a tap is paid: how much, and to whom.
Map<String, dynamic> _paid(
  TransferReceipt receipt,
  dynamic request,
  dynamic payee,
) {
  final code = _field(request, 'code');
  final invoice = _field(request, 'invoice');
  final name = _field(payee, 'payeeName').isNotEmpty
      ? _field(payee, 'payeeName')
      : receipt.recipientName;
  final mobile = _field(payee, 'payeeMobileMasked');
  final reference = receipt.transactionId.split('-').first.toUpperCase();
  final when = dateTimeFormat('d MMM y · HH:mm', receipt.occurredAt);

  if (receipt.isRejected) {
    return _failed(
      [
        ('Amount', _money(receipt.amountMinor, receipt.currency)),
        ('Reference number', reference)
      ],
      receipt.reason ?? '',
    );
  }
  if (receipt.isHeld) {
    return {
      'paymentStatus': 'Pending',
      'details': [
        for (final (label, value) in [
          ('Amount', _money(receipt.amountMinor, receipt.currency)),
          if (name.isNotEmpty) ('To', name),
          ('Request code', code),
          ('Reference number', reference),
          ('Date & Time', when),
        ])
          {'label': label, 'value': value},
      ],
      'shareText': 'HAAT payment, waiting for approval',
    };
  }
  return _outcome(
    [
      if (name.isNotEmpty) ('Paid to', name),
      if (mobile.isNotEmpty) ('Phone', mobile),
      if (invoice.isNotEmpty && invoice != code) ('Invoice', invoice),
      ('Request code', code),
      if (receipt.feeMinor > BigInt.zero)
        ('Fee', _money(receipt.feeMinor, receipt.currency)),
      ('Method', 'Tap to pay'),
      ('Reference number', reference),
      ('Date & time', when),
    ],
    title: 'Payment sent',
    amountMinor: receipt.amountMinor,
    currency: receipt.currency,
    subtitle: name.isEmpty ? 'Tap to pay' : '$name · Tap to pay',
    share: 'HAAT payment receipt\n'
        'Paid ${_money(receipt.amountMinor, receipt.currency)}'
        '${name.isEmpty ? '' : ' to $name'} by tap',
  );
}

/// Waits, while the page is open, for the customer to approve [request] on their
/// phone after a tap.
///
/// From when the tapped phone paid; [tapToPay] no longer asks for it — the paying
/// phone is unlocked first — and it stays only for TapPayOut's existing action.
///
/// Asks HAAT every second, so the merchant's screen turns as soon as the customer's
/// does. [tapped] is what the tap said about the customer. Returns the PaymentStatus
/// outcome once paid, `{problem}` once it expired or was cancelled, and `{}` once the
/// page is closed.
Future<Map<String, dynamic>> awaitTapApproval(
  BuildContext context,
  dynamic request,
  dynamic tapped,
) async {
  final id = _field(request, 'id');
  if (id.isEmpty) return {};
  final expiresAt = DateTime.tryParse(_field(request, 'expiresAt'));
  final session = AuthSession.instance;

  while (context.mounted) {
    await Future.delayed(const Duration(seconds: 1));
    if (!context.mounted) return {};
    final result = await session.payRequests.list(limit: 10);
    if (!context.mounted) return {};
    final now = result is ApiSuccess<List<PaymentRequest>>
        ? result.value.where((r) => r.id == id).firstOrNull
        : null;

    if (now != null && now.isPaid) {
      HapticFeedback.mediumImpact();
      WalletBalance.refreshNow();
      final name = _field(tapped, 'payerName');
      final mobile = _field(tapped, 'payerMobileMasked');
      final invoice = now.invoiceReference;
      return _outcome(
        [
          if (name.isNotEmpty) ('Paid by', name),
          if (mobile.isNotEmpty) ('Phone', mobile),
          if (invoice != null && invoice != now.code) ('Invoice', invoice),
          ('Request code', now.code),
          ('Method', 'Tap to pay · approved on phone'),
          (
            'Date & time',
            dateTimeFormat('d MMM y · HH:mm', now.paidAt ?? DateTime.now())
          ),
        ],
        title: 'Payment received',
        amountMinor: now.amountMinor,
        currency: now.currency,
        subtitle: name.isEmpty
            ? 'Paid into your HAAT wallet'
            : 'From $name · Tap to pay',
        share: 'HAAT payment received\n'
            '${_money(now.amountMinor, now.currency)}'
            '${name.isEmpty ? '' : ' from $name'} by tap to pay',
      );
    }
    if (now?.status == 'cancelled') {
      return {'problem': 'This tap was cancelled. Tap here to start again.'};
    }
    if (now?.status == 'expired' ||
        (expiresAt != null && !expiresAt.isAfter(DateTime.now()))) {
      return {
        'problem':
            'The customer didn’t approve in time. Tap here to start again.'
      };
    }
  }
  return {};
}

Map<String, dynamic> _decode(String reply) {
  try {
    final value = jsonDecode(reply);
    return value is Map<String, dynamic> ? value : const {};
  } catch (_) {
    return const {};
  }
}

// ══ The phone being paid ═══════════════════════════════════════════════════════════

/// Why this phone can't pay [p], read the way the merchant's phone reads it.
///
/// `limit` — the rules refuse it (the red screen); `balance` — not enough in the
/// wallet (a dialog); `ended` — no longer open; null when it can be paid.
String? _refusalOf(PaymentRequestPreview p, Wallet? wallet) {
  if (p.status != 'open') return 'ended';
  if (!p.payable) {
    return switch (p.refusal) {
      'over_limit' || 'no_rule' || 'other_bank' => 'limit',
      _ => 'ended',
    };
  }
  final total = p.totalMinor ?? p.amountMinor;
  if (total != null &&
      wallet != null &&
      wallet.currency == p.currency &&
      total > wallet.available) {
    return 'balance';
  }
  return null;
}

String _refusalReason(PaymentRequestPreview p) => switch (p.refusal) {
      'over_limit' => _limitWords(
            p.limitReason,
            p.limitMinor,
            p.remainingMinor,
            p.currency,
            who: 'You',
          ) ??
          'This amount is above the limit the admin allows.',
      'no_rule' => 'Your bank doesn’t allow this payment yet.',
      'other_bank' =>
        'This request is for a different bank than your HAAT wallet.',
      _ => 'This payment can’t be made right now.',
    };

/// Says on the customer's phone why the tap can't be paid — the red screen for a
/// refusal, a dialog for a short balance. True when it said something.
Future<bool> _sayWhyNot(
  BuildContext context,
  PaymentRequestPreview p,
  Wallet? wallet,
  String? refusal,
) async {
  final amount =
      _money(p.totalMinor ?? p.amountMinor ?? BigInt.zero, p.currency);
  final name = p.requester.name;
  switch (refusal) {
    case 'limit':
      HapticFeedback.heavyImpact();
      _showStatus(_failed(
        [
          ('Amount', amount),
          ('Paid to', name),
          if (p.invoiceReference != null) ('Invoice', p.invoiceReference!),
          ('Request code', p.code),
          ('Paid by', 'Tap to pay'),
        ],
        _refusalReason(p),
      ));
      return true;
    case 'balance':
      HapticFeedback.heavyImpact();
      final navigator = appNavigatorKey.currentState;
      if (navigator == null) return false;
      await showTapNotice(
        navigator.context,
        title: 'Not enough balance',
        message: 'You don’t have enough in your HAAT wallet to pay $amount to '
            '$name. Nothing was paid.'
            '${wallet == null ? '' : '\n\nAvailable: ${_money(wallet.available, wallet.currency)}'}',
      );
      return true;
  }
  return false;
}

Future<(PaymentRequestPreview?, Wallet?)> _readTap(String code) async {
  final session = AuthSession.instance;
  final results = await Future.wait([
    session.payRequests.preview(code),
    session.wallet.get(),
  ]);
  final preview = results[0];
  final wallet = results[1];
  return (
    preview is ApiSuccess<PaymentRequestPreview> ? preview.value : null,
    wallet is ApiSuccess<Wallet> ? wallet.value : null,
  );
}

/// Shows this phone what it was just paid, once HAAT says so.
///
/// The phone opens here right after answering a tap; the phone that made the tap is
/// paying it meanwhile — into a request of this business's own, made for that tap —
/// so this asks HAAT every half second or so for that request, paid: the newest tap
/// request for the tap's amount. Who paid is read from the tap request [code] itself.
Future<void> openTapReceipt(BuildContext context, String code) async {
  final hint = _Hint()..show('Getting paid…', hold: true);
  final session = AuthSession.instance;
  // Two minutes back, so a phone clock a little off HAAT's still finds the payment.
  final since = DateTime.now().subtract(const Duration(minutes: 2));
  PaymentRequestPreview? tap;
  try {
    for (var attempt = 0; attempt < 30; attempt++) {
      if (attempt > 0) {
        await Future.delayed(Duration(milliseconds: attempt < 10 ? 300 : 800));
      }
      // The tap request is closed once it has paid, so a look at this business's own
      // after it was seen closed shows the payment by then.
      final closed = tap != null && tap.status != 'open';
      final reading = closed ? null : session.payRequests.preview(code);
      final listed = await session.payRequests.list(limit: 10);
      final read = await reading;
      if (read is ApiSuccess<PaymentRequestPreview>) tap = read.value;
      if (listed is ApiFailure<List<PaymentRequest>>) {
        // Not allowed to see this business's requests: the payment shows in its
        // transactions instead.
        WalletBalance.refreshNow();
        hint.show('Check your transactions to see the payment.');
        return;
      }
      final owed = listed is ApiSuccess<List<PaymentRequest>>
          ? listed.value
              .where((r) =>
                  r.channel == 'nfc' &&
                  r.isPaid &&
                  (r.paidAt == null || r.paidAt!.isAfter(since)) &&
                  (tap?.amountMinor == null || r.amountMinor == tap!.amountMinor))
              .firstOrNull
          : null;

      if (owed != null) {
        hint.hide();
        HapticFeedback.mediumImpact();
        WalletBalance.refreshNow();
        _showStatus(_received(owed, tap));
        return;
      }
      // Seen closed before this look, and nothing paid here: it ended without paying.
      if (closed) break;
    }
    hint.show('The tap didn’t go through. Nothing was paid.');
  } catch (_) {
    hint.hide();
  }
}

/// What a tap paid this phone, as its receipt; [tap] says who paid.
Map<String, dynamic> _received(PaymentRequest owed, PaymentRequestPreview? tap) {
  final payer = tap?.requester;
  final name = payer?.name ?? '';
  final handle = payer == null ? '' : payer.username ?? payer.handle;
  return _outcome(
    [
      if (name.isNotEmpty) ('Paid by', name),
      if (handle.isNotEmpty) ('Username', '@$handle'),
      if (payer?.mobileMasked != null) ('Phone', payer!.mobileMasked!),
      ('Request code', tap?.code ?? owed.code),
      ('Method', 'Tap to pay'),
      (
        'Date & time',
        dateTimeFormat('d MMM y · HH:mm', owed.paidAt ?? DateTime.now())
      ),
    ],
    title: 'Payment received',
    amountMinor: owed.amountMinor,
    currency: owed.currency,
    subtitle:
        name.isEmpty ? 'Paid into your HAAT wallet' : 'From $name · Tap to pay',
    share: 'HAAT payment received\n'
        '${_money(owed.amountMinor, owed.currency)}'
        '${name.isEmpty ? '' : ' from $name'} by tap to pay',
  );
}

/// Opens the request a merchant's tap asked this phone to approve: its invoice — who,
/// how much, the fee — with Approve & pay behind the passcode or fingerprint.
///
/// Above the bank's limit it is the red screen instead, and a dialog when the wallet
/// is short; the merchant's phone says the same.
Future<void> openTapApproval(BuildContext context, String code) async {
  final hint = _Hint()..show('Opening the payment…', hold: true);
  try {
    var (p, wallet) = await _readTap(code);
    if (p == null) {
      (p, wallet) = await _readTap(code);
    }
    hint.hide();
    if (p == null) {
      hint.show('Couldn’t open the payment. Check your connection.');
      return;
    }
    if (p.status == 'paid') {
      hint.show('This payment has already been made.');
      return;
    }
    final refusal = _refusalOf(p, wallet);
    if (refusal == 'ended') {
      hint.show('This tap has ended. Ask the merchant to start again.');
      return;
    }
    if (refusal != null) {
      await _sayWhyNot(context, p, wallet, refusal);
      return;
    }
    HapticFeedback.mediumImpact();
    final navigator = appNavigatorKey.currentState;
    if (navigator == null) return;
    navigator.context.pushNamed(
      _approvalRoute,
      queryParameters:
          {'code': serializeParam(p.code, ParamType.String)}.withoutNulls,
    );
  } catch (_) {
    hint.hide();
  }
}

// ══ A dialog for what stops a payment ══════════════════════════════════════════════

/// A short, plain dialog — what happened and what to do — with one OK.
Future<void> showTapNotice(
  BuildContext context, {
  required String title,
  required String message,
}) {
  if (!context.mounted) return Future.value();
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Close',
    barrierColor: const Color(0x66000000),
    transitionDuration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 200),
    pageBuilder: (dialogContext, __, ___) =>
        _Notice(title: title, message: message),
    transitionBuilder: (_, animation, __, child) {
      final curved =
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween(begin: 0.96, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _Notice extends StatelessWidget {
  const _Notice({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: _dangerTint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 24,
                  color: _danger,
                ),
              ),
              const SizedBox(height: 16),
              Semantics(
                header: true,
                child: Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    letterSpacing: -0.2,
                    color: _ink,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: GoogleFonts.montserrat(
                  fontSize: 13,
                  height: 1.5,
                  color: _muted,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  autofocus: true,
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: _ink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══ A line at the foot of the screen ═══════════════════════════════════════════════

/// What is happening while the phones are held together, over whatever page is up.
class _Hint {
  OverlayEntry? _entry;
  Timer? _timer;
  final _text = ValueNotifier<String>('');

  void show(String message, {bool hold = false}) {
    _timer?.cancel();
    _text.value = message;
    if (_entry == null) {
      final overlay = appNavigatorKey.currentState?.overlay;
      if (overlay == null) return;
      _entry = OverlayEntry(builder: (_) => _HintPill(text: _text));
      overlay.insert(_entry!);
    }
    if (!hold) _timer = Timer(const Duration(seconds: 4), hide);
  }

  void hide() {
    _timer?.cancel();
    _timer = null;
    _entry?.remove();
    _entry = null;
  }
}

class _HintPill extends StatelessWidget {
  const _HintPill({required this.text});

  final ValueListenable<String> text;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Positioned(
      left: 24,
      right: 24,
      bottom: bottom + 32,
      child: IgnorePointer(
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          builder: (_, t, child) => Opacity(
            opacity: t,
            child: Transform.translate(
                offset: Offset(0, 8 * (1 - t)), child: child),
          ),
          child: Center(
            child: Material(
              color: _ink,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: ValueListenableBuilder<String>(
                  valueListenable: text,
                  builder: (_, value, __) => Text(
                    value,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
