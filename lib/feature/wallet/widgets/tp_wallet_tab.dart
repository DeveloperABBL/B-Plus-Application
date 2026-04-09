import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TpWalletTab extends StatelessWidget {
  final bool balanceVisible;
  final VoidCallback onToggleBalance;
  final TextEditingController amountController;

  const TpWalletTab({
    super.key,
    required this.balanceVisible,
    required this.onToggleBalance,
    required this.amountController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.translucent,
      child: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(
                left: AppDims.size_16,
                right: AppDims.size_16,
                top: AppDims.size_8,
              ),
              child: _BalanceCard(
                balanceVisible: balanceVisible,
                onToggleBalance: onToggleBalance,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: AppDims.size_16)),
          SliverFillRemaining(
            hasScrollBody: false,
            child: _TopUpCard(amountController: amountController),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Balance card
// ─────────────────────────────────────────────
class _BalanceCard extends StatefulWidget {
  final bool balanceVisible;
  final VoidCallback onToggleBalance;

  const _BalanceCard({
    required this.balanceVisible,
    required this.onToggleBalance,
  });

  @override
  State<_BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<_BalanceCard> {
  int _selectedAction = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDims.size_20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'ยอดเงินคงเหลือ',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppDims.size_6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.balanceVisible ? '฿2,050.00' : '฿ ••••••',
                style: AppTextStyles.displaySmall.copyWith(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: AppDims.size_8),
              GestureDetector(
                onTap: widget.onToggleBalance,
                child: SvgPicture.asset(
                  widget.balanceVisible
                      ? Assets.svg.icEye
                      : Assets.svg.icEyeSlash,
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDims.size_20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ActionButton(
                iconPath: Assets.svg.icDownload,
                label: 'เติมเงิน',
                isActive: _selectedAction == 0,
                onTap: () => setState(() => _selectedAction = 0),
              ),
              _ActionButton(
                iconPath: Assets.svg.icFaceId,
                label: 'สแกนจ่าย',
                isActive: _selectedAction == 1,
                onTap: () => setState(() => _selectedAction = 1),
              ),
              _ActionButton(
                iconPath: Assets.svg.icClock,
                label: 'ประวัติ',
                isActive: _selectedAction == 2,
                onTap: () => setState(() => _selectedAction = 2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Top-up form card
// ─────────────────────────────────────────────
class _TopUpCard extends StatelessWidget {
  final TextEditingController amountController;

  const _TopUpCard({required this.amountController});

  static const _quickAmounts = ['100', '200', '500', '1,000', '2,000'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDims.size_20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'ระบุจำนวนเงิน',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppDims.size_12),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: const [_AmountInputFormatter()],
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.gray400,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppDims.size_16,
                  vertical: AppDims.size_12,
                ),
              ),
            ),
          ),
          SizedBox(height: AppDims.size_8),
          Text(
            'เติมเงินขั้นต่ำ 100 บาท',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: AppDims.size_12),
          Row(
            children: _quickAmounts.map((amount) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: OutlinedButton(
                    onPressed: () {
                      amountController.text =
                          _AmountInputFormatter.formatAmount(
                            amount.replaceAll(',', ''),
                            fixedDecimal: true,
                          );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      amount,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: AppDims.size_20),
          Text(
            'ชำระด้วย',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppDims.size_12),
          const _PromptPayOption(),
          SizedBox(height: AppDims.size_50),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkBlue,
              foregroundColor: AppColors.white,
              padding: EdgeInsets.symmetric(vertical: AppDims.size_16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              'เติมเงิน',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PromptPay payment option
// ─────────────────────────────────────────────
class _PromptPayOption extends StatelessWidget {
  const _PromptPayOption();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.cocoaBrown, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(AppDims.size_12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.qr_code_2_rounded,
                color: AppColors.darkBlue,
                size: 26,
              ),
              SizedBox(width: AppDims.size_8),
              Text(
                'QR Code พร้อมเพย์',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDims.size_10),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDims.size_16,
              vertical: AppDims.size_10,
            ),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF003087),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Text(
                      'P',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppDims.size_8),
                Text(
                  'PromptPay',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: const Color(0xFF003087),
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Action button (เติมเงิน / สแกนจ่าย / ประวัติ)
// ─────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ActionButton({
    required this.iconPath,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: AppDims.size_64,
            height: AppDims.size_64,
            decoration: BoxDecoration(
              color: isActive ? AppColors.paleOrange : AppColors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive ? AppColors.transparent : AppColors.border,
              ),
            ),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isActive ? AppColors.cocoaBrown : AppColors.black2A,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: AppDims.size_6),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.black2A),
        ),
      ],
    );
  }
}

class _AmountInputFormatter extends TextInputFormatter {
  const _AmountInputFormatter();

  static final RegExp _allowedPattern = RegExp(r'^\d*\.?\d{0,2}$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final raw = newValue.text.replaceAll(',', '');
    if (raw.isEmpty) {
      return const TextEditingValue();
    }

    if (!_allowedPattern.hasMatch(raw)) {
      return oldValue;
    }

    final formatted = formatAmount(raw);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  static String formatAmount(String raw, {bool fixedDecimal = false}) {
    final parts = raw.split('.');
    final intPart = _formatInteger(parts.first);

    if (parts.length > 1) {
      final decimalPart = parts[1].replaceAll(RegExp(r'[^0-9]'), '');
      final limitedDecimal = decimalPart.length > 2
          ? decimalPart.substring(0, 2)
          : decimalPart;
      return '$intPart.$limitedDecimal';
    }

    return fixedDecimal ? '$intPart.00' : intPart;
  }

  static String _formatInteger(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) {
      return '0';
    }

    final normalized = digitsOnly.replaceFirst(RegExp(r'^0+(?=\d)'), '');
    return normalized.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (_) => ',',
    );
  }
}
