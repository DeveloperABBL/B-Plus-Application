import 'package:flutter/material.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/dims/app_dims.dart';

import '../widgets/home_action_grid.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_banner_carousel.dart';
import '../widgets/home_checkin_card.dart';
import '../widgets/home_service_status_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const pagePath = '/home_page';
  static const pageName = 'HomePage';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.transparent,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.background,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppDims.size_16,
                    AppDims.size_12,
                    AppDims.size_16,
                    AppDims.size_16,
                  ),
                  child: const HomeAppBar(
                    title: 'บราวนี่ บราวนี่',
                    subtitle: 'สาขาเทอร์มินอล 21 พระรามสาม',
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: AppDims.vericalPadding_16),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDims.size_16),
              child: const HomeBannerCarousel(),
            ),
          ),
          SliverToBoxAdapter(child: AppDims.vericalPadding_12),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDims.size_16),
              child: const HomeCheckinCard(),
            ),
          ),
          SliverToBoxAdapter(child: AppDims.vericalPadding_12),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDims.size_16),
              child: const HomeServiceStatusSection(),
            ),
          ),
          SliverToBoxAdapter(child: AppDims.vericalPadding_12),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDims.size_16),
              child: const HomeActionGrid(),
            ),
          ),
          SliverToBoxAdapter(child: AppDims.vericalPadding_18),
        ],
      ),
    );
  }
}
