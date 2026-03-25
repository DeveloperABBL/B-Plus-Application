import 'package:flutter/material.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';

class ReportIssueView extends StatelessWidget {
  const ReportIssueView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDims.size_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.grid_view_rounded, color: AppColors.primary, size: 24),
              AppDims.horizonPadding_8,
              Text(
                'หมวดหมู่',
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          AppDims.vericalPadding_16,
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppDims.size_12,
            crossAxisSpacing: AppDims.size_12,
            childAspectRatio: 1.5,
            children: const [
              _CategoryCard(title: 'เครื่องจักร', count: '14', icon: Icons.settings_rounded),
              _CategoryCard(title: 'เครื่องจำหน่าย', count: '2', icon: Icons.on_device_training_rounded),
              _CategoryCard(title: 'บำรุงรักษา', count: '14', icon: Icons.build_rounded),
              _CategoryCard(title: 'แก๊ส', count: '2', icon: Icons.gas_meter_rounded),
            ],
          ),
          AppDims.vericalPadding_12,
          const _SuggestionCard(),
          AppDims.vericalPadding_24,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, color: AppColors.primary, size: 24),
                  AppDims.horizonPadding_8,
                  Text(
                    'ประวัติรายการ',
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.gray400, size: 16),
            ],
          ),
          AppDims.vericalPadding_16,
          const _HistoryItem(title: 'เครื่องซัก #1', date: '21 มกราคม 2025', status: 'รอเดินการ', isWaiting: true),
          const _HistoryItem(title: 'เครื่องซัก #1', date: '21 มกราคม 2025', status: 'สำเร็จ', isWaiting: false),
          const _HistoryItem(title: 'เครื่องซัก #1', date: '21 มกราคม 2025', status: 'สำเร็จ', isWaiting: false),
          AppDims.vericalPadding_16,
          Center(
            child: Text(
              'แสดงเพิ่มเติม',
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
            ),
          ),
          const Center(child: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary)),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;

  const _CategoryCard({required this.title, required this.count, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDims.size_12),
      decoration: BoxDecoration(
        color: AppColors.inputFieldDefaultBg,
        borderRadius: BorderRadius.circular(AppDims.size_12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w700)),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(count, style: AppTextStyles.bodyMedium),
              ),
              Icon(icon, color: AppColors.border, size: 40),
            ],
          ),
        ],
      ),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDims.size_16),
      decoration: BoxDecoration(
        color: AppColors.inputFieldDefaultBg,
        borderRadius: BorderRadius.circular(AppDims.size_12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'ข้อเสนอแนะ\nร้องเรียน',
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
          ),
          const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.border, size: 48),
        ],
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final String title;
  final String date;
  final String status;
  final bool isWaiting;

  const _HistoryItem({
    required this.title,
    required this.date,
    required this.status,
    required this.isWaiting,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDims.size_12),
      padding: EdgeInsets.all(AppDims.size_12),
      decoration: BoxDecoration(
        color: AppColors.inputFieldDefaultBg,
        borderRadius: BorderRadius.circular(AppDims.size_12),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppDims.size_8),
            ),
            child: const Icon(Icons.local_laundry_service_rounded, color: AppColors.border, size: 40),
          ),
          AppDims.horizonPadding_12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
                Text('เรื่อง : อื่นๆ ไม่แน่ใจ', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
                Text('วันที่แจ้ง : $date', style: AppTextStyles.labelSmall.copyWith(color: AppColors.gray400)),
                Row(
                  children: [
                    Text('Case ID : 000007', style: AppTextStyles.labelSmall.copyWith(color: AppColors.gray400)),
                    AppDims.horizonPadding_8,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isWaiting ? AppColors.border : AppColors.ci3,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isWaiting ? AppColors.textSecondary : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary, size: 16),
        ],
      ),
    );
  }
}
