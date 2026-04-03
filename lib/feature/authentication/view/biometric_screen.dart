import 'package:brownyplus/core/providers/customer_provider.dart';
import 'package:brownyplus/core/widgets/top_back_button.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  static final String pagePath = '/biometric_page';
  static final String pageName = 'BiometricPage';

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  final LocalAuthentication _auth = LocalAuthentication();

  bool _isBusy = false;

  Future<void> _enableBiometric() async {
    if (_isBusy) return;

    setState(() => _isBusy = true);

    try {
      final enabled = await _setBiometricEnabled(true);

      if (!mounted) return;

      if (!enabled) {
        _showSnackBar('ไม่สามารถเปิดใช้งาน Biometric ได้');
        return;
      }

      final authMessage = await _authenticateWithBiometric();

      if (!mounted) return;

      if (authMessage == null) {
        context.go('/home_page');
        return;
      }

      AuthSession.biometricEnabled = false;
      _showSnackBar(authMessage);
    } catch (_) {
      if (!mounted) return;
      AuthSession.biometricEnabled = false;
      _showSnackBar('เกิดข้อผิดพลาด กรุณาลองอีกครั้ง');
    } finally {
      if (mounted) {
        setState(() => _isBusy = false);
      }
    }
  }

  Future<bool> _setBiometricEnabled(bool enabled) async {
    AuthSession.biometricEnabled = enabled;
    return true;
  }

  Future<String?> _authenticateWithBiometric() async {
    try {
      final canCheckBiometrics = await _auth.canCheckBiometrics;
      final availableBiometrics = await _auth.getAvailableBiometrics();

      if (!canCheckBiometrics || availableBiometrics.isEmpty) {
        return 'อุปกรณ์ไม่รองรับ Biometric หรือยังไม่ได้ตั้งค่าในเครื่อง';
      }

      final authenticated = await _auth.authenticate(
        localizedReason: 'กรุณายืนยันตัวตนเพื่อเปิดใช้งาน Biometric',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
        ),
      );

      return authenticated ? null : 'การยืนยันตัวตนล้มเหลว';
    } on PlatformException catch (error) {
      switch (error.code) {
        case 'NotAvailable':
        case 'notAvailable':
          return 'อุปกรณ์ไม่รองรับ Biometric';
        case 'NotEnrolled':
        case 'notEnrolled':
          return 'ไม่มี Biometric ที่ลงทะเบียนไว้ กรุณาตั้งค่าในเครื่อง';
        case 'LockedOut':
        case 'lockedOut':
          return 'ลองผิดหลายครั้งเกินไป กรุณารอสักครู่';
        case 'PermanentlyLockedOut':
        case 'permanentlyLockedOut':
          return 'Biometric ถูกล็อกถาวร กรุณาใช้ PIN';
        case 'UserCanceled':
        case 'userCanceled':
        case 'Canceled':
        case 'SystemCanceled':
        case 'systemCanceled':
          return 'คุณยกเลิกการยืนยันตัวตน';
        case 'auth_in_progress':
          return 'กำลังมีการยืนยันตัวตนอยู่ กรุณาลองใหม่อีกครั้ง';
        default:
          return error.message ?? 'การยืนยันตัวตนล้มเหลว';
      }
    } catch (_) {
      return 'การยืนยันตัวตนล้มเหลว';
    }
  }

  void _skipBiometric() {
    context.go('/home_page');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Stack(
            children: [
              const TopBackButton(color: AppColors.primary),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Spacer(),
                    const Icon(
                      Icons.fingerprint_rounded,
                      size: 60,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'เปิดการใช้งานด้วย Biometric',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isBusy ? null : _enableBiometric,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: _isBusy
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : Text(
                                'ยืนยัน',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: _isBusy ? null : _skipBiometric,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'ข้าม',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
