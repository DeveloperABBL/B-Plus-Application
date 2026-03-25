import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';

class HomeAppBar extends StatelessWidget {
  final String title;
  final String subtitle;

  const HomeAppBar({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppDims.size_44,
          height: AppDims.size_44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border, width: 1),
          ),
          child: ClipOval(
            child: Assets.images.banner.frame2087327902.image(
              fit: BoxFit.cover,
              errorBuilder:
                  (_, _, _) =>
                      Icon(Icons.person_rounded, color: AppColors.primary),
            ),
          ),
        ),
        AppDims.horizonPadding_12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        _IconWithDot(
          iconPath: Assets.svg.icCalendar,
          dotColor: AppColors.error, // Red dot
        ),
        const SizedBox(width: 15),
        _IconWithDot(
          iconPath: Assets.svg.icBell,
          dotColor: AppColors.error, // Red dot
        ),
        AppDims.horizonPadding_8,
      ],
    );
  }
}

class _IconWithDot extends StatelessWidget {
  final String iconPath;
  final Color dotColor;

  const _IconWithDot({required this.iconPath, required this.dotColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SvgPicture.asset(
          iconPath,
          width: AppDims.size_26,
          height: AppDims.size_26,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        ),
        Positioned(
          top: 0,
          right: -1,
          child: Container(
            width: AppDims.size_10,
            height: AppDims.size_10,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _IconPillButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _IconPillButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDims.size_40,
      width: AppDims.size_40,
      child: Material(
        color: AppColors.inputFieldDefaultBg,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onPressed,
          child: Icon(icon, size: 22, color: AppColors.textBare),
        ),
      ),
    );
  }
}
