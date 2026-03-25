import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:brownyplus/core/widgets/primary_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';

class HomeCheckinPopup extends StatelessWidget {
  const HomeCheckinPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDims.size_24),
      ),
      insetPadding: EdgeInsets.zero,
      backgroundColor: AppColors.white,
      surfaceTintColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(AppDims.size_20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'บันทึกเวลาเข้างาน',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            AppDims.vericalPadding_24,
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'สื่อประกอบ',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: '*',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
            AppDims.vericalPadding_8,
            _DashedMediaUpload(onTap: () {}),
            AppDims.vericalPadding_16,
            Text(
              'เวลา',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            AppDims.vericalPadding_8,
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: AppDims.size_16,
                vertical: AppDims.size_14,
              ),
              decoration: BoxDecoration(
                color: AppColors.inputFieldDefaultBg,
                borderRadius: BorderRadius.circular(AppDims.size_12),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                '9.50 น.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            AppDims.vericalPadding_16,
            Text(
              'สาขา',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            AppDims.vericalPadding_8,
            Container(
              width: double.infinity,
              height: AppDims.size_52,
              padding: EdgeInsets.symmetric(horizontal: AppDims.size_16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppDims.size_12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'สาขาเทอร์มินอล 21 พระรามสาม',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.gray500,
                  ),
                ],
              ),
            ),
            AppDims.vericalPadding_32,
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                label: 'บันทึก',
                onPressed: () {
                  Navigator.pop(context);
                },
                alignment: Alignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedMediaUpload extends StatelessWidget {
  final VoidCallback onTap;

  const _DashedMediaUpload({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.ci3, // Very light green
          borderRadius: BorderRadius.circular(AppDims.size_12),
        ),
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: AppColors.ci2,
            strokeWidth: 1.5,
            gap: 4,
            dash: 8,
            radius: 12,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                Assets.svg.icMediaImage,
                width: AppDims.size_40,
                height: AppDims.size_40,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              AppDims.vericalPadding_8,
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDims.size_16,
                  vertical: AppDims.size_8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.ci3,
                  borderRadius: BorderRadius.circular(AppDims.size_8),
                ),
                child: Text(
                  'ถ่ายรูปภาพหรือวิดีโอ',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dash;
  final double radius;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.gap,
    required this.dash,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius),
        ),
      );

    final Path dashedPath = Path();

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dashedPath.addPath(
          metric.extractPath(distance, distance + dash),
          Offset.zero,
        );
        distance += dash + gap;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
