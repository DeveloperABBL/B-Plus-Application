import 'package:flutter/material.dart';
import 'package:brownyplus/feature/authentication/view/login_screen.dart';
import 'package:brownyplus/widgets/browny_logo.dart';
import 'package:brownyplus/widgets/primary_button.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  void _goToLogin(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const LoginScreen(),
      ),
    );
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                const Center(child: BrownyLogo()),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFF15B34A)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'พื้นที่สำหรับทีมงาน Browny เท่านั้น\nแอพพิเศษนี้ สำหรับการใช้งานของพนักงานเท่านั้น',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF424242),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 64,
                    child: PrimaryButton(
                      label: '',
                      iconOnly: true,
                      onPressed: () => _goToLogin(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

