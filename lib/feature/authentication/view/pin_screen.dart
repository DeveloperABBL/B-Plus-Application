import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/core/widgets/top_back_button.dart';
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
      body: Stack(
        children: [
          const TopBackButton(color: Color(0xFF2FBA38)),
          Column(
            children: [
              const SizedBox(
                height: 120,
              ), // Compensation for moving TopBackButton out
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Assets.png.setPin.image(),
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
                    margin: const EdgeInsets.symmetric(horizontal: 13),
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isFilled ? AppColors.primary : AppColors.white,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              _buildKeypad(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeypad() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          _buildKeyRow(['1', '2', '3']),
          const SizedBox(height: 20),
          _buildKeyRow(['4', '5', '6']),
          const SizedBox(height: 20),
          _buildKeyRow(['7', '8', '9']),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 80),
              _buildKeyButton('0'),
              _BackspaceButton(onPressed: _onBackspace),
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
    return _PinKeyButton(text: key, onTap: _onKeyTap);
  }
}

class _PinKeyButton extends StatefulWidget {
  final String text;
  final Function(String) onTap;

  const _PinKeyButton({required this.text, required this.onTap});

  @override
  State<_PinKeyButton> createState() => _PinKeyButtonState();
}

class _PinKeyButtonState extends State<_PinKeyButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap(widget.text);
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          color: _isPressed ? AppColors.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          widget.text,
          style: AppTextStyles.headlineSmall.copyWith(
            color: _isPressed ? AppColors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _BackspaceButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _BackspaceButton({required this.onPressed});

  @override
  State<_BackspaceButton> createState() => _BackspaceButtonState();
}

class _BackspaceButtonState extends State<_BackspaceButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          color: _isPressed ? AppColors.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          Assets.svg.icBackspace,
          colorFilter: ColorFilter.mode(
            _isPressed ? AppColors.white : AppColors.textPrimary,
            BlendMode.srcIn,
          ),
          width: 28,
          height: 28,
        ),
      ),
    );
  }
}
