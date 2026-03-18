class BaseResponse {
  final bool success;
  final String? message;
  final String? errorType;

  BaseResponse({
    required this.success,
    this.message,
    this.errorType,
  });
}

