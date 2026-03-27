import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brownyplus/feature/scaner/view/scanner_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  testWidgets('ScannerScreen UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (context, child) => const MaterialApp(
          home: ScannerScreen(),
        ),
      ),
    );

    // Verify if ScannerScreen is rendered
    expect(find.byType(ScannerScreen), findsOneWidget);

    // Verify title text
    expect(find.text('การสแกน'), findsOneWidget);

    // Verify hint message text
    expect(find.textContaining('กรุณาสแกนที่ QR Code'), findsOneWidget);

    // Verify back button (SvgPicture)
    expect(find.byType(SvgPicture), findsAtLeastNWidgets(2)); // Back and Scan icon

    // Verify control buttons
    expect(find.byIcon(Icons.image_outlined), findsOneWidget);
    expect(find.byIcon(Icons.flash_off), findsOneWidget);
  });
}
