import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';

class StockInventoryView extends StatefulWidget {
  const StockInventoryView({super.key});

  @override
  State<StockInventoryView> createState() => _StockInventoryViewState();
}

class _StockInventoryViewState extends State<StockInventoryView> {
  int _selectedSidebarIndex = 0;

  final List<Map<String, String>> _sidebarItems = [
    {'title': 'สำหรับ\nจำหน่าย', 'icon': Assets.svg.icShop},
    {'title': 'ใช้ภายในร้าน', 'icon': Assets.svg.icBox},
    {'title': 'แจ้งปัญหา', 'icon': Assets.svg.icChat2},
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 70,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(right: BorderSide(color: AppColors.border)),
          ),
          child: ListView.builder(
            itemCount: _sidebarItems.length,
            itemBuilder: (context, index) {
              final item = _sidebarItems[index];
              final isSelected = _selectedSidebarIndex == index;

              return GestureDetector(
                onTap: () => setState(() => _selectedSidebarIndex = index),
                child: Container(
                  height: 68,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.white,
                    border: Border(
                      bottom: BorderSide(color: AppColors.border, width: 0.5),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        item['icon']!,
                        colorFilter: isSelected
                            ? const ColorFilter.matrix([
                                -1, 0, 0, 0, 412,
                                0, -1, 0, 0, 488,
                                0, 0, -1, 0, 417,
                                0, 0, 0, 1, 0,
                              ])
                            : null,
                        width: 24,
                        height: 24,
                      ),
                      AppDims.vericalPadding_2,
                      Text(
                        item['title']!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.textSecondary,
                          fontSize: 10,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
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
