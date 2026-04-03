class CustomerCredential {
  final String username;
  final String password;

  CustomerCredential({required this.username, required this.password});

  factory CustomerCredential.fromJson(Map<String, dynamic> json) {
    return CustomerCredential(
      username: json['username']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'username': username, 'password': password};
  }
}
