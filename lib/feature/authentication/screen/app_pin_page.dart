import 'package:brownyplus/core/env/app_environment.dart';
import 'package:brownyplus/feature/authentication/repository/pin_biometric_repository.dart';
import 'package:brownyplus/feature/authentication/view/biometric_screen.dart';
import 'package:brownyplus/feature/authentication/viewmodel/pin_biometric_viewmodel.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// หน้ากรอก PIN 6 หลัก (โหมด verify เท่านั้น)
///
/// พฤติกรรม:
/// - ตรวจสอบและ sync PIN จาก server ลง local ก่อน
/// - ให้ผู้ใช้กรอก PIN เพื่อ verify กับ API
/// - เมื่อ verify สำเร็จให้ไป flow biometric ต่อ
/// - ไม่มีส่วน create/set pin
class CreateAppPinPage extends StatelessWidget {
  const CreateAppPinPage({
    super.key,
    required this.process,
    this.implementBackButton = true,
  });

  final bool implementBackButton;
  final PinBiometricPross process;

  static const pagePath = '/pin_page';
  static const pageName = 'PinPage';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: ChangeNotifierProvider(
        create: (context) => PinBiometricViewModel(
          repository: PinBioMetricRepository(),
          process: process,
        ),
        child: _CreateAppPinContent(
          process: process,
          implementBackButton: implementBackButton,
        ),
      ),
    );
  }
}

class _CreateAppPinContent extends StatefulWidget {
  const _CreateAppPinContent({
    required this.process,
    required this.implementBackButton,
  });

  final bool implementBackButton;
  final PinBiometricPross process;

  @override
  State<_CreateAppPinContent> createState() => _CreateAppPinContentState();
}

class _CreateAppPinContentState extends State<_CreateAppPinContent> {
  late final PinBiometricViewModel _viewModel;
  bool _isCheckingExistingPin = true;
  bool _hasServerPin = false;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<PinBiometricViewModel>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkExistingPinFromServer();
    });
  }

  /// ตรวจสอบว่า server มี PIN หรือไม่
  /// - ถ้ามี: sync ลง local และแสดงหน้ากรอก PIN
  /// - ถ้าไม่มี: แจ้งว่าไม่พบ PIN (เพราะ flow นี้ไม่รองรับ set pin)
  Future<void> _checkExistingPinFromServer() async {
    try {
      final hasPin = await _viewModel.getPinFromServer(
        appKey: context.read<AppEvnironment>().laravelAppKey,
      );

      debugPrint('[PIN] checkExistingPinFromServer: hasPin=$hasPin');
      if (!mounted) return;
      setState(() {
        _hasServerPin = hasPin;
        _isCheckingExistingPin = false;
      });
    } catch (_) {
      debugPrint('[PIN] checkExistingPinFromServer: exception');
      if (!mounted) return;
      setState(() {
        _hasServerPin = false;
        _isCheckingExistingPin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingExistingPin) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (!_hasServerPin) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            'ไม่พบ PIN สำหรับบัญชีนี้',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.error,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
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
                if (widget.implementBackButton) _buildHeader(context),
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
                        _buildTitle(),
                        SizedBox(height: AppDims.size_10.h),
                        _buildErrorSlot(),
                        SizedBox(height: AppDims.size_12.h),
                        _buildPinIndicators(),
                        SizedBox(height: AppDims.size_24.h),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Consumer<PinBiometricViewModel>(
                              builder: (context, viewModel, _) {
                                if (viewModel.isLoading) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      top: AppDims.size_24.h,
                                    ),
                                    child: const CircularProgressIndicator(
                                      color: AppColors.primary,
                                    ),
                                  );
                                }
                                return _buildNumpad(viewModel);
                              },
                            ),
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDims.size_16.w,
        vertical: AppDims.size_8.h,
      ),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () {
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

  Widget _buildLogo() {
    return Center(
      child: Assets.png.setPin.image(width: 90.w, height: 90.h),
    );
  }

  Widget _buildTitle() {
    return Text(
      _getTitleText(),
      style: AppTextStyles.headlineMedium.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  String _getTitleText() {
    return 'กรอกรหัส PIN';
  }

  Widget _buildErrorSlot() {
    return Consumer<PinBiometricViewModel>(
      builder: (context, viewModel, _) {
        final msg = viewModel.errorMessage;
        return SizedBox(
          height: AppDims.size_24.h,
          child: msg != null && msg.isNotEmpty
              ? Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildPinIndicators() {
    return Consumer<PinBiometricViewModel>(
      builder: (context, viewModel, _) {
        final currentPin = viewModel.pin;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(PinBiometricViewModel.pinLength, (index) {
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
      },
    );
  }

  static const double _numpadButtonSize = 60;

  Widget _buildNumpad(PinBiometricViewModel viewModel) {
    return SizedBox(
      width: 260.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNumpadRow(viewModel, const ['1', '2', '3']),
          SizedBox(height: AppDims.size_12.h),
          _buildNumpadRow(viewModel, const ['4', '5', '6']),
          SizedBox(height: AppDims.size_12.h),
          _buildNumpadRow(viewModel, const ['7', '8', '9']),
          SizedBox(height: AppDims.size_12.h),
          _buildLastNumpadRow(viewModel),
        ],
      ),
    );
  }

  Widget _buildNumpadRow(PinBiometricViewModel viewModel, List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: digits.map((d) {
        return _buildNumpadButton(
          viewModel: viewModel,
          onTap: () => viewModel.addDigit(d, _onVerifiedPin),
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

  Widget _buildLastNumpadRow(PinBiometricViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: _numpadButtonSize.w, height: _numpadButtonSize.w),
        _buildNumpadButton(
          viewModel: viewModel,
          onTap: () => viewModel.addDigit('0', _onVerifiedPin),
          child: Text(
            '0',
            style: AppTextNumberStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        _buildNumpadButton(
          viewModel: viewModel,
          onTap: viewModel.removeDigit,
          child: SvgPicture.asset(
            Assets.svg.icBackspace,
            width: 22.w,
            height: 22.w,
          ),
        ),
      ],
    );
  }

  void _onVerifiedPin() {
    _viewModel.isBiometricAvailable().then((available) {
      if (!mounted) return;

      if (available) {
        context.pushReplacementNamed(BiometricScreen.pageName);
      } else {
        context.go('/home_page');
      }
    });
  }

  Widget _buildNumpadButton({
    required PinBiometricViewModel viewModel,
    required VoidCallback onTap,
    required Widget child,
  }) {
    return Center(
      child: InkWell(
        onTap: viewModel.isLoading ? null : onTap,
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
}
