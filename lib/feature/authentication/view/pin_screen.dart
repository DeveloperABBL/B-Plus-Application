import 'package:flutter/material.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:go_router/go_router.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  static const String pagePath = '/pin_page';
  static final String pageName = 'PinPage';

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String _pin = "";

  void _onKeyTap(String key) {
    if (_pin.length < 6) {
      setState(() {
        _pin += key;
      });
    }
    if (_pin.length == 6) {
      // Navigate to Biometric screen after a short delay
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          context.push('/biometric_page');
        }
      });
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'ย้อนกลับ',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary),
        ),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Assets.png.b.image(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'สร้างรหัส PIN 6 หลัก',
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              bool isFilled = index < _pin.length;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFilled ? AppColors.primary : AppColors.white,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
              );
            }),
          ),
          const Spacer(),
          _buildKeypad(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          _buildKeyRow(['1', '2', '3']),
          const SizedBox(height: 24),
          _buildKeyRow(['4', '5', '6']),
          const SizedBox(height: 24),
          _buildKeyRow(['7', '8', '9']),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 60),
              _buildKeyButton('0'),
              SizedBox(
                width: 60,
                child: IconButton(
                  onPressed: _onBackspace,
                  icon: const Icon(
                    Icons.backspace_outlined,
                    color: AppColors.textPrimary,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: keys.map((key) => _buildKeyButton(key)).toList(),
    );
  }

  Widget _buildKeyButton(String key) {
    return InkWell(
      onTap: () => _onKeyTap(key),
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 60,
        height: 60,
        alignment: Alignment.center,
        child: Text(
          key,
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
