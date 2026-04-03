class PinRequest {
  final String customerId;
  final String pin;

  const PinRequest({required this.customerId, required this.pin});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': customerId, 'pin': pin};
  }
}
