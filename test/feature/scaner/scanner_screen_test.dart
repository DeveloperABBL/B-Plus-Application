import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:brownyplus/feature/scaner/view/scanner_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    const channel = MethodChannel('flutter.baseflow.com/permissions/methods');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      switch (call.method) {
        case 'checkPermissionStatus':
          return 0; // PermissionStatus.denied
        case 'requestPermissions':
          // Permission.camera.value == 1
          return <int, int>{1: 0};
        case 'openAppSettings':
          return true;
        default:
          return null;
      }
    });
  });

  tearDown(() {
    const channel = MethodChannel('flutter.baseflow.com/permissions/methods');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('ScannerScreen shows title and permission gate when camera denied',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (context, child) => const MaterialApp(
          home: ScannerScreen(),
        ),
      ),
    );

    expect(find.byType(ScannerScreen), findsOneWidget);

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('การสแกน'), findsOneWidget);
    expect(find.text('ต้องการสิทธิ์ใช้กล้อง'), findsOneWidget);
    expect(find.textContaining('เลือกรูป QR จากคลังภาพ'), findsOneWidget);
    expect(find.byType(SvgPicture), findsWidgets);
  });
}
