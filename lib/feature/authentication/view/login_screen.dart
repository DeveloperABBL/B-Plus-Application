import 'package:flutter/material.dart';
import 'package:brownyplus/widgets/browny_logo.dart';
import 'package:brownyplus/widgets/primary_button.dart';
import 'package:brownyplus/widgets/rounded_text_field.dart';
import 'package:brownyplus/feature/home/view/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF28C161),
      body: SafeArea(
        child: Stack(
          children: [
            // โลโก้ด้านบน
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 32),
                child: const BrownyLogo(),
              ),
            ),
            // การ์ดส่วนล่าง
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'ย้อนกลับ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'เข้าสู่บัญชีของคุณ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'กรุณากรอกข้อมูลให้ครบถ้วน เพื่อเข้าสู่พื้นที่ใช้งานของคุณ',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF757575),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'อีเมล / เบอร์โทรศัพท์',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const RoundedTextField(
                      hintText: 'กรอกอีเมล หรือเบอร์โทรศัพท์',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'รหัสผ่าน',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const RoundedTextField(
                      hintText: 'กรอกรหัสผ่าน',
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'ลืมรหัสผ่าน',
                          style: TextStyle(
                            color: Color(0xFF15B34A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    PrimaryButton(
                      label: 'เข้าสู่ระบบ',
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) => const HomeScreen(),
                          ),
                        );
                      },
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

