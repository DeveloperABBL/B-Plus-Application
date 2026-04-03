import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';
import 'package:brownyplus/feature/authentication/view/otp_screen.dart';
import 'package:brownyplus/core/widgets/top_back_button.dart';
import 'package:brownyplus/core/widgets/keyboard_dismissible.dart';
import 'package:brownyplus/core/providers/customer_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  static const pagePath = '/forgot_password_page';
  static const pageName = 'ForgotPasswordPage';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF28C161),
      resizeToAvoidBottomInset: false,
      body: KeyboardDismissible(
        child: Stack(
          children: [
            _buildGradientBackground(),
            const TopBackButton(),
            _buildLogo(),
            _buildCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: Opacity(
        opacity: 0.07,
        child: Assets.png.patternBrowny.image(
          width: 1.sw,
          height: 0.7.sh,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: 30.h),
          child: Assets.images.brownyPlusLogo.image(
            width: 100.w,
            height: 100.w,
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        padding: EdgeInsets.fromLTRB(
          24.w,
          24.h,
          24.w,
          MediaQuery.of(context).viewInsets.bottom + 40.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              Text(
                "ลืมรหัสผ่าน",
                style: AppTextStyles.titleLarge.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                "กรุณากรอกเบอร์โทรศัพท์ที่ลงทะเบียนไว้",
                style: AppTextStyles.labelSmallSlim.copyWith(
                  color: const Color(0xFF616161),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 20.h),
              _buildPhoneField(),
              SizedBox(height: 220.h),
              _buildNextButton(context),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        hintText: 'อีเมล / เบอร์โทรศัพท์',
        hintStyle: AppTextStyles.labelSmallSlim.copyWith(
          color: const Color(0xFF949494),
          fontSize: 14.sp,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF949494)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF15B34A)),
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: AppElevatedButtonStyle.defaultStyle,
        onPressed: () {
          final username = _phoneController.text.trim();
          if (username.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('กรุณากรอกเบอร์โทร/อีเมล')),
            );
            return;
          }
          AuthSession.otpUsername = username;
          context.pushNamed(OtpScreen.pageName);
        },
        child: const Text('ถัดไป'),
      ),
    );
  }
}
