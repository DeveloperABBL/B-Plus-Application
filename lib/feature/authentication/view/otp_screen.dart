import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';
import 'package:brownyplus/feature/authentication/view/reset_password_screen.dart';
import 'package:brownyplus/core/widgets/top_back_button.dart';
import 'package:brownyplus/core/widgets/keyboard_dismissible.dart';
import 'package:brownyplus/core/providers/customer_provider.dart';
import 'package:brownyplus/core/data/remote/app_client.dart';
import 'package:brownyplus/core/env/app_environment.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  static const pagePath = '/otp_page';
  static const pageName = 'OtpPage';

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();

  int _secondsRemaining = 60;
  Timer? _timer;
  bool _isLoading = false;
  String? _errorMessage;
  String _refCode = '';

  @override
  void initState() {
    super.initState();
    _otpFocusNode.addListener(() {
      if (mounted) setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _bootstrap();
    });
  }

  Future<void> _bootstrap() async {
    final username = AuthSession.otpUsername;
    if (username == null || username.isEmpty) {
      setState(() {
        _errorMessage = 'Missing OTP username';
      });
      return;
    }
    await _requestOtpAndStartTimer();
  }

  void _startTimer({required int seconds}) {
    _secondsRemaining = seconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _requestOtpAndStartTimer() async {
    final username = AuthSession.otpUsername;
    if (username == null || username.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final auth = AuthApi.fromEnvironment(context.read<AppEvnironment>());
    final result = await auth.requestOtp(username: username);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (!result.isSuccess) {
      setState(() {
        _errorMessage = result.error ?? 'Request OTP failed';
        _secondsRemaining = 0;
      });
      return;
    }

    AuthSession.otpRefCode = result.refCode;
    setState(() {
      _refCode = result.refCode ?? '';
    });

    _startTimer(seconds: result.expiredInSeconds ?? 60);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF28C161),
      resizeToAvoidBottomInset: true,
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
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 40.h),
        child: SingleChildScrollView(
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
                "รหัสอ้างอิง $_refCode",
                style: AppTextStyles.labelSmallSlim.copyWith(
                  color: const Color(0xFF949494),
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 8.h),
              _buildResendCode(),
              if (_errorMessage != null) ...[
                SizedBox(height: 8.h),
                Text(
                  _errorMessage!,
                  style: AppTextStyles.labelSmallSlim.copyWith(
                    color: const Color(0xFFE53935),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpFields() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Hidden TextField overlaying the entire row
        Opacity(
          opacity: 0.0,
          child: TextField(
            controller: _otpController,
            focusNode: _otpFocusNode,
            keyboardType: TextInputType.number,
            maxLength: 4,
            autofocus: true,
            showCursor: false,
            cursorColor: Colors.transparent,
            decoration: const InputDecoration(
              counterText: "",
              border: InputBorder.none,
            ),
            onChanged: (_) {
              setState(() {});
            },
          ),
        ),
        // Visual boxes
        GestureDetector(
          onTap: () => _otpFocusNode.requestFocus(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              final isError =
                  (_errorMessage ?? '').isNotEmpty || _secondsRemaining == 0;
              final isFocused =
                  _otpFocusNode.hasFocus &&
                  (_otpController.text.length == index ||
                      (_otpController.text.length == 4 && index == 3));
              final char = _otpController.text.length > index
                  ? _otpController.text[index]
                  : "";

              return Container(
                width: 70.w,
                height: 70.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isError
                        ? const Color(0xFFE53935)
                        : (isFocused
                              ? const Color(0xFF15B34A)
                              : const Color(0xFFE0E0E0)),
                    width: isFocused ? 2 : 1,
                  ),
                ),
                child: Text(
                  char,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF000000),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton(BuildContext context) {
    bool isComplete = _otpController.text.length == 4;
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
            ? _isLoading
                  ? null
                  : () async {
                      String enteredOtp = _otpController.text;
                      final username = AuthSession.otpUsername;
                      final refCode = AuthSession.otpRefCode;
                      if (username == null ||
                          refCode == null ||
                          refCode.isEmpty) {
                        setState(() => _errorMessage = 'Missing OTP ref_code');
                        return;
                      }

                      setState(() {
                        _isLoading = true;
                        _errorMessage = null;
                      });

                      final auth = AuthApi.fromEnvironment(
                        context.read<AppEvnironment>(),
                      );
                      final result = await auth.verifyOtp(
                        username: username,
                        refCode: refCode,
                        otp: enteredOtp,
                      );

                      if (!mounted) return;
                      setState(() => _isLoading = false);

                      if (!result.isSuccess) {
                        setState(() {
                          _errorMessage = result.error ?? 'OTP invalid';
                        });
                        return;
                      }

                      AuthSession.customerId = result.customerId;
                      context.pushNamed(ResetPasswordScreen.pageName);
                    }
            : null,
        child: _isLoading ? const Text('กำลังตรวจสอบ...') : const Text('ถัดไป'),
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
        onPressed: _isLoading ? null : _requestOtpAndStartTimer,
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
