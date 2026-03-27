import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';
import 'package:brownyplus/feature/authentication/view/forgot_password_screen.dart';
import 'package:brownyplus/core/widgets/top_back_button.dart';
import 'package:brownyplus/core/widgets/keyboard_dismissible.dart';
import 'package:brownyplus/core/providers/customer_provider.dart';
import 'package:brownyplus/core/data/remote/app_client.dart';
import 'package:brownyplus/core/env/app_environment.dart';
import 'package:brownyplus/core/widgets/app_notification.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const pagePath = '/login_page';
  static const pageName = 'LoginPage';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;
  bool _isLoading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
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
            // โลโก้ด้านบน
            _buildLogo(context),

            // การ์ดส่วนล่าง
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                padding: EdgeInsets.fromLTRB(
                  24,
                  24,
                  24,
                  MediaQuery.of(context).viewInsets.bottom + 30,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      AppDims.vericalPadding_4,
                      Text(
                        "เข้าสู่บัญชีของคุณ",
                        style: AppTextStyles.titleLarge.copyWith(
                          fontSize: 24.sp,
                        ),
                      ),
                      AppDims.vericalPadding_4,
                      Text(
                        "กรุณาเข้าสู่ระบบ ด้วยบัญชีที่ได้รับอนุญาต",
                        style: AppTextStyles.labelSmallSlim.copyWith(
                          color: const Color(0xFF616161),
                          fontSize: 14.sp,
                        ),
                      ),
                      const SizedBox(height: 30),
                      textFormFieldEmailOrPhone(),
                      const SizedBox(height: 16),
                      textFormFieldPassword(),
                      const SizedBox(height: 100),
                      buildPrimaryButton(),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            context.pushNamed(ForgotPasswordScreen.pageName);
                          },
                          child: Text(
                            'ลืมรหัสผ่าน',
                            style: AppTextStyles.labelSmallSlim.copyWith(
                              color: const Color(0xFF15B34A),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 100.h),
          Assets.images.brownyPlusLogo.image(width: 200.w, height: 200.w),
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

  @protected
  Widget textFormFieldEmailOrPhone() {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        controller: _usernameController,
        onChanged: (value) => setState(() {}),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          hintText: 'อีเมล / เบอร์โทรศัพท์',
          hintStyle: AppTextStyles.labelSmallSlim.copyWith(
            color: const Color(0xFF949494),
            fontSize: 12.sp,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF949494)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF949494)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFF949494)),
          ),
        ),
      ),
    );
  }

  @protected
  Widget textFormFieldPassword() {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        obscureText: _isObscure,
        controller: _passwordController,
        onChanged: (value) => setState(() {}),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          hintText: 'รหัสผ่าน',
          hintStyle: AppTextStyles.labelSmallSlim.copyWith(
            color: const Color(0xFF949494),
            fontSize: 12.sp,
          ),
          suffixIcon: IconButton(
            icon: SvgPicture.asset(
              _isObscure ? Assets.svg.icEyeSlash : Assets.svg.icEye,
              colorFilter: const ColorFilter.mode(
                Color(0xFF949494),
                BlendMode.srcIn,
              ),
            ),
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
              });
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF949494)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF949494)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF949494)),
          ),
        ),
      ),
    );
  }

  Widget buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: AppElevatedButtonStyle.defaultStyle,
        onPressed:
            _isLoading ||
                _usernameController.text.trim().isEmpty ||
                _passwordController.text.isEmpty
            ? null
            : () async {
                final username = _usernameController.text.trim();
                final password = _passwordController.text;

                setState(() => _isLoading = true);
                final auth = AuthApi.fromEnvironment(
                  context.read<AppEvnironment>(),
                );
                final result = await auth.login(
                  username: username,
                  password: password,
                );

                if (!mounted) return;
                setState(() => _isLoading = false);

                if (!result.isSuccess) {
                  AppNotification.show(
                    context,
                    title: 'เข้าสู่ระบบไม่สำเร็จ',
                    message: result.error ?? 'รหัสผ่านของคุณไม่ถูกต้อง',
                    actionLabel: 'ลองอีกครั้ง',
                  );
                  return;
                }

                AuthSession.customerId = result.customerId;
                // pin_screen จะเช็คจาก server ว่าเคยตั้ง PIN ไว้หรือยัง
                context.push('/pin_page');
              },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              SizedBox(
                width: 18.w,
                height: 18.h,
                child: const CircularProgressIndicator(strokeWidth: 2),
              )
            else
              const Text('เข้าสู่ระบบ'),
            const SizedBox(width: 8),
            SvgPicture.asset(Assets.svg.icLogin),
          ],
        ),
      ),
    );
  }
}
