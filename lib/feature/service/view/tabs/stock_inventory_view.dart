import 'package:flutter/material.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';

class StockInventoryView extends StatelessWidget {
  const StockInventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          decoration: const BoxDecoration(
            color: AppColors.inputFieldDefaultBg,
            border: Border(right: BorderSide(color: AppColors.border, width: 1)),
          ),
          child: const Column(
            children: [
              _SidebarItem(title: 'สำหรับ\nจำหน่าย', icon: Icons.shopping_basket_rounded, isSelected: true),
              _SidebarItem(title: 'ใช้ภายในร้าน', icon: Icons.store_rounded),
              _SidebarItem(title: 'แจ้งปัญหา', icon: Icons.help_outline_rounded),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppDims.size_16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'รายการทั้งหมด',
                        style: AppTextStyles.labelMedium.copyWith(color: AppColors.gray400),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                AppDims.vericalPadding_16,
                const _StockItem(title: 'น้ำยาปรับผ้านุ่ม ไฮยีนสีดำ กลิ่นพีโอนีบลูม'),
                const _StockItem(title: 'ไฮยีนสีชมพู กลิ่นซันไรส์คิส'),
                const _StockItem(title: 'ดาวนี่ สีชมพู'),
                const _StockItem(title: 'น้ำยาซักผ้า บรีสสีชมพู'),
                const _StockItem(title: 'น้ำยาซักผ้า บรีสสีม่วง'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;

  const _SidebarItem({required this.title, required this.icon, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: isSelected ? AppColors.primary : Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Icon(icon, color: isSelected ? AppColors.white : AppColors.primary, size: 24),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSmall.copyWith(
              color: isSelected ? AppColors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _StockItem extends StatelessWidget {
  final String title;

  const _StockItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDims.size_16),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.inputFieldDefaultBg,
              borderRadius: BorderRadius.circular(AppDims.size_8),
            ),
            child: const Icon(Icons.inventory_2_rounded, color: AppColors.border, size: 48),
          ),
          AppDims.horizonPadding_12,
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary, size: 16),
        ],
      ),
    );
  }
}
