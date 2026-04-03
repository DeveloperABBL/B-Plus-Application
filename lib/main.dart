import 'package:brownyplus/core/env/app_environment.dart';
import 'package:brownyplus/core/env/dev_environment.dart';
import 'package:brownyplus/core/widgets/app_router.dart';
import 'package:brownyplus/feature/home/view/home_screen.dart';
import 'package:brownyplus/res/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:brownyplus/feature/authentication/view/on_boarding_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appEnvironment = DevEnvironment(
    appRouter: AppRouter(initialLocation: HomeScreen.pagePath),
  );

  await appEnvironment.loadEnv();

  runApp(MyApp(appEnvironment: appEnvironment));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.appEnvironment, super.key});

  final AppEvnironment appEnvironment;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return ChangeNotifierProvider<AppEvnironment>.value(
          value: appEnvironment,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'BrownyPlus',
            theme: AppTheme.lightTheme,
            routerConfig: appEnvironment.appRouter.router,
          ),
        );
      },
    );
  }
}
