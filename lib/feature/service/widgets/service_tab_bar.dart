import 'package:flutter/material.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';
import 'package:brownyplus/res/dims/app_dims.dart';

class ServiceTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;

  const ServiceTabBar({
    super.key,
    required this.controller,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: EdgeInsets.only(top: AppDims.size_8, bottom: AppDims.size_12),
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: UnderlineTabIndicator(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 3, color: AppColors.primary),
        ),
        labelColor: AppColors.textPrimary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: AppTextStyles.bodyMedium,
        tabs: tabs.map((title) => Tab(text: title)).toList(),
      ),
    );
  }
}
