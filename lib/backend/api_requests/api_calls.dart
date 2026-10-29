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
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    return '${baseURL}';
  }

  static Map<String, String> headers = {
    'Authorization': 'Bearer [accessToken]',
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
  static KycProviderSessionCall kycProviderSessionCall =
      KycProviderSessionCall();
  static KycProviderResultCall kycProviderResultCall = KycProviderResultCall();
  static MarketplaceBannersCall marketplaceBannersCall =
      MarketplaceBannersCall();
  static WeekStoryCall weekStoryCall = WeekStoryCall();
  static ProductsCall productsCall = ProductsCall();
  static RecentTransactionsCall recentTransactionsCall =
      RecentTransactionsCall();
  static MarketplaceCall marketplaceCall = MarketplaceCall();
  static NotificationsCall notificationsCall = NotificationsCall();
  static NotificationsSeenCall notificationsSeenCall = NotificationsSeenCall();
  static CreateProductCall createProductCall = CreateProductCall();
  static UpdateProductCall updateProductCall = UpdateProductCall();
  static DeleteProductCall deleteProductCall = DeleteProductCall();
  static UploadProductImageCall uploadProductImageCall =
      UploadProductImageCall();
  static BranchesCall branchesCall = BranchesCall();
  static StaffCall staffCall = StaffCall();
  static RolesCall rolesCall = RolesCall();
  static CreateStaffCall createStaffCall = CreateStaffCall();
  static AssignRoleCall assignRoleCall = AssignRoleCall();
  static RevokeRoleCall revokeRoleCall = RevokeRoleCall();
  static CloseBranchCall closeBranchCall = CloseBranchCall();
}

class RegisterUserCall {
  Future<ApiCallResponse> call({
    dynamic? bodyJson,
    String? idempotencyKey = '',
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
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
        'Authorization': 'Bearer ${accessToken}',
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
    String? idempotencyKey = '',
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{
  "mobile": ${mobile == null ? 'null' : '"${mobile}"'},
  "idempotency": ${idempotencyKey == null ? 'null' : '"${idempotencyKey}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ResendOtp',
      apiUrl: '${baseUrl}/auth/resend-otp',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{
  "mobile": ${mobile == null ? 'null' : '"${mobile}"'},
  "code": ${code == null ? 'null' : '"${code}"'},
  "deviceFingerprint": ${deviceFingerprint == null ? 'null' : '"${deviceFingerprint}"'},
  "deviceLabel": ${deviceLabel == null ? 'null' : '"${deviceLabel}"'},
  "platform": ${platform == null ? 'null' : '"${platform}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'VerifyOtp',
      apiUrl: '${baseUrl}/auth/verify-otp',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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
    String? idempotencyKey = '',
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final body = _serializeJson(bodyJson);
    final ffApiRequestBody = '''
{
  "Idempotency-Key": ${idempotencyKey == null ? 'null' : '"${idempotencyKey}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SignIn',
      apiUrl: '${baseUrl}/auth/sign-in',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{"mfaToken":${mfaToken == null ? 'null' : '"${mfaToken}"'},"code":${code == null ? 'null' : '"${code}"'},"deviceFingerprint":${deviceFingerprint == null ? 'null' : '"${deviceFingerprint}"'},"deviceLabel":${deviceLabel == null ? 'null' : '"${deviceLabel}"'},"platform":${platform == null ? 'null' : '"${platform}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'VerifyMfa',
      apiUrl: '${baseUrl}/auth/mfa/verify',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{"deviceFingerprint":${deviceFingerprint == null ? 'null' : '"${deviceFingerprint}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'BiometricChallenge',
      apiUrl: '${baseUrl}/auth/biometric/challenge',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{"deviceFingerprint":${deviceFingerprint == null ? 'null' : '"${deviceFingerprint}"'},"signature":${signature == null ? 'null' : '"${signature}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'BiometricVerify',
      apiUrl: '${baseUrl}/auth/biometric/verify',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{"refreshToken":${refreshToken == null ? 'null' : '"${refreshToken}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'RefreshToken',
      apiUrl: '${baseUrl}/auth/refresh',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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
    String? idempotencyKey = '',
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final body = _serializeJson(bodyJson);
    final ffApiRequestBody = '''
{
  "idempotency": ${idempotencyKey == null ? 'null' : '"${idempotencyKey}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SetPassword',
      apiUrl: '${baseUrl}/auth/password',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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
  String? passwordSetAt(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.passwordSetAt''',
      ));
}

class SetPasscodeCall {
  Future<ApiCallResponse> call({
    String? passcode = '',
    String? idempotencyKey = '',
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{
  "passcode": ${passcode == null ? 'null' : '"${passcode}"'},
  "idempotency": ${idempotencyKey == null ? 'null' : '"${idempotencyKey}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SetPasscode',
      apiUrl: '${baseUrl}/auth/passcode',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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
  String? passcodeSetAt(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.passcodeSetAt''',
      ));
}

class CheckUsernameCall {
  Future<ApiCallResponse> call({
    String? username = '',
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'CheckUsername',
      apiUrl: '${baseUrl}/auth/username/available?username=${username}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
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
    String? idempotencyKey = '',
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{
  "username": ${username == null ? 'null' : '"${username}"'},
  "Idempotency-Key": ${idempotencyKey == null ? 'null' : '"${idempotencyKey}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'ClaimUsername',
      apiUrl: '${baseUrl}/auth/username',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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
  String? username(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.data.username''',
      ));
}

class CredentialStatusCall {
  Future<ApiCallResponse> call({
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'CredentialStatus',
      apiUrl: '${baseUrl}/auth/credentials',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
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
    String? idempotencyKey = '',
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{
  "passcode": ${passcode == null ? 'null' : '"${passcode}"'},
  "Idempotency-Key": ${idempotencyKey == null ? 'null' : '"${idempotencyKey}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'SignInWithPasscode',
      apiUrl: '${baseUrl}/auth/passcode/verify',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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

class LogoutCall {
  Future<ApiCallResponse> call({
    String? idempotencyKey = '',
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{
  "Idempotency-Key": ${idempotencyKey == null ? 'null' : '"${idempotencyKey}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'Logout',
      apiUrl: '${baseUrl}/auth/logout',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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
}

class RegisterBiometricCall {
  Future<ApiCallResponse> call({
    String? deviceId = '',
    String? publicKey = '',
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{"deviceId":${deviceId == null ? 'null' : '"${deviceId}"'},"publicKey":${publicKey == null ? 'null' : '"${publicKey}"'}}''';
    return ApiManager.instance.makeApiCall(
      callName: 'RegisterBiometric',
      apiUrl: '${baseUrl}/auth/biometric',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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
}

class KycProviderSessionCall {
  Future<ApiCallResponse> call({
    String? idempotencyKey = '',
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{
  "Idempotency-Key": ${idempotencyKey == null ? 'null' : '"${escapeStringForJson(idempotencyKey)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'KycProviderSession',
      apiUrl: '${baseUrl}/kyc/user/provider-session',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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
}

class KycProviderResultCall {
  Future<ApiCallResponse> call({
    String? idempotencyKey = '',
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{
  "Idempotency-Key": ${idempotencyKey == null ? 'null' : '"${escapeStringForJson(idempotencyKey)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'KycProviderResult',
      apiUrl: '${baseUrl}/kyc/user/provider-result',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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
}

class MarketplaceBannersCall {
  Future<ApiCallResponse> call({
    String? placement = 'marketplace',
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'MarketplaceBanners',
      apiUrl: '${baseUrl}/banners?placement=${placement}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
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

  List? banners(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
}

class WeekStoryCall {
  Future<ApiCallResponse> call({
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    return ApiManager.instance.makeApiCall(
      callName: ' WeekStory',
      apiUrl: '${baseUrl}/business/week-story',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
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

  List? stories(dynamic response) => getJsonField(
        response,
        r'''$.data.stories''',
        true,
      ) as List?;
}

class ProductsCall {
  Future<ApiCallResponse> call({
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'Products',
      apiUrl: '${baseUrl}/products',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
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

  List? products(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
}

class RecentTransactionsCall {
  Future<ApiCallResponse> call({
    int? limit = 3,
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'RecentTransactions',
      apiUrl: '${baseUrl}/transactions?limit=${limit}',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
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

  List? transactions(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
}

class MarketplaceCall {
  Future<ApiCallResponse> call({
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'Marketplace',
      apiUrl: '${baseUrl}/marketplace',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List? featured(dynamic response) => getJsonField(
        response,
        r'''$.data.featured''',
        true,
      ) as List?;
  List? billers(dynamic response) => getJsonField(
        response,
        r'''$.data.billers''',
        true,
      ) as List?;
  List? brands(dynamic response) => getJsonField(
        response,
        r'''$.data.brands''',
        true,
      ) as List?;
  List? categories(dynamic response) => getJsonField(
        response,
        r'''$.data.categories''',
        true,
      ) as List?;
}

class NotificationsCall {
  Future<ApiCallResponse> call({
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'Notifications',
      apiUrl: '${baseUrl}/notifications',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
      },
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  List? actions(dynamic response) => getJsonField(
        response,
        r'''$.data.actions''',
        true,
      ) as List?;
  List? today(dynamic response) => getJsonField(
        response,
        r'''$.data.today''',
        true,
      ) as List?;
  List? earlier(dynamic response) => getJsonField(
        response,
        r'''$.data.earlier''',
        true,
      ) as List?;
  dynamic unreadCount(dynamic response) => getJsonField(
        response,
        r'''$.data.unreadCount''',
      );
}

class NotificationsSeenCall {
  Future<ApiCallResponse> call({
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{}''';
    return ApiManager.instance.makeApiCall(
      callName: 'NotificationsSeen',
      apiUrl: '${baseUrl}/notifications/seen',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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
}

class CreateProductCall {
  Future<ApiCallResponse> call({
    String? name = '',
    String? unit = '',
    String? priceMinor = '',
    int? quantity,
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{
  "name": ${name == null ? 'null' : '"${escapeStringForJson(name)}"'},
  "unit": ${unit == null ? 'null' : '"${escapeStringForJson(unit)}"'},
  "priceMinor": ${priceMinor == null ? 'null' : '"${escapeStringForJson(priceMinor)}"'},
  "quantity": ${quantity}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CreateProduct',
      apiUrl: '${baseUrl}/products',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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

  dynamic isSuccess(dynamic response) => getJsonField(
        response,
        r'''$.isSuccess''',
      );
  dynamic message(dynamic response) => getJsonField(
        response,
        r'''$.message''',
      );
  dynamic id(dynamic response) => getJsonField(
        response,
        r'''$.data.id''',
      );
}

class UpdateProductCall {
  Future<ApiCallResponse> call({
    String? productId = '',
    String? name = '',
    String? unit = '',
    String? priceMinor = '',
    int? quantity,
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{
  "name": ${name == null ? 'null' : '"${escapeStringForJson(name)}"'},
  "unit": ${unit == null ? 'null' : '"${escapeStringForJson(unit)}"'},
  "priceMinor": ${priceMinor == null ? 'null' : '"${escapeStringForJson(priceMinor)}"'},
  "quantity": ${quantity}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'UpdateProduct',
      apiUrl: '${baseUrl}/products/${productId}',
      callType: ApiCallType.PATCH,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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

  dynamic isSuccess(dynamic response) => getJsonField(
        response,
        r'''$.isSuccess''',
      );
  dynamic message(dynamic response) => getJsonField(
        response,
        r'''$.message''',
      );
}

class DeleteProductCall {
  Future<ApiCallResponse> call({
    String? productId = '',
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'DeleteProduct',
      apiUrl: '${baseUrl}/products/${productId}',
      callType: ApiCallType.DELETE,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
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

  dynamic isSuccess(dynamic response) => getJsonField(
        response,
        r'''$.isSuccess''',
      );
  dynamic message(dynamic response) => getJsonField(
        response,
        r'''$.message''',
      );
}

class UploadProductImageCall {
  Future<ApiCallResponse> call({
    String? productId = '',
    FFUploadedFile? file,
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'UploadProductImage',
      apiUrl: '${baseUrl}/products/${productId}/image',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
      },
      params: {
        'file': file,
      },
      bodyType: BodyType.MULTIPART,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  dynamic isSuccess(dynamic response) => getJsonField(
        response,
        r'''$.isSuccess''',
      );
  dynamic message(dynamic response) => getJsonField(
        response,
        r'''$.message''',
      );
}

class BranchesCall {
  Future<ApiCallResponse> call({
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'Branches',
      apiUrl: '${baseUrl}/organizations/branches',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
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

  List? branches(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
  dynamic message(dynamic response) => getJsonField(
        response,
        r'''$.message''',
      );
}

class StaffCall {
  Future<ApiCallResponse> call({
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'Staff',
      apiUrl: '${baseUrl}/organizations/staff',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
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

  List? staff(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
  dynamic message(dynamic response) => getJsonField(
        response,
        r'''$.message''',
      );
}

class RolesCall {
  Future<ApiCallResponse> call({
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'Roles',
      apiUrl: '${baseUrl}/rbac/roles',
      callType: ApiCallType.GET,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
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

  List? roles(dynamic response) => getJsonField(
        response,
        r'''$.data''',
        true,
      ) as List?;
  dynamic message(dynamic response) => getJsonField(
        response,
        r'''$.message''',
      );
}

class CreateStaffCall {
  Future<ApiCallResponse> call({
    String? fullName = '',
    String? username = '',
    String? branchId = '',
    String? roleId = '',
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{
  "fullName": ${fullName == null ? 'null' : '"${escapeStringForJson(fullName)}"'},
  "username": ${username == null ? 'null' : '"${escapeStringForJson(username)}"'},
  "branchId": ${branchId == null ? 'null' : '"${escapeStringForJson(branchId)}"'},
  "roleId": ${roleId == null ? 'null' : '"${escapeStringForJson(roleId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'CreateStaff',
      apiUrl: '${baseUrl}/organizations/staff',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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

  dynamic staff(dynamic response) => getJsonField(
        response,
        r'''$.data''',
      );
  dynamic errorField(dynamic response) => getJsonField(
        response,
        r'''$.data.field''',
      );
  dynamic message(dynamic response) => getJsonField(
        response,
        r'''$.message''',
      );
}

class AssignRoleCall {
  Future<ApiCallResponse> call({
    dynamic? bodyJsonJson,
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final bodyJson = _serializeJson(bodyJsonJson);
    final ffApiRequestBody = '''
${bodyJson}''';
    return ApiManager.instance.makeApiCall(
      callName: 'AssignRole',
      apiUrl: '${baseUrl}/rbac/assignments',
      callType: ApiCallType.POST,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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

  dynamic message(dynamic response) => getJsonField(
        response,
        r'''$.message''',
      );
}

class RevokeRoleCall {
  Future<ApiCallResponse> call({
    String? assignmentId = '',
    String? userId = '',
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    final ffApiRequestBody = '''
{
  "userId": ${userId == null ? 'null' : '"${escapeStringForJson(userId)}"'}
}''';
    return ApiManager.instance.makeApiCall(
      callName: 'RevokeRole',
      apiUrl: '${baseUrl}/rbac/assignments/${assignmentId}',
      callType: ApiCallType.DELETE,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
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
      alwaysAllowBody: true,
    );
  }

  dynamic message(dynamic response) => getJsonField(
        response,
        r'''$.message''',
      );
}

class CloseBranchCall {
  Future<ApiCallResponse> call({
    String? branchId = '',
    String? baseURL,
    String? authToken = '',
    String? dataSource,
    String? accessToken = '',
    String? language = '',
  }) async {
    baseURL ??= FFDevEnvironmentValues().baseURL;
    dataSource ??= FFDevEnvironmentValues().dataSource;
    final baseUrl = HaatAuthGroup.getBaseUrl(
      baseURL: baseURL,
      authToken: authToken,
      dataSource: dataSource,
      accessToken: accessToken,
      language: language,
    );

    return ApiManager.instance.makeApiCall(
      callName: 'CloseBranch',
      apiUrl: '${baseUrl}/organizations/branches/${branchId}',
      callType: ApiCallType.DELETE,
      headers: {
        'Authorization': 'Bearer ${accessToken}',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Accept-Language': '${language}',
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

  dynamic message(dynamic response) => getJsonField(
        response,
        r'''$.message''',
      );
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

String? escapeStringForJson(String? input) {
  if (input == null) {
    return null;
  }
  final encoded = jsonEncode(input);
  return encoded.substring(1, encoded.length - 1);
}
