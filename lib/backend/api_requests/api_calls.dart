import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start HaatAuth Group Code

class HaatAuthGroup {
  static String getBaseUrl({
    String? accessToken = '',
    String? language = '',
  }) =>
      'https://haat-api.xtroedge.com/api/v1';
  static Map<String, String> headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Accept-Language': '[language]',
  };
  static RegisterUserCall registerUserCall = RegisterUserCall();
  static ResendOtpCall resendOtpCall = ResendOtpCall();
  static VerifyOtpCall verifyOtpCall = VerifyOtpCall();
  static SignInCall signInCall = SignInCall();
  static VerifyMfaCall verifyMfaCall = VerifyMfaCall();
  static BiometricChallengeCall biometricChallengeCall =
      BiometricChallengeCall();
  static BiometricVerifyCall biometricVerifyCall = BiometricVerifyCall();
  static RefreshTokenCall refreshTokenCall = RefreshTokenCall();
  static SetPasswordCall setPasswordCall = SetPasswordCall();
  static SetPasscodeCall setPasscodeCall = SetPasscodeCall();
  static CheckUsernameCall checkUsernameCall = CheckUsernameCall();
  static ClaimUsernameCall claimUsernameCall = ClaimUsernameCall();
  static CredentialStatusCall credentialStatusCall = CredentialStatusCall();
  static SignInWithPasscodeCall signInWithPasscodeCall =
      SignInWithPasscodeCall();
  static LogoutCall logoutCall = LogoutCall();
  static RegisterBiometricCall registerBiometricCall = RegisterBiometricCall();
}

class RegisterUserCall {
  Future<ApiCallResponse> call({
    dynamic? bodyJson,
    String? idempotencyKey = '',
    String? accessToken = '',
    String? language = '',
  }) async {
    final baseUrl = HaatAuthGroup.getBaseUrl(
      accessToken: accessToken,
      language: language,
    );

    final body = _serializeJson(bodyJson);
    final ffApiRequestBody = '''
${body}''';
    return ApiManager.instance.makeApiCall(
      callName: 'RegisterUser',
      apiUrl: '${baseUrl}/auth/register',
      callType: ApiCallType.POST,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
        'Idempotency-Key': '${idempotencyKey}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  bool? isSuccess(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.isSuccess''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? messageAr(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message_ar''',
      ));
  String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.title''',
      ));
  String? errorCode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.errorCode''',
      ));
  String? requestId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.requestId''',
      ));
  String? userId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.userId''',
      ));
  String? mobileMasked(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.mobileMasked''',
      ));
  String? otpExpiresAt(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.otpExpiresAt''',
      ));
  String? devOtpCode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.devOtpCode''',
      ));
}

class ResendOtpCall {
  Future<ApiCallResponse> call({
    String? mobile = '',
    String? accessToken = '',
    String? language = '',
  }) async {
    final baseUrl = HaatAuthGroup.getBaseUrl(
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{"mobile": "${mobile}"}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ResendOtp',
      apiUrl: '${baseUrl}/auth/resend-otp',
      callType: ApiCallType.POST,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  bool? isSuccess(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.isSuccess''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? messageAr(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message_ar''',
      ));
  String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.title''',
      ));
  String? errorCode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.errorCode''',
      ));
  String? requestId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.requestId''',
      ));
  String? userId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.userId''',
      ));
  String? mobileMasked(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.mobileMasked''',
      ));
  String? otpExpiresAt(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.otpExpiresAt''',
      ));
  String? devOtpCode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.devOtpCode''',
      ));
}

class VerifyOtpCall {
  Future<ApiCallResponse> call({
    String? mobile = '',
    String? code = '',
    String? deviceFingerprint = '',
    String? deviceLabel = '',
    String? platform = '',
    String? accessToken = '',
    String? language = '',
  }) async {
    final baseUrl = HaatAuthGroup.getBaseUrl(
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{
  "mobile": "${mobile}",
  "code": "${code}",
  "deviceFingerprint": "${deviceFingerprint}",
  "deviceLabel": "${deviceLabel}",
  "platform": "${platform}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'VerifyOtp',
      apiUrl: '${baseUrl}/auth/verify-otp',
      callType: ApiCallType.POST,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  bool? isSuccess(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.isSuccess''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? messageAr(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message_ar''',
      ));
  String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.title''',
      ));
  String? errorCode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.errorCode''',
      ));
  String? requestId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.requestId''',
      ));
  String? accessToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.accessToken''',
      ));
  String? refreshToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.refreshToken''',
      ));
  String? userId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.userId''',
      ));
  String? sessionId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.sessionId''',
      ));
  String? deviceId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.deviceId''',
      ));
  bool? mustChangePassword(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.data.mustChangePassword''',
      ));
  String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.status''',
      ));
}

class SignInCall {
  Future<ApiCallResponse> call({
    dynamic? bodyJson,
    String? accessToken = '',
    String? language = '',
  }) async {
    final baseUrl = HaatAuthGroup.getBaseUrl(
      accessToken: accessToken,
      language: language,
    );

    final body = _serializeJson(bodyJson);
    final ffApiRequestBody = '''
${body}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SignIn',
      apiUrl: '${baseUrl}/auth/sign-in',
      callType: ApiCallType.POST,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  bool? isSuccess(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.isSuccess''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? messageAr(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message_ar''',
      ));
  String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.title''',
      ));
  String? errorCode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.errorCode''',
      ));
  String? requestId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.requestId''',
      ));
  String? accessToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.accessToken''',
      ));
  String? refreshToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.refreshToken''',
      ));
  String? userId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.userId''',
      ));
  String? sessionId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.sessionId''',
      ));
  String? deviceId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.deviceId''',
      ));
  bool? mustChangePassword(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.data.mustChangePassword''',
      ));
  String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.status''',
      ));
  String? mfaToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.mfaToken''',
      ));
}

class VerifyMfaCall {
  Future<ApiCallResponse> call({
    String? mfaToken = '',
    String? code = '',
    String? deviceFingerprint = '',
    String? deviceLabel = '',
    String? platform = '',
    String? accessToken = '',
    String? language = '',
  }) async {
    final baseUrl = HaatAuthGroup.getBaseUrl(
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{"mfaToken":"${mfaToken}","code":"${code}","deviceFingerprint":"${deviceFingerprint}","deviceLabel":"${deviceLabel}","platform":"${platform}"}''';
    return ApiManager.instance.makeApiCall(
      callName: 'VerifyMfa',
      apiUrl: '${baseUrl}/auth/mfa/verify',
      callType: ApiCallType.POST,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  bool? isSuccess(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.isSuccess''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? messageAr(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message_ar''',
      ));
  String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.title''',
      ));
  String? errorCode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.errorCode''',
      ));
  String? requestId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.requestId''',
      ));
  String? accessToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.accessToken''',
      ));
  String? refreshToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.refreshToken''',
      ));
  String? userId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.userId''',
      ));
  String? sessionId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.sessionId''',
      ));
  String? deviceId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.deviceId''',
      ));
  bool? mustChangePassword(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.data.mustChangePassword''',
      ));
  String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.status''',
      ));
}

class BiometricChallengeCall {
  Future<ApiCallResponse> call({
    String? deviceFingerprint = '',
    String? accessToken = '',
    String? language = '',
  }) async {
    final baseUrl = HaatAuthGroup.getBaseUrl(
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{"deviceFingerprint":"${deviceFingerprint}"}''';
    return ApiManager.instance.makeApiCall(
      callName: 'BiometricChallenge',
      apiUrl: '${baseUrl}/auth/biometric/challenge',
      callType: ApiCallType.POST,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  bool? isSuccess(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.isSuccess''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? messageAr(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message_ar''',
      ));
  String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.title''',
      ));
  String? errorCode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.errorCode''',
      ));
  String? requestId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.requestId''',
      ));
  String? challenge(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.challenge''',
      ));
}

class BiometricVerifyCall {
  Future<ApiCallResponse> call({
    String? deviceFingerprint = '',
    String? signature = '',
    String? accessToken = '',
    String? language = '',
  }) async {
    final baseUrl = HaatAuthGroup.getBaseUrl(
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{"deviceFingerprint":"${deviceFingerprint}","signature":"${signature}"}''';
    return ApiManager.instance.makeApiCall(
      callName: 'BiometricVerify',
      apiUrl: '${baseUrl}/auth/biometric/verify',
      callType: ApiCallType.POST,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  bool? isSuccess(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.isSuccess''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? messageAr(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message_ar''',
      ));
  String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.title''',
      ));
  String? errorCode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.errorCode''',
      ));
  String? requestId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.requestId''',
      ));
  String? accessToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.accessToken''',
      ));
  String? refreshToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.refreshToken''',
      ));
  String? userId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.userId''',
      ));
  String? sessionId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.sessionId''',
      ));
  String? deviceId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.deviceId''',
      ));
  bool? mustChangePassword(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.data.mustChangePassword''',
      ));
  String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.status''',
      ));
}

class RefreshTokenCall {
  Future<ApiCallResponse> call({
    String? refreshToken = '',
    String? accessToken = '',
    String? language = '',
  }) async {
    final baseUrl = HaatAuthGroup.getBaseUrl(
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{"refreshToken":"${refreshToken}"}''';
    return ApiManager.instance.makeApiCall(
      callName: 'RefreshToken',
      apiUrl: '${baseUrl}/auth/refresh',
      callType: ApiCallType.POST,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  bool? isSuccess(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.isSuccess''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? messageAr(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message_ar''',
      ));
  String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.title''',
      ));
  String? errorCode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.errorCode''',
      ));
  String? requestId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.requestId''',
      ));
  String? accessToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.accessToken''',
      ));
  String? refreshToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.refreshToken''',
      ));
}

class SetPasswordCall {
  Future<ApiCallResponse> call({
    dynamic? bodyJson,
    String? accessToken = '',
    String? language = '',
  }) async {
    final baseUrl = HaatAuthGroup.getBaseUrl(
      accessToken: accessToken,
      language: language,
    );

    final body = _serializeJson(bodyJson);
    final ffApiRequestBody = '''
${body}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SetPassword',
      apiUrl: '${baseUrl}/auth/password',
      callType: ApiCallType.POST,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  bool? isSuccess(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.isSuccess''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? messageAr(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message_ar''',
      ));
  String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.title''',
      ));
  String? errorCode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.errorCode''',
      ));
  String? requestId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.requestId''',
      ));
  String? passwordSetAt(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.passwordSetAt''',
      ));
}

class SetPasscodeCall {
  Future<ApiCallResponse> call({
    dynamic? bodyJson,
    String? accessToken = '',
    String? language = '',
  }) async {
    final baseUrl = HaatAuthGroup.getBaseUrl(
      accessToken: accessToken,
      language: language,
    );

    final body = _serializeJson(bodyJson);
    final ffApiRequestBody = '''
[body]''';
    return ApiManager.instance.makeApiCall(
      callName: 'SetPasscode',
      apiUrl: '${baseUrl}/auth/passcode',
      callType: ApiCallType.POST,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  bool? isSuccess(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.isSuccess''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? messageAr(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message_ar''',
      ));
  String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.title''',
      ));
  String? errorCode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.errorCode''',
      ));
  String? requestId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.requestId''',
      ));
  String? passcodeSetAt(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.passcodeSetAt''',
      ));
}

class CheckUsernameCall {
  Future<ApiCallResponse> call({
    String? username = '',
    String? accessToken = '',
    String? language = '',
  }) async {
    final baseUrl = HaatAuthGroup.getBaseUrl(
      accessToken: accessToken,
      language: language,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'CheckUsername',
      apiUrl: '${baseUrl}/auth/username/available?username=${username}',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  bool? isSuccess(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.isSuccess''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? messageAr(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message_ar''',
      ));
  String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.title''',
      ));
  String? errorCode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.errorCode''',
      ));
  String? requestId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.requestId''',
      ));
  String? username(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.username''',
      ));
  bool? available(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.data.available''',
      ));
  List<String>? unmet(dynamic response) => (getJsonField(
        response,
        r'''$.data.unmet''',
        true,
      ) as List?)
          ?.withoutNulls
          .map((x) => castToType<String>(x))
          .withoutNulls
          .toList();
}

class ClaimUsernameCall {
  Future<ApiCallResponse> call({
    String? username = '',
    String? accessToken = '',
    String? language = '',
  }) async {
    final baseUrl = HaatAuthGroup.getBaseUrl(
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{
  "username": "${username}"
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ClaimUsername',
      apiUrl: '${baseUrl}/auth/username',
      callType: ApiCallType.POST,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  bool? isSuccess(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.isSuccess''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? messageAr(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message_ar''',
      ));
  String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.title''',
      ));
  String? errorCode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.errorCode''',
      ));
  String? requestId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.requestId''',
      ));
  String? username(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.username''',
      ));
}

class CredentialStatusCall {
  Future<ApiCallResponse> call({
    String? accessToken = '',
    String? language = '',
  }) async {
    final baseUrl = HaatAuthGroup.getBaseUrl(
      accessToken: accessToken,
      language: language,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'CredentialStatus',
      apiUrl: '${baseUrl}/auth/credentials',
      callType: ApiCallType.GET,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  bool? isSuccess(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.isSuccess''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? messageAr(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message_ar''',
      ));
  String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.title''',
      ));
  String? errorCode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.errorCode''',
      ));
  String? requestId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.requestId''',
      ));
  String? username(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.username''',
      ));
  bool? hasPassword(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.data.hasPassword''',
      ));
  bool? hasPasscode(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.data.hasPasscode''',
      ));
  bool? mobileVerified(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.data.mobileVerified''',
      ));
  bool? mfaEnabled(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.data.mfaEnabled''',
      ));
  bool? mustChangePassword(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.data.mustChangePassword''',
      ));
  String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.status''',
      ));
}

class SignInWithPasscodeCall {
  Future<ApiCallResponse> call({
    String? passcode = '',
    String? accessToken = '',
    String? language = '',
  }) async {
    final baseUrl = HaatAuthGroup.getBaseUrl(
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{"passcode":"${passcode}"}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SignInWithPasscode',
      apiUrl: '${baseUrl}/auth/passcode/verify',
      callType: ApiCallType.POST,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  bool? isSuccess(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.isSuccess''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? messageAr(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message_ar''',
      ));
  String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.title''',
      ));
  String? errorCode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.errorCode''',
      ));
  String? requestId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.requestId''',
      ));
  String? accessToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.accessToken''',
      ));
  String? refreshToken(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.refreshToken''',
      ));
  String? userId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.userId''',
      ));
  String? sessionId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.sessionId''',
      ));
  String? deviceId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.deviceId''',
      ));
  bool? mustChangePassword(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.data.mustChangePassword''',
      ));
  String? status(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.status''',
      ));
}

class LogoutCall {
  Future<ApiCallResponse> call({
    String? accessToken = '',
    String? language = '',
  }) async {
    final baseUrl = HaatAuthGroup.getBaseUrl(
      accessToken: accessToken,
      language: language,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'Logout',
      apiUrl: '${baseUrl}/auth/logout',
      callType: ApiCallType.POST,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      bodyType: BodyType.NONE,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  bool? isSuccess(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.isSuccess''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? messageAr(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message_ar''',
      ));
  String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.title''',
      ));
  String? errorCode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.errorCode''',
      ));
  String? requestId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.requestId''',
      ));
}

class RegisterBiometricCall {
  Future<ApiCallResponse> call({
    String? deviceId = '',
    String? publicKey = '',
    String? accessToken = '',
    String? language = '',
  }) async {
    final baseUrl = HaatAuthGroup.getBaseUrl(
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{"deviceId":"${deviceId}","publicKey":"${publicKey}"}''';
    return ApiManager.instance.makeApiCall(
      callName: 'RegisterBiometric',
      apiUrl: '${baseUrl}/auth/biometric',
      callType: ApiCallType.POST,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
        'Authorization': 'Bearer ${accessToken}',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  bool? isSuccess(dynamic response) => castToType<bool>(getJsonField(
        response,
        r'''$.isSuccess''',
      ));
  String? message(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message''',
      ));
  String? messageAr(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.message_ar''',
      ));
  String? title(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.title''',
      ));
  String? errorCode(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.errorCode''',
      ));
  String? requestId(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.requestId''',
      ));
}

/// End HaatAuth Group Code

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
