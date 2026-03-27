import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:brownyplus/core/providers/customer_provider.dart';
import 'package:brownyplus/core/data/remote/app_client.dart';
import 'package:brownyplus/core/env/app_environment.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';
import 'package:provider/provider.dart';

enum _PinMode {
  create,
  verify,
}

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  static const String pagePath = '/pin_page';
  static final String pageName = 'PinPage';

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  late final AuthApi _authApi;

  _PinMode? _mode;
  int _step = 1; // create mode: 1 = pin, 2 = confirm pin

  String _pin = '';
  String _confirmPin = '';

  bool _isCheckingPin = true;
  bool _isLoading = false;
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
    if (!AuthSession.hasCustomerId) {
      setState(() {
        _errorMessage = 'Missing customerId (please login again)';
        _isCheckingPin = false;
      });
      return;
    }

    setState(() {
      _isCheckingPin = true;
      _errorMessage = null;
    });

    final result = await _authApi.getPinFromServer(
      customerId: AuthSession.customerId!,
    );

    if (!mounted) return;
    setState(() {
      _errorMessage = result.error;
      _mode = result.hasPin ? _PinMode.verify : _PinMode.create;
      _step = 1;
      _pin = '';
      _confirmPin = '';
      _isCheckingPin = false;
    });
  }

  String get _currentPin {
    if (_mode == _PinMode.create) {
      return _step == 1 ? _pin : _confirmPin;
    }
    return _pin;
  }

  String _titleText() {
    if (_mode == _PinMode.verify) {
      return 'กรอกรหัส PIN 6 หลัก';
    }
    // create
    return _step == 1 ? 'สร้างรหัส PIN 6 หลัก' : 'ยืนยันรหัส PIN';
  }

  Widget _buildHeader() {
    final bool canGoBack = _mode == _PinMode.create && _step == 2;

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
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_mode == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            _errorMessage ?? 'PIN init failed',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.error,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHeader(),

            SizedBox(height: AppDims.size_32.h),

            // Logo Browny (ด้านบน)
            _buildLogo(),

            SizedBox(height: AppDims.size_24.h),

            // Title
            Text(
              _titleText(),
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),

            // Error message
            if (_errorMessage != null && _errorMessage!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(
                  left: AppDims.size_24.w,
                  right: AppDims.size_24.w,
                  top: AppDims.size_16.h,
                ),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            SizedBox(height: AppDims.size_32.h),

            // PIN indicators
            _buildPinIndicators(),

            const Spacer(),

            if (_isLoading)
              Padding(
                padding: EdgeInsets.only(bottom: AppDims.size_24.h),
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                ),
              )
            else
              _buildNumpad(),

            SizedBox(height: AppDims.size_24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Assets.png.setPin.image(
        width: 90.w,
        height: 90.h,
      ),
    );
  }

  Widget _buildPinIndicators() {
    final currentPin = _currentPin;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        6,
        (index) {
          final isFilled = index < currentPin.length;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            width: 20.w,
            height: 20.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFilled ? AppColors.primary : Colors.transparent,
              border: Border.all(
                color: AppColors.primary,
                width: 2,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNumpad() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDims.size_32.w),
      child: Column(
        children: [
          _buildNumpadRow(['1', '2', '3']),
          SizedBox(height: AppDims.size_16.h),
          _buildNumpadRow(['4', '5', '6']),
          SizedBox(height: AppDims.size_16.h),
          _buildNumpadRow(['7', '8', '9']),
          SizedBox(height: AppDims.size_16.h),
          _buildLastRow(),
        ],
      ),
    );
  }

  Widget _buildLastRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Expanded(child: SizedBox.shrink()),
        Expanded(
          child: _buildNumpadButton(
            onTap: () => _onDigitTap('0'),
            child: Text(
              '0',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Expanded(
          child: _buildNumpadButton(
            onTap: _onBackspace,
            child: SvgPicture.asset(
              Assets.svg.icBackspace,
              width: 20.w,
              height: 20.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumpadRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((d) {
        return Expanded(
          child: _buildNumpadButton(
            onTap: () => _onDigitTap(d),
            child: Text(
              d,
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w400,
              ),
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
    return Center(
      child: InkWell(
        onTap: _isLoading ? null : onTap,
        splashColor: AppColors.checkboxSelectedBg,
        borderRadius: BorderRadius.circular(40.r),
        child: Container(
          width: 80.w,
          height: 80.h,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }

  void _onBackspace() {
    if (_isLoading) return;

    setState(() {
      if (_mode == _PinMode.create) {
        if (_step == 1) {
          if (_pin.isNotEmpty) {
            _pin = _pin.substring(0, _pin.length - 1);
          }
        } else {
          if (_confirmPin.isNotEmpty) {
            _confirmPin = _confirmPin.substring(
              0,
              _confirmPin.length - 1,
            );
          }
        }
      } else {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      }

      _errorMessage = null;
    });
  }

  void _onDigitTap(String digit) {
    if (_isLoading) return;
    if (_mode == _PinMode.create) {
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

      // create step 2: confirm
      if (_confirmPin.length >= 6) return;
      setState(() {
        _confirmPin += digit;
        _errorMessage = null;
      });

      if (_confirmPin.length == 6) {
        Future.delayed(const Duration(milliseconds: 300), () async {
          if (!mounted) return;

          setState(() => _isLoading = true);

          if (_pin != _confirmPin) {
            setState(() {
              _errorMessage = 'PIN ไม่ตรงกัน กรุณาลองใหม่';
              _pin = '';
              _confirmPin = '';
              _step = 1;
              _isLoading = false;
            });
            return;
          }

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

          context.push('/biometric_page');
        });
      }
    } else {
      // verify mode
      if (_pin.length >= 6) return;
      setState(() {
        _pin += digit;
        _errorMessage = null;
      });

      if (_pin.length == 6) {
        Future.delayed(const Duration(milliseconds: 200), () async {
          setState(() => _isLoading = true);

          final ok = await _authApi.verifyPin(
            customerId: AuthSession.customerId!,
            pin: _pin,
          );

          if (!mounted) return;
          setState(() => _isLoading = false);

          if (!ok) {
            setState(() {
              _errorMessage = 'PIN ไม่ถูกต้อง กรุณาลองอีกครั้ง';
              _pin = '';
            });
            return;
          }

          context.go('/home_page');
        });
      }
    }
  }
}

