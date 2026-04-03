import 'package:brownyplus/core/data/remote/app_client.dart';
import 'package:brownyplus/core/data/remote/models/api_model_index.dart';
import 'package:brownyplus/core/env/app_environment.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/dio.dart';

class AuthLoginResult {
  final String? customerId;
  final bool firstLogin;
  final String? error;

  bool get isSuccess => error == null && (customerId ?? '').isNotEmpty;

  AuthLoginResult.success({required this.customerId, required this.firstLogin})
    : error = null;

  AuthLoginResult.failure({required this.error})
    : customerId = null,
      firstLogin = false;
}

class AuthOtpRequestResult {
  final String? refCode;
  final int? expiredInSeconds;
  final String? error;

  bool get isSuccess => error == null && (refCode ?? '').isNotEmpty;

  AuthOtpRequestResult.success({
    required this.refCode,
    required this.expiredInSeconds,
  }) : error = null;

  AuthOtpRequestResult.failure({required this.error})
    : refCode = null,
      expiredInSeconds = null;
}

class AuthOtpVerifyResult {
  final String? customerId;
  final String? error;

  bool get isSuccess => error == null && (customerId ?? '').isNotEmpty;

  AuthOtpVerifyResult.success({required this.customerId}) : error = null;

  AuthOtpVerifyResult.failure({required this.error}) : customerId = null;
}

class AuthPinServerResult {
  final bool hasPin;
  final String? ciphertext;
  final String? cipher;
  final String? error;

  bool get isSuccess => error == null;

  AuthPinServerResult({
    required this.hasPin,
    this.ciphertext,
    this.cipher,
    this.error,
  });

  factory AuthPinServerResult.none() => AuthPinServerResult(hasPin: false);

  factory AuthPinServerResult.success({
    required String? ciphertext,
    required String? cipher,
  }) {
    final hasPin = (ciphertext ?? '').isNotEmpty;
    return AuthPinServerResult(
      hasPin: hasPin,
      ciphertext: ciphertext,
      cipher: cipher,
    );
  }

  factory AuthPinServerResult.failure(String message) =>
      AuthPinServerResult(hasPin: false, error: message);
}

class AuthApi {
  final AppClient _apiClient;

  AuthApi._(this._apiClient);

  factory AuthApi.fromEnvironment(AppEvnironment environment) {
    return AuthApi._(AppClient.init(environment.apiConfig));
  }

  String _messageFromDioException(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['error'] ?? data['errorType'];
      final errorType = data['error_type'] ?? data['errorType'];
      if (message != null) return message.toString();
      if (errorType != null) return errorType.toString();
    }
    return e.message ?? 'Unknown error';
  }

  Future<AuthLoginResult> login({
    required String username,
    required String password,
  }) async {
    try {
      final HttpResponse<AuthLoginResponse> res = await _apiClient.login(
        CustomerCredential(username: username, password: password),
      );
      final response = res.data;
      if (!response.success) {
        return AuthLoginResult.failure(
          error: response.message ?? 'Login failed',
        );
      }

      final customerId = response.data?.customerId;
      if ((customerId ?? '').isEmpty) {
        return AuthLoginResult.failure(error: 'Missing customer id');
      }

      return AuthLoginResult.success(
        customerId: customerId,
        firstLogin: response.data?.firstLogin ?? false,
      );
    } on DioException catch (e) {
      return AuthLoginResult.failure(error: _messageFromDioException(e));
    } catch (e) {
      return AuthLoginResult.failure(error: e.toString());
    }
  }

  Future<AuthOtpRequestResult> requestOtp({required String username}) async {
    try {
      final HttpResponse<RequestOtpResponse> res = await _apiClient.requestOtp(
        RequestOtpRequest(username: username),
      );
      final response = res.data;
      if (!response.success) {
        return AuthOtpRequestResult.failure(
          error: response.message ?? 'Request OTP failed',
        );
      }

      final data = response.data;
      return AuthOtpRequestResult.success(
        refCode: data?.refCode,
        expiredInSeconds: data?.expiredInSeconds ?? 60,
      );
    } on DioException catch (e) {
      return AuthOtpRequestResult.failure(error: _messageFromDioException(e));
    } catch (e) {
      return AuthOtpRequestResult.failure(error: e.toString());
    }
  }

  Future<AuthOtpVerifyResult> verifyOtp({
    required String username,
    required String refCode,
    required String otp,
  }) async {
    try {
      final HttpResponse<VerifyOtpResponse> res = await _apiClient.verifyOtp(
        VerifyOtpRequest(username: username, refCode: refCode, otp: otp),
      );
      final response = res.data;
      if (!response.success) {
        return AuthOtpVerifyResult.failure(
          error: response.message ?? 'OTP invalid',
        );
      }

      final customerId = response.customerId;
      if ((customerId ?? '').isEmpty) {
        return AuthOtpVerifyResult.failure(error: 'Missing customer id');
      }

      return AuthOtpVerifyResult.success(customerId: customerId);
    } on DioException catch (e) {
      return AuthOtpVerifyResult.failure(error: _messageFromDioException(e));
    } catch (e) {
      return AuthOtpVerifyResult.failure(error: e.toString());
    }
  }

  Future<bool> updatePassword({
    required String customerId,
    required String newPassword,
  }) async {
    try {
      final HttpResponse<BaseResponse> res = await _apiClient.updatePassword(
        UpdatePasswordRequest(customerId: customerId, newPassword: newPassword),
      );
      return res.data.success;
    } on DioException {
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<AuthPinServerResult> getPinFromServer({
    required String customerId,
  }) async {
    try {
      final HttpResponse<GetPinResponse> res = await _apiClient.getPin(
        customerId,
      );
      final response = res.data;
      if (!response.success) {
        return AuthPinServerResult.failure(
          response.message ?? 'Failed to get pin',
        );
      }

      return AuthPinServerResult.success(
        ciphertext: response.ciphertext,
        cipher: response.cipher,
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 404) return AuthPinServerResult.none();
      return AuthPinServerResult.failure(_messageFromDioException(e));
    } catch (e) {
      return AuthPinServerResult.failure(e.toString());
    }
  }

  Future<bool> setPin({required String customerId, required String pin}) async {
    try {
      final HttpResponse<BaseResponse> res = await _apiClient.setPin(
        PinRequest(customerId: customerId, pin: pin),
      );
      return res.data.success;
    } on DioException {
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> verifyPin({
    required String customerId,
    required String pin,
  }) async {
    try {
      final HttpResponse<BaseResponse> res = await _apiClient.verifyPin(
        PinRequest(customerId: customerId, pin: pin),
      );
      return res.data.success;
    } on DioException {
      return false;
    } catch (_) {
      return false;
    }
  }
}
