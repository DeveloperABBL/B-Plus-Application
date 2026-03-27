import 'package:brownyplus/core/core_index.dart';
import 'package:flutter/material.dart';

class AppNotification extends StatelessWidget {
  final String title;
  final String message;
  final Widget? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppNotification({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    Widget? icon,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return showDialog(
      context: context,
      barrierColor: AppColors.overlay,
      builder: (context) => AppNotification(
        title: title,
        message: message,
        icon: icon,
        actionLabel: actionLabel,
        onAction: onAction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: AppDims.size_24.w),
      surfaceTintColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDims.size_24.r),
          boxShadow: AppColors.defatultShadow,
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left side: Green Area with Curve
              Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    CustomPaint(
                      size: Size.infinite,
                      painter: _NotificationBackgroundPainter(
                        color: AppColors.ctaPrimaryDefault,
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppDims.size_12.w),
                          child: icon ??
                              const Icon(
                                Icons.info_outline,
                                color: AppColors.white,
                                size: 48,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Right side: Content Area
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(AppDims.size_20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.title(
                        title,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      AppDims.vericalPadding_4,
                      AppText.bodySmall(
                        message,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (actionLabel != null) ...[
                        const Spacer(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            onPressed: onAction ?? () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.ctaPrimaryDefault,
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: AppText.body(
                              actionLabel!,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.ctaPrimaryDefault,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ] else
                        AppDims.vericalPadding_12,
                    ],
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

class _NotificationBackgroundPainter extends CustomPainter {
  final Color color;

  _NotificationBackgroundPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.8, 0);

    // Create the "outward" curve into the white area
    path.cubicTo(
      size.width * 0.85,
      size.height * 0.2, // Control point 1
      size.width * 1.15,
      size.height * 0.5, // Control point 2 - furthest bulge
      size.width * 0.8,
      size.height, // End point
    );

    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
