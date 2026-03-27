// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'dart:ui';

import 'package:brownyplus/core/env/dev_environment.dart';
import 'package:brownyplus/core/widgets/app_router.dart';
import 'package:brownyplus/feature/authentication/view/on_boarding_screen.dart';
import 'package:brownyplus/main.dart';

void main() {
  testWidgets('BrownyPlus loads initial route', (WidgetTester tester) async {
    // In widget tests the default viewport can be too small which causes
    // RenderFlex overflow on onboarding layout. Set a "phone-like" size.
    tester.binding.window.physicalSizeTestValue = const Size(1080, 1920);
    tester.binding.window.devicePixelRatioTestValue = 3.0;

    final appEnvironment = DevEnvironment(
      appRouter: AppRouter(
        initialLocation: OnBoardingScreen.pagePath,
      ),
    );

    // loadEnv reads `env/dev.json` for baseUrl/token used by AppClient.
    await appEnvironment.loadEnv();

    await tester.pumpWidget(MyApp(appEnvironment: appEnvironment));
    await tester.pumpAndSettle();

    // Verify that OnBoardingScreen is rendered.
    expect(
      find.text('พื้นที่สำหรับทีมงาน Browny เท่านั้น'),
      findsOneWidget,
    );
  });
}
