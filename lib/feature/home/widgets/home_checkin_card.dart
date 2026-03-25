import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:brownyplus/core/widgets/app_text.dart';
import 'package:brownyplus/feature/home/widgets/home_checkin_popup.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/res/dims/app_dims.dart';

class HomeCheckinCard extends StatelessWidget {
  const HomeCheckinCard({super.key});

  @override
  Widget build(BuildContext context) {
    const cardRadius = 5.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.ci3,
        borderRadius: BorderRadius.circular(AppDims.size_8),
        border: Border.all(color: AppColors.ci2),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDims.size_8),
        child: Column(
          children: [
            // Header strip
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDims.size_14,
                vertical: AppDims.size_10,
              ),
              color: AppColors.ci3,
              child: Row(
                children: [
                  Container(
                    width: AppDims.size_26,
                    height: AppDims.size_26,
                    decoration: BoxDecoration(
                      color: AppColors.ci2,
                      borderRadius: BorderRadius.circular(AppDims.size_8),
                    ),
                    child: SvgPicture.asset(
                      Assets.svg.icNote,
                      width: AppDims.size_24,
                      height: AppDims.size_24,
                    ),
                  ),
                  AppDims.horizonPadding_10,
                  Expanded(child: AppText.bodyBold('บันทึกเวลาเข้า-ออกงาน')),
                ],
              ),
            ),
            const _DashedDivider(color: AppColors.ci2),
            Padding(
              padding: EdgeInsets.all(AppDims.size_12),
              child: Column(
                children: [
                  SizedBox(
                    height: 140,
                    child: Row(
                      children: [
                        Expanded(
                          child: _DateCard(
                            radius: cardRadius,
                            month: 'กุมภาพันธ์',
                            day: '18',
                            timeIn: '9.50',
                          ),
                        ),
                        AppDims.horizonPadding_8,
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => const HomeCheckinPopup(),
                            );
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topCenter,
                            children: [
                              Assets.images.clock.clockin.image(height: 150),
                              Positioned(
                                top: -8,
                                child:
                                    Assets.images.clock.repeatBadge.image(),
                              ),
                            ],
                          ),
                        ),
                        AppDims.horizonPadding_8,
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => const HomeCheckinPopup(),
                            );
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.topCenter,
                            children: [
                              Assets.images.clock.clockedOut.image(height: 150),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppDims.vericalPadding_8,
                  _BottomInfoBar(
                    radius: cardRadius,
                    leadingIcon: Icons.calendar_month_rounded,
                    text: '14.00 น. : ซ่อมบำรุงร้าน',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomInfoBar extends StatelessWidget {
  final double radius;
  final IconData leadingIcon;
  final String text;
  final VoidCallback onTap;

  const _BottomInfoBar({
    required this.radius,
    required this.leadingIcon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.paleOrange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: const BorderSide(color: AppColors.yellow2, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDims.size_10,
            vertical: AppDims.size_8,
          ),
          child: Row(
            children: [
              Container(
                width: AppDims.size_28,
                height: AppDims.size_28,
                decoration: const BoxDecoration(
                  color: AppColors.yellow2,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  Assets.svg.icCalendarYellow,
                  width: AppDims.size_18,
                  height: AppDims.size_18,
                ),
              ),
              AppDims.horizonPadding_8,
              Expanded(
                child: AppText(
                  text,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  final double radius;
  final String month;
  final String day;
  final String timeIn;

  const _DateCard({
    required this.radius,
    required this.month,
    required this.day,
    required this.timeIn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius * 1.5),
        border: Border.all(color: AppColors.border),
      ),
      padding: EdgeInsets.all(AppDims.size_5),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: AppDims.size_4),
            decoration: BoxDecoration(
              color: AppColors.ci3,
              borderRadius: BorderRadius.circular(radius),
            ),
            alignment: Alignment.center,
            child: AppText.caption(month, color: AppColors.textSecondary),
          ),
          AppDims.vericalPadding_4,
          const _DashedDivider(color: AppColors.border),
          const Spacer(),
          AppText.display(day),
          const Spacer(),
          const Divider(color: AppColors.border, height: 1, thickness: 1),
          AppDims.vericalPadding_4,
          Container(
            padding: EdgeInsets.symmetric(vertical: AppDims.size_4),
            decoration: BoxDecoration(
              color: AppColors.inputFieldDefaultBg,
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      AppText.bodyBold(timeIn, color: AppColors.textSecondary),
                      const SizedBox(height: 1),
                      AppText.tiny('เวลาเข้า'),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: AppColors.border,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '-',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray500,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'เวลาออก',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.gray500,
                        ),
                      ),
                    ],
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

class _DashedDivider extends StatelessWidget {
  final Color color;

  const _DashedDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return DottedLine(
      direction: Axis.horizontal,
      lineLength: double.infinity,
      lineThickness: 2.0,
      dashLength: 6.0,
      dashColor: color,
      dashGapLength: 4.0,
    );
  }
}
