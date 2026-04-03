import 'package:brownyplus/core/data/remote/models/response/base_response.dart';

class GetPinResponse extends BaseResponse {
  final String? ciphertext;
  final String? cipher;

  GetPinResponse({
    required super.success,
    super.message,
    super.errorType,
    this.ciphertext,
    this.cipher,
  });

  factory GetPinResponse.fromJson(Map<String, dynamic> json) {
    return GetPinResponse(
      success: json['success'] == true,
      message: json['message']?.toString(),
      errorType: (json['error_type'] ?? json['errorType'])?.toString(),
      ciphertext: json['ciphertext']?.toString(),
      cipher: json['cipher']?.toString(),
    );
  }
}
