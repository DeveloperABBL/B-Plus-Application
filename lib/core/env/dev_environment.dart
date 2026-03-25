// import 'dart:async';

// import 'package:brownyplus/core/core_index.dart';
// import 'package:brownyplus/core/providers/customer_provider.dart';
// import 'package:brownyplus/core/widgets/app_router.dart';
// import 'package:brownyplus/core/data/remote/models/api_configs.dart';
// import 'package:brownyplus/core/viewmodels/app_preferences.dart';

// import 'package:brownyplus/feature/authentication/view/on_boarding_screen.dart';

// class DevEnvironment extends AppEvnironment {
//   DevEnvironment({
//     ApiConfigs? apiConfigs,
//     AppPreferences? appPreferences,
//     AppRouter? appRouter,
//   });

//   @override
//   Future<void> loadEnv() {
//     // TODO: implement loadEnv
//     throw UnimplementedError();
//   }

//   @override
//   String get laravelAppKey {
//     // TODO: ย้ายไปเก็บใน .env file หรือ build config
//     // แนะนำใช้ package 'flutter_dotenv' หรือ '--dart-define'
//     return const String.fromEnvironment('serverKey');
//   }

//   @override
//   // TODO: implement currentUser
//   // CustomerProvider get currentUser => throw UnimplementedError();
// }
