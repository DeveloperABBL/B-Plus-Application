import 'package:brownyplus/core/core_index.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StoreManagementView extends StatefulWidget {
  const StoreManagementView({super.key});

  @override
  State<StoreManagementView> createState() => _StoreManagementViewState();
}

class _StoreManagementViewState extends State<StoreManagementView> {
  int _selectedSidebarIndex = 0;
  int _selectedFilterIndex = 0;

  final List<Map<String, dynamic>> _sidebarItems = [
    {'label': 'เครื่องซัก', 'icon': Assets.svg.icLaundry},
    {'label': 'เครื่องอบ', 'icon': Assets.svg.icDryer},
    {'label': 'แก๊ส', 'icon': Assets.svg.icGas},
    {'label': 'เตารีดไอน้ำ', 'icon': Assets.svg.icIron},
    {'label': 'เครื่องจำหน่าย', 'icon': Assets.svg.icVendingMc},
    {'label': 'ความสะอาด\nบำรุงรักษา', 'icon': Assets.svg.icLaundry},
    {'label': 'อื่นๆ', 'icon': Assets.svg.icMore},
    {'label': 'แจ้งเรื่อง', 'icon': Assets.svg.icChat},
  ];

  final List<String> _filters = ['ทั้งหมด', 'ยังไม่ดำเนินการ', 'ดำเนินการแล้ว'];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar
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
                      Opacity(
                        opacity: isSelected ? 1.0 : 1.0,
                        child: SvgPicture.asset(
                          item['icon'] as String,
                          colorFilter: isSelected
                              ? const ColorFilter.matrix([
                                  // Swap #9DE9A2 (green) ↔ #FFFFFF (white)
                                  // R' = -R + 412,  G' = -G + 488,  B' = -B + 417
                                  -1, 0, 0, 0, 412,
                                  0, -1, 0, 0, 488,
                                  0, 0, -1, 0, 417,
                                  0, 0, 0, 1, 0,
                                ])
                              : null,
                          width: 24,
                          height: 24,
                        ),
                      ),
                      AppDims.vericalPadding_2,
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
      // decoration: BoxDecoration(
      //   color: AppColors.inputFieldDefaultBg,
      //   borderRadius: BorderRadius.circular(12),
      // ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.grayBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(AppDims.size_12),
                child: Image.asset(
                  Assets.png.laundryMc.path,
                  width: 56,
                  height: 56,
                  fit: BoxFit.contain,
                ),
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
                        SvgPicture.asset(Assets.svg.icChecked, width: 14),
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
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'ไม่ว่าง',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
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
                  width: AppDims.size_12.w,
                  height: AppDims.size_12.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
