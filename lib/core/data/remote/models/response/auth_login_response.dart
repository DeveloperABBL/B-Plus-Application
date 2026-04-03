import 'package:brownyplus/core/data/remote/models/response/base_response.dart';

class AuthLoginResponse extends BaseResponse {
  final AuthLoginData? data;

  AuthLoginResponse({
    required super.success,
    super.message,
    super.errorType,
    this.data,
  });

  factory AuthLoginResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];
    return AuthLoginResponse(
      success: json['success'] == true,
      message: json['message']?.toString(),
      errorType: (json['error_type'] ?? json['errorType'])?.toString(),
      data: dataJson is Map<String, dynamic>
          ? AuthLoginData.fromJson(dataJson)
          : null,
    );
  }
}

class AuthLoginData {
  final String? customerId;
  final bool firstLogin;

  const AuthLoginData({required this.customerId, required this.firstLogin});

  factory AuthLoginData.fromJson(Map<String, dynamic> json) {
    return AuthLoginData(
      customerId: json['id']?.toString(),
      firstLogin: json['first_login'] == true,
    );
  }
}
