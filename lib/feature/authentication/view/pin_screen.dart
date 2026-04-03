import 'package:brownyplus/feature/authentication/screen/app_pin_page.dart';
import 'package:brownyplus/feature/authentication/viewmodel/pin_biometric_viewmodel.dart';
import 'package:flutter/material.dart';

@Deprecated('Use CreateAppPinPage instead')
class PinScreen extends StatelessWidget {
  const PinScreen({super.key});

  static const String pagePath = CreateAppPinPage.pagePath;
  static const String pageName = CreateAppPinPage.pageName;

  @override
  Widget build(BuildContext context) {
    return const CreateAppPinPage(process: PinBiometricPross.verifyByPin);
  }
}
/*
import 'package:brownyplus/feature/authentication/screen/app_pin_page.dart';
import 'package:brownyplus/feature/authentication/viewmodel/pin_biometric_viewmodel.dart';
import 'package:flutter/material.dart';

@Deprecated('Use CreateAppPinPage instead')
class PinScreen extends StatelessWidget {
  const PinScreen({super.key});

  static const String pagePath = CreateAppPinPage.pagePath;
  static const String pageName = CreateAppPinPage.pageName;

  @override
  Widget build(BuildContext context) {
    return const CreateAppPinPage(process: PinBiometricPross.create);
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:brownyplus/core/providers/customer_provider.dart';
import 'package:brownyplus/core/data/remote/auth_api.dart';
import 'package:brownyplus/core/env/app_environment.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';
import 'package:provider/provider.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  static const String pagePath = '/pin_page';
  static final String pageName = 'PinPage';

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  late final AuthApi _authApi;

  int _step = 1; // 1 = pin, 2 = confirm pin

  String _pin = '';
  String _confirmPin = '';

  bool _hasExistingPin = false;
  bool _isCheckingPin = true;
  bool _isLoading = false;
  bool _hasBootstrapError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _authApi = AuthApi.fromEnvironment(context.read<AppEvnironment>());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _bootstrap();
    });
  }

  Future<void> _bootstrap() async {
    // ตรวจสอบสถานะเริ่มต้นของหน้า และเช็กว่าผู้ใช้เคยตั้ง PIN ไว้แล้วหรือยัง
    if (!AuthSession.hasCustomerId) {
      setState(() {
        _hasBootstrapError = true;
        _errorMessage = 'Missing customerId (please login again)';
        _isCheckingPin = false;
      });
      return;
    }

    setState(() {
      _isCheckingPin = true;
      _hasBootstrapError = false;
      _errorMessage = null;
    });

    final result = await _authApi.getPinFromServer(
      customerId: AuthSession.customerId!,
    );

    if (!mounted) return;

    if (result.hasPin) {
      setState(() {
        _hasExistingPin = true;
        _hasBootstrapError = false;
        _errorMessage = null;
        _step = 1;
        _pin = '';
        _confirmPin = '';
        _isCheckingPin = false;
      });
      return;
    }

    setState(() {
      _hasExistingPin = false;
      _hasBootstrapError = result.error != null && result.error!.isNotEmpty;
      _errorMessage = result.error;
      _step = 1;
      _pin = '';
      _confirmPin = '';
      _isCheckingPin = false;
    });
  }

  String get _currentPin => _step == 1 ? _pin : _confirmPin;

  // คืนค่าข้อความหัวข้อให้ตรงกับขั้นตอนปัจจุบันของการตั้ง PIN
  String _titleText() {
    if (_hasExistingPin) return 'กรอกรหัส PIN';
    return _step == 1 ? 'สร้างรหัส PIN 6 หลัก' : 'ยืนยันรหัส PIN';
  }

  // สร้างส่วนหัวของหน้า พร้อมปุ่มย้อนกลับหรือย้อนกลับไปขั้นก่อนหน้า
  Widget _buildHeader() {
    final bool canGoBack = !_hasExistingPin && _step == 2;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDims.size_16.w,
        vertical: AppDims.size_8.h,
      ),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              if (canGoBack) {
                setState(() {
                  _step = 1;
                  _confirmPin = '';
                  _errorMessage = null;
                });
                return;
              }
              if (context.canPop()) {
                context.pop();
              }
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.primary,
              size: 24.sp,
            ),
            label: Text(
              'ย้อนกลับ',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(50.w, 40.h),
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero,
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingPin) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_hasBootstrapError) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            _errorMessage ?? 'PIN init failed',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: AppDims.size_24.w,
                      right: AppDims.size_24.w,
                      top: AppDims.size_8.h,
                      bottom: AppDims.size_12.h,
                    ),
                    child: Column(
                      children: [
                        _buildLogo(),
                        SizedBox(height: AppDims.size_24.h),
                        Text(
                          _titleText(),
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: AppDims.size_10.h),
                        SizedBox(
                          height: AppDims.size_24.h,
                          child:
                              _errorMessage != null && _errorMessage!.isNotEmpty
                              ? Text(
                                  _errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : null,
                        ),
                        SizedBox(height: AppDims.size_12.h),
                        _buildPinIndicators(),
                        SizedBox(height: AppDims.size_24.h),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: _isLoading
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      top: AppDims.size_24.h,
                                    ),
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                    ),
                                  )
                                : _buildNumpad(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // แสดงโลโก้ประกอบบนหน้าตั้งค่า PIN
  Widget _buildLogo() {
    return Center(
      child: Assets.png.setPin.image(width: 90.w, height: 90.h),
    );
  }

  // แสดงจุดสถานะจำนวน 6 หลักตามจำนวนตัวเลขที่ผู้ใช้กรอก
  Widget _buildPinIndicators() {
    final currentPin = _currentPin;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        final isFilled = index < currentPin.length;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          width: 18.w,
          height: 18.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? AppColors.primary : Colors.transparent,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
        );
      }),
    );
  }

  // สร้างชุดปุ่มตัวเลขสำหรับกรอก PIN
  Widget _buildNumpad() {
    return SizedBox(
      width: 260.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNumpadRow(['1', '2', '3']),
          SizedBox(height: AppDims.size_12.h),
          _buildNumpadRow(['4', '5', '6']),
          SizedBox(height: AppDims.size_12.h),
          _buildNumpadRow(['7', '8', '9']),
          SizedBox(height: AppDims.size_12.h),
          _buildLastRow(),
        ],
      ),
    );
  }

  // สร้างแถวสุดท้ายของแป้นตัวเลข โดยมีเลข 0 และปุ่มลบย้อนหลัง
  Widget _buildLastRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: _numpadButtonSize.w, height: _numpadButtonSize.w),
        _buildNumpadButton(
          onTap: () => _onDigitTap('0'),
          child: Text(
            '0',
            style: AppTextNumberStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _buildNumpadButton(
          onTap: _onBackspace,
          child: SvgPicture.asset(
            Assets.svg.icBackspace,
            width: 22.w,
            height: 22.w,
          ),
        ),
      ],
    );
  }

  static const double _numpadButtonSize = 60;

  // สร้างแถวของปุ่มตัวเลขจากรายการตัวเลขที่ส่งเข้ามา
  Widget _buildNumpadRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: digits.map((d) {
        return _buildNumpadButton(
          onTap: () => _onDigitTap(d),
          child: Text(
            d,
            style: AppTextNumberStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNumpadButton({
    required VoidCallback onTap,
    required Widget child,
  }) {
    // สร้างปุ่มกดของแป้น PIN และปิดการกดระหว่างกำลังบันทึกข้อมูล
    return Center(
      child: InkWell(
        onTap: _isLoading ? null : onTap,
        splashColor: AppColors.checkboxSelectedBg,
        borderRadius: BorderRadius.circular((_numpadButtonSize / 2).r),
        child: Container(
          width: _numpadButtonSize.w,
          height: _numpadButtonSize.w,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Center(child: child),
        ),
      ),
    );
  }

  // ลบตัวเลขล่าสุดของขั้นตอนปัจจุบันเมื่อผู้ใช้กดปุ่ม backspace
  void _onBackspace() {
    if (_isLoading) return;

    setState(() {
      if (_step == 1) {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      } else {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        }
      }

      _errorMessage = null;
    });
  }

  // จัดการการกดตัวเลข, สลับไปขั้นยืนยัน PIN และบันทึก PIN เมื่อข้อมูลครบ
  void _onDigitTap(String digit) {
    if (_isLoading) return;
    if (_hasExistingPin) {
      if (_pin.length >= 6) return;

      setState(() {
        _pin += digit;
        _errorMessage = null;
      });

      if (_pin.length == 6) {
        Future.delayed(const Duration(milliseconds: 300), () async {
          if (!mounted) return;

          setState(() => _isLoading = true);

          final ok = await _authApi.verifyPin(
            customerId: AuthSession.customerId!,
            pin: _pin,
          );

          if (!mounted) return;
          setState(() => _isLoading = false);

          if (!ok) {
            setState(() {
              _errorMessage = 'PIN ไม่ถูกต้อง กรุณาลองใหม่';
              _pin = '';
            });
            return;
          }

          setState(() {
            _pin = '';
            _errorMessage = null;
          });

          context.push('/biometric_page');
        });
      }

      return;
    }

    if (_step == 1) {
      if (_pin.length >= 6) return;
      setState(() {
        _pin += digit;
        _errorMessage = null;
      });

      if (_pin.length == 6) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          setState(() {
            _step = 2;
            _confirmPin = '';
            _errorMessage = null;
          });
        });
      }

      return;
    }

    if (_confirmPin.length >= 6) return;
    setState(() {
      _confirmPin += digit;
      _errorMessage = null;
    });

    if (_confirmPin.length == 6) {
      Future.delayed(const Duration(milliseconds: 300), () async {
        if (!mounted) return;

        if (_pin != _confirmPin) {
          setState(() {
            _errorMessage = 'PIN ไม่ตรงกัน กรุณาลองใหม่';
            _pin = '';
            _confirmPin = '';
            _step = 1;
          });
          return;
        }

        setState(() => _isLoading = true);

        final ok = await _authApi.setPin(
          customerId: AuthSession.customerId!,
          pin: _pin,
        );

        if (!mounted) return;
        setState(() => _isLoading = false);

        if (!ok) {
          setState(() {
            _errorMessage = 'ไม่สามารถบันทึก PIN ได้';
            _pin = '';
            _confirmPin = '';
            _step = 1;
          });
          return;
        }

        setState(() {
          _pin = '';
          _confirmPin = '';
          _step = 1;
          _errorMessage = null;
        });

        context.push('/biometric_page');
      });
    }
  }
}
*/
