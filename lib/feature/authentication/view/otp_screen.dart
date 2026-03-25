import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';
import 'package:brownyplus/feature/authentication/view/reset_password_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  static const pagePath = '/otp_page';
  static const pageName = 'OtpPage';

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  int _secondsRemaining = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF28C161),
      body: Stack(
        children: [
          _buildGradientBackground(),
          _buildBackButton(context),
          _buildLogo(),
          _buildCard(context),
        ],
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

  Widget _buildBackButton(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => context.pop(),
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(Assets.svg.icBack),
              SizedBox(width: 10.w),
              Text(
                'ย้อนกลับ',
                style: AppTextStyles.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
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
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 40.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ยืนยันรหัสใช้ครั้งเดียว (OTP)",
                style: AppTextStyles.titleLarge.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "กรอกรหัสใช้ครั้งเดียว 4 หลักเพื่อยืนยันบัญชี",
                style: AppTextStyles.labelSmallSlim.copyWith(
                  color: const Color(0xFF616161),
                  fontSize: 14.sp,
                ),
              ),
            ),
            SizedBox(height: 15.h),
            _buildOtpFields(),
            SizedBox(height: 8.h),
            _buildNextButton(context),
            SizedBox(height: 15.h),
            Text(
              "รหัสอ้างอิง AR3WZJ",
              style: AppTextStyles.labelSmallSlim.copyWith(
                color: const Color(0xFF949494),
                fontSize: 12.sp,
              ),
            ),
            SizedBox(height: 8.h),
            _buildResendCode(),
            SizedBox(height: 190.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(4, (index) {
        return SizedBox(
          width: 70.w,
          height: 70.h,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: AppTextStyles.titleLarge.copyWith(
              fontSize: 28.sp,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF000000),
            ),
            maxLength: 1,
            decoration: InputDecoration(
              counterText: "",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Color(0xFF15B34A)),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 3) {
                _focusNodes[index + 1].requestFocus();
              } else if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
            },
          ),
        );
      }),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    bool isComplete = _controllers.every((c) => c.text.isNotEmpty);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: AppElevatedButtonStyle.defaultStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (isComplete) return const Color(0xFF15B34A);
            return const Color(0xFFE0E0E0);
          }),
        ),
        onPressed: isComplete
            ? () {
                context.pushNamed(ResetPasswordScreen.pageName);
              }
            : null,
        child: const Text('ถัดไป'),
      ),
    );
  }

  Widget _buildResendCode() {
    if (_secondsRemaining > 0) {
      return Text(
        "ขอรหัสใหม่ใน $_secondsRemaining วินาที",
        style: AppTextStyles.labelSmallSlim.copyWith(
          color: const Color(0xFF15B34A),
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return TextButton(
        onPressed: () {
          setState(() {
            _secondsRemaining = 60;
            _startTimer();
          });
        },
        child: Text(
          "ขอรหัสผ่านใหม่",
          style: AppTextStyles.labelSmallSlim.copyWith(
            color: const Color(0xFF15B34A),
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }
}
