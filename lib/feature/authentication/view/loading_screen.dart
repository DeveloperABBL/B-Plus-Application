import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:brownyplus/feature/authentication/view/login_screen.dart';
import 'package:brownyplus/core/widgets/browny_logo.dart';
import 'package:brownyplus/core/widgets/primary_button.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  void _goToLogin(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF38C86B), Color(0xFF15B34A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: Column(
                children: const [
                  SizedBox(height: 80),
                  Center(child: BrownyLogo()),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/svg/ic_onboard_first.svg',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "พื้นที่สำหรับทีมงาน Browny เท่านั้น",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF593817),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "แอพพลิเคชันนี้ สำหรับการใช้งานของพนักงานเท่านั้น",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF593817),
                      ),
                    ),
                    const SizedBox(height: 200),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 45,
                        height: 45,
                        child: PrimaryButton(
                          label: '',
                          iconOnly: true,
                          iconPath: 'assets/svg/ic_forward.svg',
                          onPressed: () => _goToLogin(context),
                          alignment: Alignment.center,
                          shape: const CircleBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
