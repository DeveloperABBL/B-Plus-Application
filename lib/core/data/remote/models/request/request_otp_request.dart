class RequestOtpRequest {
  final String username;

  const RequestOtpRequest({required this.username});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'username': username};
  }
}
