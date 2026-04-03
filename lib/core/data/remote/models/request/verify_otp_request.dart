class VerifyOtpRequest {
  final String username;
  final String refCode;
  final String otp;

  const VerifyOtpRequest({
    required this.username,
    required this.refCode,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'username': username,
      'ref_code': refCode,
      'otp': otp,
    };
  }
}
