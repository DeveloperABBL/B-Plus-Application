class ApiConfigs {
  final String baseUrl;
  final String token;
  final String clientVersion;

  ApiConfigs({
    required this.baseUrl,
    required this.token,
    required this.clientVersion,
  });

  factory ApiConfigs.fromJson(Map<String, dynamic> json) {
    return ApiConfigs(
      baseUrl: json['baseUrl'] as String? ?? '',
      token: json['token'] as String? ?? '',
      clientVersion: json['clientVersion'] as String? ?? 'dev',
    );
  }

  ApiConfigs copyWith({
    String? baseUrl,
    String? token,
    String? clientVersion,
  }) {
    return ApiConfigs(
      baseUrl: baseUrl ?? this.baseUrl,
      token: token ?? this.token,
      clientVersion: clientVersion ?? this.clientVersion,
    );
  }
}
