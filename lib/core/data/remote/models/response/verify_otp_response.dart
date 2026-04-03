import 'package:brownyplus/core/data/remote/models/response/base_response.dart';

class VerifyOtpResponse extends BaseResponse {
  final String? customerId;

  VerifyOtpResponse({
    required super.success,
    super.message,
    super.errorType,
    this.customerId,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    String? customerId = json['customer_id']?.toString();
    if ((customerId ?? '').isEmpty && data is Map<String, dynamic>) {
      customerId = data['customer_id']?.toString();
    }

    return VerifyOtpResponse(
      success: json['success'] == true,
      message: json['message']?.toString(),
      errorType: (json['error_type'] ?? json['errorType'])?.toString(),
      customerId: customerId,
    );
  }
}
