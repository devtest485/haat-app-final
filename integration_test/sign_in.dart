import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haat/custom_code/api_result.dart';
import 'package:haat/custom_code/auth_session.dart';

/// Registers a throwaway number and verifies it, leaving the app signed in.
///
/// Uses the real endpoints rather than writing a token into storage: several screens
/// are only worth looking at in the state a merchant reaches them in, and a hand-made
/// session is not that state.
///
/// Depends on the backend returning `devOtpCode`, which every non-production
/// environment does. Against one that does not, this returns false and says why on the
/// log rather than pretending — a step that quietly skipped would read exactly like a
/// step that passed.
/// A number the backend has just sent a code to, and the code it sent.
typedef PendingRegistration = ({String mobile, String code});

/// Starts a registration and stops, so the code screen can be driven by hand.
///
/// Separate from [signInAsNewMerchant], which finishes the job through the API.
/// Checking the code screen means letting the screen do the verifying.
Future<PendingRegistration?> registerForRealCode(WidgetTester tester) async {
  final session = AuthSession.instance;
  final mobile = '+2499000${DateTime.now().millisecondsSinceEpoch % 100000}';
  PendingRegistration? pending;

  await tester.runAsync(() async {
    final started = await session.register(mobile: mobile);

    if (started is! ApiSuccess) {
      debugPrint('REGISTER FAILED: ${started.messageIn('en')}');

      return;
    }

    final code = session.devOtpCode;
    if (code == null || code.length != 6) {
      debugPrint('REGISTER: no usable devOtpCode came back.');

      return;
    }

    debugPrint('REGISTERED $mobile, code $code');
    pending = (mobile: mobile, code: code);
  });

  await tester.pump(const Duration(milliseconds: 600));

  return pending;
}

Future<bool> signInAsNewMerchant(WidgetTester tester) async {
  final session = AuthSession.instance;
  final mobile = '+2499000${DateTime.now().millisecondsSinceEpoch % 100000}';
  var ok = false;

  await tester.runAsync(() async {
    final started = await session.register(mobile: mobile);

    if (started is! ApiSuccess) {
      debugPrint('SIGN-IN FAILED at register: ${started.messageIn('en')}');

      return;
    }

    final code = session.devOtpCode;
    if (code == null || code.isEmpty) {
      debugPrint('SIGN-IN FAILED: the backend did not return devOtpCode.');

      return;
    }

    final verified = await session.verifyOtp(code: code, mobile: mobile);
    ok = verified is ApiSuccess;

    debugPrint(
      ok
          ? 'SIGNED IN as $mobile'
          : 'SIGN-IN FAILED at verify: ${verified.messageIn('en')}',
    );
  });

  await tester.pump(const Duration(milliseconds: 600));

  return ok;
}
