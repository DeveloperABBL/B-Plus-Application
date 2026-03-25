// import 'package:brownyplus/core/widgets/app_text.dart';
import 'package:brownyplus/feature/authentication/view/on_boarding_screen.dart';
import 'package:brownyplus/feature/authentication/view/login_screen.dart';
import 'package:brownyplus/feature/authentication/view/pin_screen.dart';
import 'package:brownyplus/feature/authentication/view/biometric_screen.dart';
import 'package:brownyplus/feature/authentication/view/forgot_password_screen.dart';
import 'package:brownyplus/feature/authentication/view/otp_screen.dart';
import 'package:brownyplus/feature/authentication/view/reset_password_screen.dart';
import 'package:brownyplus/feature/home/view/home_screen.dart';
import 'package:brownyplus/feature/service/view/service_screen.dart';

// import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

class AppRouter {
  AppRouter({required this.initialLocation});

  final String initialLocation;

  late final router = GoRouter(
    initialLocation: initialLocation,

    debugLogDiagnostics: true,

    routes: [
      GoRoute(
        path: OnBoardingScreen.pagePath,
        name: OnBoardingScreen.pageName,
        builder: (context, state) => const OnBoardingScreen(),
      ),
      GoRoute(
        path: LoginScreen.pagePath,
        name: LoginScreen.pageName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: PinScreen.pagePath,
        name: PinScreen.pageName,
        builder: (context, state) => const PinScreen(),
      ),
      GoRoute(
        path: BiometricScreen.pagePath,
        name: BiometricScreen.pageName,
        builder: (context, state) => const BiometricScreen(),
      ),
      GoRoute(
        path: ForgotPasswordScreen.pagePath,
        name: ForgotPasswordScreen.pageName,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: OtpScreen.pagePath,
        name: OtpScreen.pageName,
        builder: (context, state) => const OtpScreen(),
      ),
      GoRoute(
        path: ResetPasswordScreen.pagePath,
        name: ResetPasswordScreen.pageName,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: HomeScreen.pagePath,
        name: HomeScreen.pageName,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: ServiceScreen.pagePath,
        name: ServiceScreen.pageName,
        builder: (context, state) {
          final tab = state.uri.queryParameters['tab'] ?? 'management';
          return ServiceScreen(initialTab: tab);
        },
      ),
    ],
  );
}
