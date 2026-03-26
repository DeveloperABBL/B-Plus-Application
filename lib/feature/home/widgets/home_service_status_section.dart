import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';

class HomeServiceStatusSection extends StatelessWidget {
  const HomeServiceStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_ServiceItem>[
      _ServiceItem(
        title: 'บริษัทนีย์ ส. - 0800000000',
        statusText: 'สถานะ : ดำเนินการสำเร็จ',
        serviceText: 'บริการ : พับ',
        imagePath: Assets.images.order.order1.path,
        statusTone: _StatusTone.success,
      ),
      _ServiceItem(
        title: 'โจจิ - 0800000000',
        statusText: 'สถานะ : กำลังดำเนินการ',
        serviceText: 'บริการ : อบร้อนต่ำ + 24 นาที (เครื่องอบ 1)',
        imagePath: Assets.images.order.order2.path,
        statusTone: _StatusTone.warning,
      ),
      _ServiceItem(
        title: 'โจจิ - 0800000000',
        statusText: 'สถานะ : รอดำเนินการ',
        serviceText: 'บริการ : -',
        imagePath: Assets.images.order.order3.path,
        statusTone: _StatusTone.warning,
      ),
    ];

    return _SectionCard(
      icon: SvgPicture.asset(
        Assets.svg.icRefreshDouble,
        width: AppDims.size_24,
        height: AppDims.size_24,
      ),
      title: 'สถานะการบริการซัก อบ พับ',
      child: Column(
        children: [
          ...items.map(
            (e) => Padding(
              padding: EdgeInsets.only(bottom: AppDims.size_10),
              child: _ServiceRow(item: e),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'แสดงเพิ่มเติม',
                    style: AppTextStyles.labelSmall.copyWith(
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  final _ServiceItem item;

  const _ServiceRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final tone = item.statusTone;

    return Container(
      padding: EdgeInsets.symmetric(vertical: AppDims.size_12),
      decoration: const BoxDecoration(color: AppColors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppDims.size_85,
            height: AppDims.size_85,
            decoration: BoxDecoration(
              color: AppColors.inputFieldDefaultBg,
              borderRadius: BorderRadius.circular(14),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(item.imagePath, fit: BoxFit.cover),
          ),
          AppDims.horizonPadding_8,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    AppDims.horizonPadding_8,
                    SvgPicture.asset(
                      Assets.svg.icArrowRight,
                      width: AppDims.size_24,
                      height: AppDims.size_24,
                    ),
                  ],
                ),
                AppDims.vericalPadding_4,
                Text(
                  item.statusText,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
                Text(
                  item.serviceText,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
                AppDims.vericalPadding_8,
                _StatusChip(tone: tone),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final _StatusTone tone;

  const _StatusChip({required this.tone});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (tone) {
      _StatusTone.success => (AppColors.ci3, AppColors.primary, 'ชำระแล้ว'),
      _StatusTone.warning => (
        AppColors.paleOrange,
        AppColors.textPrimary,
        'ชำระโดยผู้จัดการสาขา',
      ),
      _StatusTone.neutral => (
        AppColors.inputFieldDefaultBg,
        AppColors.textSecondary,
        'รอดำเนินการ',
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDims.size_8),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: fg,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? icon;

  const _SectionCard({required this.title, required this.child, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDims.size_14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDims.size_8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[icon!, AppDims.horizonPadding_8],
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          AppDims.vericalPadding_10,
          child,
        ],
      ),
    );
  }
}

enum _StatusTone { success, warning, neutral }

class _ServiceItem {
  final String title;
  final String statusText;
  final String serviceText;
  final String imagePath;
  final _StatusTone statusTone;

  const _ServiceItem({
    required this.title,
    required this.statusText,
    required this.serviceText,
    required this.imagePath,
    required this.statusTone,
  });
}
