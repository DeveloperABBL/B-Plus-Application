import 'package:brownyplus/core/data/remote/auth_api.dart';
import 'package:brownyplus/core/env/app_environment.dart';
import 'package:brownyplus/core/providers/customer_provider.dart';
import 'package:brownyplus/core/widgets/app_notification.dart';
import 'package:brownyplus/core/widgets/keyboard_dismissible.dart';
import 'package:brownyplus/core/widgets/top_back_button.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  static const pagePath = '/reset_password_page';
  static const pageName = 'ResetPasswordPage';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  bool _isMinLength = false;
  bool _isMatch = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validate);
    _confirmPasswordController.addListener(_validate);
  }

  void _validate() {
    setState(() {
      _isMinLength = _passwordController.text.length >= 8;
      _isMatch =
          _passwordController.text.isNotEmpty &&
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF28C161),
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
          padding: EdgeInsets.only(top: 80.h),
          child: Assets.images.brownyPlusLogo.image(
            width: 120.w,
            height: 120.w,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            Text(
              "กำหนดรหัสผ่านใหม่",
              style: AppTextStyles.titleLarge.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              "แค่ตั้งรหัสผ่านใหม่ก็พร้อมไปต่อ! มาเริ่มกันเลย",
              style: AppTextStyles.labelSmallSlim.copyWith(
                color: const Color(0xFF616161),
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 30.h),
            _buildPasswordField(
              controller: _passwordController,
              hintText: 'สร้างรหัสผ่านใหม่',
              isObscure: _isPasswordObscure,
              onToggle: () =>
                  setState(() => _isPasswordObscure = !_isPasswordObscure),
            ),
            SizedBox(height: 16.h),
            _buildPasswordField(
              controller: _confirmPasswordController,
              hintText: 'ยืนยันรหัสผ่านใหม่',
              isObscure: _isConfirmPasswordObscure,
              onToggle: () => setState(
                () => _isConfirmPasswordObscure = !_isConfirmPasswordObscure,
              ),
            ),
            SizedBox(height: 16.h),
            _buildValidationItem("รหัสผ่านใหม่ตรงกัน", _isMatch),
            SizedBox(height: 8.h),
            _buildValidationItem("8 ตัวอักษรขึ้นไป", _isMinLength),
            SizedBox(height: 32.h),
            _buildConfirmButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isObscure,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        hintText: hintText,
        hintStyle: AppTextStyles.labelSmallSlim.copyWith(
          color: const Color(0xFF949494),
          fontSize: 14.sp,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isObscure ? Icons.visibility_off : Icons.visibility,
            color: const Color(0xFF949494),
            size: 20.w,
          ),
          onPressed: onToggle,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: Color(0xFF15B34A)),
        ),
      ),
    );
  }

  Widget _buildValidationItem(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          color: isValid ? const Color(0xFF15B34A) : const Color(0xFFE53935),
          size: 16.w,
        ),
        SizedBox(width: 8.w),
        Text(
          text,
          style: AppTextStyles.labelSmallSlim.copyWith(
            color: isValid ? const Color(0xFF15B34A) : const Color(0xFFE53935),
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    bool canConfirm = _isMatch && _isMinLength;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: AppElevatedButtonStyle.defaultStyle.copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (canConfirm) return const Color(0xFF15B34A);
            return const Color(0xFFE0E0E0);
          }),
        ),
        onPressed: (!canConfirm || _isLoading)
            ? null
            : () async {
                final customerId = AuthSession.customerId;
                if (customerId == null || customerId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Missing customer id')),
                  );
                  return;
                }

                final newPassword = _passwordController.text;
                if (newPassword.isEmpty) return;

                setState(() {
                  _isLoading = true;
                });

                final auth = AuthApi.fromEnvironment(
                  context.read<AppEvnironment>(),
                );
                final ok = await auth.updatePassword(
                  customerId: customerId,
                  newPassword: newPassword,
                );

                if (!mounted) return;
                setState(() {
                  _isLoading = false;
                });

                if (!ok) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('อัปเดตรหัสผ่านไม่สำเร็จ')),
                  );
                  return;
                }

                await AppNotification.show(
                  context,
                  title: 'สำเร็จ',
                  message: 'รีเซตรหัสผ่านเรียบร้อยแล้ว',
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: AppColors.white,
                    size: 48,
                  ),
                  actionLabel: 'ตกลง',
                );
                if (!mounted) return;
                context.go('/login_page');
              },
        child: _isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('ยืนยันรหัสผ่าน'),
      ),
    );
  }
}
