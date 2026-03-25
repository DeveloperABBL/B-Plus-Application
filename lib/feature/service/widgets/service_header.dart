import 'package:flutter/material.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ServiceHeader extends StatelessWidget {
  const ServiceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppDims.size_16,
        right: AppDims.size_16,
        top: AppDims.size_12,
        bottom: 0,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home_page');
              }
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: AppColors.textPrimary,
            iconSize: AppDims.size_24,
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),

          AppDims.horizonPadding_12,
          Expanded(
            child: Container(
              height: AppDims.size_40,
              decoration: BoxDecoration(
                color: AppColors.inputFieldDefaultBg,
                borderRadius: BorderRadius.circular(AppDims.size_12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'ค้นหา',
                  hintStyle: const TextStyle(
                    color: AppColors.gray400,
                    fontSize: 15,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.search,
                      color: AppColors.gray400,
                      size: 20,
                    ),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ),
          AppDims.horizonPadding_12,
          _HeaderAction(
            icon: Assets.svg.icCalendar,
            onTap: () {},
            showBadge: true,
          ),
          AppDims.horizonPadding_8,
          _HeaderAction(icon: Assets.svg.icBell, onTap: () {}, showBadge: true),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  final bool showBadge;

  const _HeaderAction({
    required this.icon,
    required this.onTap,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SvgPicture.asset(
            icon,
            width: AppDims.size_24,
            height: AppDims.size_24,
            colorFilter: const ColorFilter.mode(
              AppColors.primary,
              BlendMode.srcIn,
            ),
          ),
          if (showBadge)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
