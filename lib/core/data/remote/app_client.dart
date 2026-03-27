import 'package:brownyplus/core/env/app_environment.dart';
import 'package:dio/dio.dart';

class AppClient {
  AppClient._(this.dio);

  final Dio dio;

  factory AppClient.fromEnvironment(AppEvnironment environment) {
    return AppClient._(
      Dio(
        BaseOptions(
          baseUrl: environment.apiConfig.baseUrl,
          headers: <String, String>{
            if (environment.apiConfig.token.isNotEmpty)
              'Authorization': 'Bearer ${environment.apiConfig.token}',
            // keep compatibility with both header styles
            'clientVersion': environment.apiConfig.clientVersion,
            'X-Client-Version': environment.apiConfig.clientVersion,
          },
        ),
      ),
    );
  }
}

// =========================
// Auth API (moved here)
// =========================

class AuthLoginResult {
  final String? customerId;
  final bool firstLogin;
  final String? error;

  bool get isSuccess => error == null && (customerId ?? '').isNotEmpty;

  AuthLoginResult.success({
    required this.customerId,
    required this.firstLogin,
  }) : error = null;

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
    final hasPin = (ciphertext ?? '').toString().isNotEmpty;
    return AuthPinServerResult(
      hasPin: hasPin,
      ciphertext: ciphertext,
      cipher: cipher,
    );
  }

  factory AuthPinServerResult.failure(String message) => AuthPinServerResult(
        hasPin: false,
        error: message,
      );
}

class AuthApi {
  final Dio _dio;

  AuthApi._(this._dio);

  factory AuthApi.fromEnvironment(AppEvnironment environment) {
    final appClient = AppClient.fromEnvironment(environment);
    return AuthApi._(appClient.dio);
  }

  String _messageFromDioException(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
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
      final res = await _dio.post(
        '/customer/login',
        data: <String, dynamic>{
          'username': username,
          'password': password,
        },
      );

      final json = res.data;
      if (json is! Map) {
        return AuthLoginResult.failure(
          error: 'Unexpected response format',
        );
      }

      final success = json['success'] == true;
      if (!success) {
        return AuthLoginResult.failure(
          error: json['message']?.toString() ?? 'Login failed',
        );
      }

      final data = json['data'];
      if (data is! Map) {
        return AuthLoginResult.failure(
          error: 'Missing login data',
        );
      }

      final customerId = data['id']?.toString();
      final firstLogin = data['first_login'] == true;

      if ((customerId ?? '').isEmpty) {
        return AuthLoginResult.failure(
          error: 'Missing customer id',
        );
      }

      return AuthLoginResult.success(
        customerId: customerId,
        firstLogin: firstLogin,
      );
    } on DioException catch (e) {
      return AuthLoginResult.failure(error: _messageFromDioException(e));
    } catch (e) {
      return AuthLoginResult.failure(error: e.toString());
    }
  }

  Future<AuthOtpRequestResult> requestOtp({required String username}) async {
    try {
      final res = await _dio.post(
        '/customer/request-otp',
        data: <String, dynamic>{
          'username': username,
        },
      );

      final json = res.data;
      if (json is! Map) {
        return AuthOtpRequestResult.failure(
          error: 'Unexpected response format',
        );
      }

      final success = json['success'] == true;
      if (!success) {
        return AuthOtpRequestResult.failure(
          error: json['message']?.toString() ?? 'Request OTP failed',
        );
      }

      final data = json['data'];
      if (data is! Map) {
        return AuthOtpRequestResult.failure(
          error: 'Missing OTP data',
        );
      }

      final refCode = data['ref_code']?.toString() ?? '';

      final expiredInRaw = data['expired_in'];
      int? expiredInSeconds;
      if (expiredInRaw is int) {
        expiredInSeconds = expiredInRaw;
      } else if (expiredInRaw is num) {
        expiredInSeconds = expiredInRaw.toInt();
      }

      return AuthOtpRequestResult.success(
        refCode: refCode,
        expiredInSeconds: expiredInSeconds ?? 60,
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
      final res = await _dio.post(
        '/customer/verify-otp',
        data: <String, dynamic>{
          'username': username,
          'ref_code': refCode,
          'otp': otp,
        },
      );

      final json = res.data;
      if (json is! Map) {
        return AuthOtpVerifyResult.failure(
          error: 'Unexpected response format',
        );
      }

      final success = json['success'] == true;
      if (!success) {
        return AuthOtpVerifyResult.failure(
          error: json['message']?.toString() ?? 'OTP invalid',
        );
      }

      final customerId = json['customer_id']?.toString() ??
          (json['data'] is Map ? (json['data']['customer_id']?.toString()) : null);

      if ((customerId ?? '').isEmpty) {
        return AuthOtpVerifyResult.failure(
          error: 'Missing customer id',
        );
      }

      return AuthOtpVerifyResult.success(customerId: customerId!);
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
      final res = await _dio.put(
        '/customer/update-password',
        data: <String, dynamic>{
          'id': customerId,
          'new_password': newPassword,
        },
      );

      final json = res.data;
      if (json is! Map) return false;
      return json['success'] == true;
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
      final res = await _dio.get('/customer/$customerId/get-pin');
      final json = res.data;
      if (json is! Map) return AuthPinServerResult.failure('Bad response');

      final success = json['success'] == true;
      if (!success) {
        return AuthPinServerResult.failure(
          json['message']?.toString() ?? 'Failed to get pin',
        );
      }

      final ciphertext = json['ciphertext']?.toString();
      final cipher = json['cipher']?.toString();

      return AuthPinServerResult.success(
        ciphertext: ciphertext,
        cipher: cipher,
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 404) return AuthPinServerResult.none();
      return AuthPinServerResult.failure(_messageFromDioException(e));
    } catch (e) {
      return AuthPinServerResult.failure(e.toString());
    }
  }

  Future<bool> setPin({
    required String customerId,
    required String pin,
  }) async {
    try {
      final res = await _dio.post(
        '/customer/set-pin',
        data: <String, dynamic>{
          'id': customerId,
          'pin': pin,
        },
      );

      final json = res.data;
      if (json is! Map) return false;
      return json['success'] == true;
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
      final res = await _dio.post(
        '/customer/verify-pin',
        data: <String, dynamic>{
          'id': customerId,
          'pin': pin,
        },
      );

      final json = res.data;
      if (json is! Map) return false;
      return json['success'] == true;
    } on DioException {
      return false;
    } catch (_) {
      return false;
    }
  }
}

