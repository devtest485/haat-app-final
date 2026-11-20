import '/app_state.dart';
import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/bank_link_api.dart';

/// The Link your SIB account screens, and what they share.
///
/// The screens hold nothing between them but App State: the number and phone as typed,
/// where the code went, and what the bank holds to be confirmed. The calls themselves
/// live here so the screens only ask and read the answer.
class BankLinkFlow {
  BankLinkFlow._();

  /// The bank's own wording for a refusal, or the app's when the bank said nothing a
  /// person could use.
  static String explain<T>(ApiResult<T> result) {
    final code = result.errorCode ?? '';
    if (code == 'NOT_FOUND') {
      return 'We couldn’t find a SIB account with these details. Check the number and the phone and try again.';
    }
    if (code == 'CONFLICT') return 'This SIB account is already linked.';

    return result.messageIn(AuthSession.instance.languageCode);
  }

  /// The phone as the bank holds it: the country code, then the number without a leading
  /// zero. Only Sudan's, as the screen's fixed +249 says.
  static String mobileOf(String? typed) {
    final digits = (typed ?? '').replaceAll(RegExp(r'\D'), '');

    return '+249${digits.replaceFirst(RegExp(r'^(249|0)+'), '')}';
  }

  /// Asks for a code, and keeps what the next screens need.
  static Future<String> request(String? number, String? phone) async {
    final digits = (number ?? '').replaceAll(RegExp(r'\D'), '');
    final mobile = mobileOf(phone);
    final result = await AuthSession.instance.bankLinks.request(digits, mobile);
    final challenge = result.valueOrNull;

    if (challenge == null) return explain(result);

    FFAppState().update(() {
      FFAppState().saibNumber = digits;
      FFAppState().saibMobile = mobile;
      FFAppState().saibMobileMasked = challenge.mobileMasked;
      FFAppState().saibDevCode = challenge.devOtpCode;
    });

    return '';
  }

  /// Asks again for the account already named, which sends a new code.
  static Future<String> resend() async {
    final result = await AuthSession.instance.bankLinks
        .request(FFAppState().saibNumber, FFAppState().saibMobile);
    final challenge = result.valueOrNull;

    if (challenge == null) return explain(result);

    FFAppState().update(() {
      FFAppState().saibMobileMasked = challenge.mobileMasked;
      FFAppState().saibDevCode = challenge.devOtpCode;
    });

    return '';
  }

  /// Checks the code; on success the bank's details are kept for the confirm screen.
  static Future<String> verify(String? code) async {
    final result = await AuthSession.instance.bankLinks.verify(
      FFAppState().saibNumber,
      FFAppState().saibMobile,
      (code ?? '').trim(),
    );
    final details = result.valueOrNull;

    if (details == null) return explain(result);

    FFAppState().update(() {
      FFAppState().saibDetails = details.toJson();
      FFAppState().saibDevCode = '';
    });

    return '';
  }

  /// Links the account, and brings the home screen's number line up to date.
  static Future<String> confirm() async {
    final result = await AuthSession.instance.bankLinks
        .confirm(FFAppState().saibNumber, FFAppState().saibMobile);

    if (!result.isSuccess) return explain(result);

    await refresh(force: true);

    return '';
  }

  static DateTime? _readAt;

  /// Reads the linked accounts and writes the first into App State, or empties it.
  ///
  /// Called each time the wallet is read, which is every few seconds, so it only asks the
  /// server again after a minute unless [force] says the answer has just changed.
  static Future<void> refresh({bool force = false}) async {
    final last = _readAt;
    if (!force &&
        last != null &&
        DateTime.now().difference(last).inSeconds < 60) {
      return;
    }
    _readAt = DateTime.now();

    final linked = await AuthSession.instance.bankLinks.linked();
    if (linked == null) return;

    final first = linked.isEmpty ? null : linked.first;
    final number = first?.displayNumber ?? '';
    final bank = first?.label ?? '';
    final holder = first?.holderName ?? '';

    if (FFAppState().sibAccount != number ||
        FFAppState().sibBank != bank ||
        FFAppState().sibHolder != holder) {
      FFAppState().update(() {
        FFAppState().sibAccount = number;
        FFAppState().sibBank = bank;
        FFAppState().sibHolder = holder;
      });
    }
  }

  /// Forgets the linked account — for the next person to sign in on this phone.
  static void forget() {
    _readAt = null;
    FFAppState().update(() {
      FFAppState().sibAccount = '';
      FFAppState().sibBank = '';
      FFAppState().sibHolder = '';
    });
    clear();
  }

  /// Forgets what a finished or abandoned link left behind.
  static void clear() {
    FFAppState().update(() {
      FFAppState().saibNumber = '';
      FFAppState().saibMobile = '';
      FFAppState().saibMobileMasked = '';
      FFAppState().saibDevCode = '';
      FFAppState().saibDetails = null;
    });
  }
}
