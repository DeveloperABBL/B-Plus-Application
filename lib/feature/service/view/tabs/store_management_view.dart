import 'package:brownyplus/core/core_index.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';

class StoreManagementView extends StatefulWidget {
  const StoreManagementView({super.key});

  @override
  State<StoreManagementView> createState() => _StoreManagementViewState();
}

class _StoreManagementViewState extends State<StoreManagementView> {
  int _selectedSidebarIndex = 0;
  int _selectedFilterIndex = 0;

  final List<Map<String, dynamic>> _sidebarItems = [
    {'label': 'เครื่องซัก', 'icon': Icons.local_laundry_service_rounded},
    {'label': 'เครื่องอบ', 'icon': Icons.wb_sunny_rounded},
    {'label': 'แก๊ส', 'icon': Icons.gas_meter_rounded},
    {'label': 'เตารีดไอน้ำ', 'icon': Icons.iron_rounded},
    {'label': 'เครื่องจำหน่าย', 'icon': Icons.on_device_training_rounded},
    {'label': 'ความสะอาด\nบำรุงรักษา', 'icon': Icons.cleaning_services_rounded},
    {'label': 'อื่นๆ', 'icon': Icons.grid_view_rounded},
    {'label': 'แจ้งเรื่อง', 'icon': Icons.chat_bubble_outline_rounded},
  ];

  final List<String> _filters = ['ทั้งหมด', 'ยังไม่ดำเนินการ', 'ดำเนินการแล้ว'];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar
        Container(
          width: 80,
          color: AppColors.white,
          child: ListView.builder(
            itemCount: _sidebarItems.length,
            itemBuilder: (context, index) {
              final item = _sidebarItems[index];
              final isSelected = _selectedSidebarIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedSidebarIndex = index),
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.white,
                    border: Border(
                      bottom: BorderSide(color: AppColors.border, width: 0.5),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item['icon'],
                        color: isSelected
                            ? AppColors.white
                            : AppColors.primary.withOpacity(0.6),
                        size: 24,
                      ),
                      AppDims.vericalPadding_4,
                      Text(
                        item['label'],
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
        // Content area
        Expanded(
          child: Container(
            color: AppColors.white,
            padding: EdgeInsets.symmetric(horizontal: AppDims.size_12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppDims.vericalPadding_10,
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.border)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'รายการทั้งหมด',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.gray400,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.border)),
                  ],
                ),
                AppDims.vericalPadding_10,
                // Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_filters.length, (index) {
                      final isSelected = _selectedFilterIndex == index;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedFilterIndex = index),
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          child: Text(
                            _filters[index],
                            style: AppTextStyles.labelSmall.copyWith(
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                AppDims.vericalPadding_10,
                // List
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return const _MachineItemCard();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MachineItemCard extends StatelessWidget {
  const _MachineItemCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.inputFieldDefaultBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.local_laundry_service_rounded,
              color: AppColors.border,
              size: 60,
            ),
          ),
          AppDims.horizonPadding_12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#1 (14 kg)',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppDims.vericalPadding_8,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.ci3, // Light green
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        Assets.svg.icChecked,
                        width: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '10/10 งาน',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                AppDims.vericalPadding_8,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'ว่าง',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(AppDims.size_10.w),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              Assets.svg.icForward,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              width: AppDims.size_16.w,
              height: AppDims.size_16.w,
            ),
          ),
        ],
      ),
    );
  }
}
