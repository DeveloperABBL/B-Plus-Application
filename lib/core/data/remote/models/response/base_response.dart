class BaseResponse {
  final bool success;
  final String? message;
  final String? errorType;

  BaseResponse({required this.success, this.message, this.errorType});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      success: json['success'] == true || json['status'] == 'success',
      message: json['message']?.toString(),
      errorType: (json['error_type'] ?? json['errorType'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'message': message,
      'error_type': errorType,
    };
  }
}
