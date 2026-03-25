// import 'package:brownyplus/core/env/dev_environment.dart';
// import 'package:brownyplus/core/env/app_environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brownyplus/core/widgets/app_router.dart';
// import 'package:brownyplus/feature/authentication/view/on_boarding_screen.dart';
// import 'package:brownyplus/feature/home/view/home_screen.dart';
// import 'package:brownyplus/feature/service/view/service_screen.dart';
import 'package:brownyplus/feature/authentication/view/forgot_password_screen.dart';
// import 'package:brownyplus/feature/authentication/view/otp_screen.dart';

import 'package:brownyplus/res/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        // final router = AppRouter(initialLocation: OtpScreen.pagePath).router;
        final router = AppRouter(
          initialLocation: ForgotPasswordScreen.pagePath,
        ).router;
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'BrownyPlus',
          theme: AppTheme.lightTheme,
          routerConfig: router,
        );
      },
    );
  }
}
