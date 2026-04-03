// import 'package:brownyplus/core/widgets/app_text.dart';
import 'package:brownyplus/feature/authentication/view/on_boarding_screen.dart';
import 'package:brownyplus/feature/authentication/view/login_screen.dart';
import 'package:brownyplus/feature/authentication/screen/app_pin_page.dart';
import 'package:brownyplus/feature/authentication/viewmodel/pin_biometric_viewmodel.dart';
import 'package:brownyplus/feature/authentication/view/biometric_screen.dart';
import 'package:brownyplus/feature/authentication/view/forgot_password_screen.dart';
import 'package:brownyplus/feature/authentication/view/otp_screen.dart';
import 'package:brownyplus/feature/authentication/view/reset_password_screen.dart';
import 'package:brownyplus/feature/home/view/home_screen.dart';
import 'package:brownyplus/feature/home/widgets/home_shell.dart';
import 'package:brownyplus/feature/shop/view/shop_screen.dart';
import 'package:brownyplus/feature/wallet/view/wallet_screen.dart';
import 'package:brownyplus/feature/service/view/service_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

class AppRouter {
  AppRouter({required this.initialLocation});

  final String initialLocation;

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  late final router = GoRouter(
    navigatorKey: rootNavigatorKey,
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
        path: CreateAppPinPage.pagePath,
        name: CreateAppPinPage.pageName,
        builder: (context, state) => const CreateAppPinPage(
          process: PinBiometricPross.verifyByPin,
        ),
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          final navIndex =
              navigationShell.currentIndex < 2 ? navigationShell.currentIndex : 3;
          return HomeShell(
            currentIndex: navIndex,
            body: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: HomeScreen.pagePath,
                name: HomeScreen.pageName,
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: ShopScreen.pagePath,
                name: ShopScreen.pageName,
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const ShopScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: WalletScreen.pagePath,
                name: WalletScreen.pageName,
                pageBuilder: (context, state) => NoTransitionPage<void>(
                  key: state.pageKey,
                  child: const WalletScreen(),
                ),
              ),
            ],
          ),
        ],
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
