import 'package:flutter/material.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';

class ServiceStatusView extends StatelessWidget {
  final bool isStoreManagement;

  const ServiceStatusView({super.key, required this.isStoreManagement});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDims.size_16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.refresh_rounded, color: AppColors.primary, size: 24),
              AppDims.horizonPadding_8,
              Text(
                'ทั้งหมด',
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
              _StatusCard(title: 'กำลังดำเนินการ', count: '14', icon: Icons.sync_rounded, color: AppColors.ci3),
              _StatusCard(title: 'ยังไม่เริ่ม', count: '1', icon: Icons.list_rounded, color: AppColors.inputFieldDefaultBg),
              _StatusCard(title: 'เสร็จสิ้น', count: '14', icon: Icons.check_circle_outline_rounded, color: AppColors.ci6),
              _CreateOrderCard(),
            ],
          ),
          AppDims.vericalPadding_24,
          const _StatusHeader(title: 'กำลังดำเนินการ', icon: Icons.sync_rounded),
          AppDims.vericalPadding_16,
          const _ServiceItem(title: 'บริษัณีย์ ส. - 0800000000', status: 'กำลังดำเนินการ', service: 'พับ'),
          const _ServiceItem(title: 'โจจิ - 0800000000', status: 'อบร้อนต่ำ + 24 นาที (เครื่องอบ 1)', service: 'พับ', isManager: true),
          const _ServiceItem(title: 'โจจิ - 0800000000', status: 'กำลังซัก + 6 นาที (เครื่องซัก 3)', isManager: true),
          const _ServiceItem(title: 'บริษัณีย์ ส. - 0800000000', status: 'กำลังดำเนินการ', service: 'พับ', isSuccess: true),
          const _ServiceItem(title: 'โจจิ - 0800000000', status: 'อบร้อนต่ำ + 24 นาที (เครื่องอบ 1)', isManager: true),
          
          AppDims.vericalPadding_16,
          Center(
            child: Text(
              'แสดงเพิ่มเติม',
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
            ),
          ),
          const Center(child: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary)),

          AppDims.vericalPadding_24,
          const _StatusHeader(title: 'ยังไม่เริ่ม', icon: Icons.list_rounded),
          AppDims.vericalPadding_16,
          const _ServiceItem(title: 'โจจิ - 0800000000', status: 'รอดำเนินการ', isManager: true),

          AppDims.vericalPadding_24,
          const _StatusHeader(title: 'เสร็จสิ้น', icon: Icons.check_circle_outline_rounded),
          AppDims.vericalPadding_16,
          const _ServiceItem(title: 'บริษัณีย์ ส. - 0800000000', status: 'เสร็จสิ้น', date: '21/11/2025 เวลา 16.02 น.', isSuccess: true, showArrow: true),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;

  const _StatusCard({required this.title, required this.count, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDims.size_12),
      decoration: BoxDecoration(
        color: color,
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
              Icon(icon, color: AppColors.primary, size: 40),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreateOrderCard extends StatelessWidget {
  const _CreateOrderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.ci3,
        borderRadius: BorderRadius.circular(AppDims.size_12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add, color: AppColors.primary, size: 40),
          Text(
            'สร้างออเดอร์ใหม่',
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _StatusHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _StatusHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        AppDims.horizonPadding_8,
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _ServiceItem extends StatelessWidget {
  final String title;
  final String status;
  final String? service;
  final String? date;
  final bool isManager;
  final bool isSuccess;
  final bool showArrow;

  const _ServiceItem({
    required this.title,
    required this.status,
    this.service,
    this.date,
    this.isManager = false,
    this.isSuccess = false,
    this.showArrow = false,
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
                if (date != null) Text('วันที่ $date', style: AppTextStyles.labelSmall.copyWith(color: AppColors.gray400)),
                Text('สถานะ : $status', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
                if (service != null) Text('บริการ : $service', style: AppTextStyles.labelMedium.copyWith(color: AppColors.textSecondary)),
                if (isManager)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.paleOrange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('ชำระโดยผู้จัดการสาขา', style: AppTextStyles.labelSmall.copyWith(color: AppColors.cocoaBrown)),
                  ),
                if (isSuccess)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.ci3,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text('ชำระแล้ว', style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary)),
                  ),
              ],
            ),
          ),
          if (showArrow) const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary, size: 16),
        ],
      ),
    );
  }
}
