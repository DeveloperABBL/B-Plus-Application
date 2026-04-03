class UpdatePasswordRequest {
  final String customerId;
  final String newPassword;

  const UpdatePasswordRequest({
    required this.customerId,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': customerId, 'new_password': newPassword};
  }
}
