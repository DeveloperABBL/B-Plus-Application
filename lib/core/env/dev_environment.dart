import 'dart:async';
import 'dart:convert';

import 'package:brownyplus/core/core_index.dart';
import 'package:brownyplus/core/data/api_configs.dart';
import 'package:brownyplus/core/widgets/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DevEnvironment extends AppEvnironment {
  DevEnvironment({
    ApiConfigs? apiConfigs,
    // AppPreferences? appPreferences,
    AppRouter? appRouter,
  }) : super(
         apiConfigs: apiConfigs,
         appRouter: appRouter,
       );

  @override
  Future<void> loadEnv() async {
    final envJson = await rootBundle.loadString('env/dev.json');
    final envMap = jsonDecode(envJson) as Map<String, dynamic>;
    final config = ApiConfigs.fromJson(envMap);

    apiConfig = config.copyWith(
      baseUrl: _resolveLocalhostBaseUrl(config.baseUrl),
    );
    notifyListeners();
  }

  @override
  String get laravelAppKey {
    return const String.fromEnvironment('serverKey', defaultValue: '');
  }

  @override
  // TODO: implement currentUser
  // CustomerProvider get currentUser => throw UnimplementedError();

  String _resolveLocalhostBaseUrl(String baseUrl) {
    if (baseUrl.isEmpty) {
      return baseUrl;
    }

    final uri = Uri.tryParse(baseUrl);
    if (uri == null) {
      return baseUrl;
    }

    final normalizedHost = uri.host.toLowerCase();
    final isLoopbackHost =
        normalizedHost == 'localhost' || normalizedHost == '127.0.0.1';

    if (!isLoopbackHost) {
      return baseUrl;
    }

    if (kIsWeb) {
      return baseUrl;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return uri.replace(host: '10.0.2.2').toString();
    }

    return baseUrl;
  }
}
