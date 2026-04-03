import 'package:brownyplus/core/data/remote/models/response/base_response.dart';

class RequestOtpResponse extends BaseResponse {
  final RequestOtpData? data;

  RequestOtpResponse({
    required super.success,
    super.message,
    super.errorType,
    this.data,
  });

  factory RequestOtpResponse.fromJson(Map<String, dynamic> json) {
    final dataJson = json['data'];
    return RequestOtpResponse(
      success: json['success'] == true,
      message: json['message']?.toString(),
      errorType: (json['error_type'] ?? json['errorType'])?.toString(),
      data: dataJson is Map<String, dynamic>
          ? RequestOtpData.fromJson(dataJson)
          : null,
    );
  }
}

class RequestOtpData {
  final String? refCode;
  final int expiredInSeconds;

  const RequestOtpData({required this.refCode, required this.expiredInSeconds});

  factory RequestOtpData.fromJson(Map<String, dynamic> json) {
    final rawExpired = json['expired_in'];
    final expired = rawExpired is int
        ? rawExpired
        : rawExpired is num
        ? rawExpired.toInt()
        : 60;
    return RequestOtpData(
      refCode: json['ref_code']?.toString(),
      expiredInSeconds: expired,
    );
  }
}
