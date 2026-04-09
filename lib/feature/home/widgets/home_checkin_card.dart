import 'package:brownyplus/core/widgets/app_text.dart';
import 'package:brownyplus/feature/home/widgets/home_checkin_popup.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

void _showHomeCheckinPopup(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => const HomeCheckinPopup(),
  );
}

class HomeCheckinCard extends StatelessWidget {
  const HomeCheckinCard({super.key});

  @override
  Widget build(BuildContext context) {
    const cardRadius = 5.0;
    // ใช้วันปัจจุบันสำหรับการ์ดวันที่
    final now = DateTime.now();
    const thaiMonths = [
      'มกราคม',
      'กุมภาพันธ์',
      'มีนาคม',
      'เมษายน',
      'พฤษภาคม',
      'มิถุนายน',
      'กรกฎาคม',
      'สิงหาคม',
      'กันยายน',
      'ตุลาคม',
      'พฤศจิกายน',
      'ธันวาคม',
    ];
    final currentMonth = thaiMonths[now.month - 1];
    final currentDay = now.day.toString();

    return LayoutBuilder(
      builder: (context, constraints) {
        // ใช้ความกว้างเต็มพื้นที่ เพื่อลดช่องว่างด้านข้างของการ์ด
        final cardWidth = constraints.maxWidth;

        return Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: cardWidth,
            decoration: BoxDecoration(
              color: AppColors.white,
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
                  // แถบหัวการ์ด
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDims.size_12,
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
                        Expanded(
                          child: AppText.bodyBold('บันทึกเวลาเข้า-ออกงาน'),
                        ),
                      ],
                    ),
                  ),
                  const _DashedDivider(color: AppColors.ci2),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDims.size_6,
                      vertical: AppDims.size_12,
                    ),
                    child: Column(
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            const itemGap = 6.0;
                            // คงสัดส่วนภาพ PNG (clockin/clocked_out = 98x134)
                            // และคำนวณความสูงของแถวจากความกว้างคอลัมน์รูปภาพ
                            // เพื่อให้การ์ดแม่ขยายตามความสูงที่เหมาะสม
                            final gapWidth = itemGap * 2;
                            final rowWidth = constraints.maxWidth - gapWidth;

                            const totalFlex = 14.0;
                            final unitWidth = rowWidth / totalFlex;
                            final imageColumnWidth = unitWidth * 4;

                            const aspectRatio = 134.0 / 98.0; // สูง / กว้าง

                            final rowHeight =
                                imageColumnWidth * aspectRatio * 1.08;
                            return SizedBox(
                              height: rowHeight,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: _DateCard(
                                      radius: cardRadius,
                                      month: currentMonth,
                                      day: currentDay,
                                      timeIn: '9.50',
                                    ),
                                  ),
                                  const SizedBox(width: itemGap),
                                  Expanded(
                                    flex: 4,
                                    child: _CheckinActionImage(
                                      onTap: () =>
                                          _showHomeCheckinPopup(context),
                                      image: Assets.images.clock.clockin,
                                      badge: Assets.images.clock.repeatBadge,
                                      badgeTop: -8,
                                      badgeWidth: 65,
                                    ),
                                  ),
                                  const SizedBox(width: itemGap),
                                  Expanded(
                                    flex: 4,
                                    child: _CheckinActionImage(
                                      onTap: () =>
                                          _showHomeCheckinPopup(context),
                                      image: Assets.images.clock.clockedOut,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        AppDims.vericalPadding_8,
                        _BottomInfoBar(
                          radius: cardRadius,
                          leadingIcon: Assets.svg.icCalendarYellow,
                          text: '14.00 น. : ซ่อมบำรุงร้าน',
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// ปรับขนาดภาพเวลาเข้า/ออกให้พอดีกับคอลัมน์แคบโดยไม่ล้น Row
class _CheckinActionImage extends StatelessWidget {
  final VoidCallback onTap;
  final AssetGenImage image;
  final AssetGenImage? badge;
  final double badgeTop;
  final double? badgeWidth;

  const _CheckinActionImage({
    required this.onTap,
    required this.image,
    this.badge,
    this.badgeTop = -8,
    this.badgeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // ให้รูปเติมเต็มกรอบของแถวเวลาอย่างพอดี
          Positioned.fill(child: image.image(fit: BoxFit.contain)),
          if (badge != null)
            Positioned(
              top: badgeTop,
              child: badge!.image(width: badgeWidth),
            ),
        ],
      ),
    );
  }
}

class _BottomInfoBar extends StatelessWidget {
  final double radius;
  final String leadingIcon;
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
      color: AppColors.yellow4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(
          color: AppColors.yellow5.withValues(alpha: 0.5),
          width: 1.5,
        ),
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
                  color: AppColors.yellow5,
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
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: AppDims.size_4),
                decoration: BoxDecoration(
                  color: AppColors.ci3,
                  borderRadius: BorderRadius.circular(radius),
                ),
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: AppText.caption(
                    month,
                    color: AppColors.textSecondary,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              AppDims.vericalPadding_4,
              const _DashedDivider(color: AppColors.border),
            ],
          ),
          AppDims.vericalPadding_10,
          Expanded(
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: AppText.display(
                  day,
                  // คงขนาดตัวเลขให้เด่น แต่ไม่ให้ชนกันในหน้าจอแคบ
                  fontSize: 44.sp,
                  height: 0.9,
                ),
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(color: AppColors.border, height: 1, thickness: 1),
              AppDims.vericalPadding_2,
              Container(
                padding: EdgeInsets.symmetric(vertical: AppDims.size_2),
                decoration: BoxDecoration(
                  color: AppColors.inputFieldDefaultBg,
                  borderRadius: BorderRadius.circular(radius),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText.bodyBold(
                              timeIn,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 1),
                            AppText.tiny(
                              'เวลาเข้า',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(width: 1, height: 20, color: AppColors.border),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText.bodyBold(
                              timeIn,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: 1),
                            AppText.tiny(
                              'เวลาออก',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
