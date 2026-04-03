class ApiConfigs {
  final String baseUrl;
  final String token;
  final String clientVersion;

  /// Laravel `APP_KEY` รูปแบบ `base64:...` สำหรับ decrypt ciphertext ของ PIN (จาก env)
  final String serverKey;

  ApiConfigs({
    required this.baseUrl,
    required this.token,
    required this.clientVersion,
    this.serverKey = '',
  });

  factory ApiConfigs.fromJson(Map<String, dynamic> json) {
    return ApiConfigs(
      baseUrl: json['baseUrl'] as String? ?? '',
      token: json['token'] as String? ?? '',
      clientVersion: json['clientVersion'] as String? ?? 'dev',
      serverKey: json['serverKey'] as String? ?? json['APP_KEY'] as String? ?? '',
    );
  }

  ApiConfigs copyWith({
    String? baseUrl,
    String? token,
    String? clientVersion,
    String? serverKey,
  }) {
    return ApiConfigs(
      baseUrl: baseUrl ?? this.baseUrl,
      token: token ?? this.token,
      clientVersion: clientVersion ?? this.clientVersion,
      serverKey: serverKey ?? this.serverKey,
    );
  }
}
