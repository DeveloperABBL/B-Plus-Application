import 'package:flutter/material.dart';
import 'package:brownyplus/core/widgets/browny_logo.dart';
import 'package:brownyplus/core/widgets/primary_button.dart';
import 'package:brownyplus/core/widgets/rounded_text_field.dart';
import 'package:brownyplus/feature/home/view/home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF28C161),
      body: Stack(
        children: [
          Row(
            children: [
              SizedBox(width: 25),
              SizedBox(height: 170),
              SvgPicture.asset('assets/svg/ic_back.svg', width: 20, height: 20),
              const SizedBox(width: 15),
              const Text(
                'ย้อนกลับ',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          // โลโก้ด้านบน
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: const BrownyLogo(),
              ),
            ),
          ),
          // การ์ดส่วนล่าง
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  const Text(
                    "เข้าสู่บัญชีของคุณ",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF593817),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "กรุณาเข้าสู่ระบบ ด้วยบัญชีที่ได้รับอนุญาต",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF593817),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const RoundedTextField(
                    hintText: 'อีเมล / เบอร์โทรศัพท์',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),

                  const RoundedTextField(
                    hintText: 'รหัสผ่าน',
                    obscureText: true,
                  ),
                  const SizedBox(height: 100),

                  PrimaryButton(
                    label: 'เข้าสู่ระบบ',
                    iconPath: 'assets/svg/ic_login.svg',
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => const HomeScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.center,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
