import 'package:flutter/material.dart';

import '../widgets/home_action_grid.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_banner_carousel.dart';
import '../widgets/home_checkin_card.dart';
import '../widgets/home_service_status_section.dart';
import '../widgets/home_shell.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeShell(
      currentIndex: 0,
      body: Container(
        color: Colors.white,
        child: SafeArea(
          bottom: false,
          child: Container(
            color: const Color(0xFFF5F5F5),
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: ColoredBox(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 20),
                      child: HomeAppBar(
                        title: 'บราวนี่ บราวนี่',
                        subtitle: 'สาขาเทอร์มินอล 21 พระรามสาม',
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: HomeBannerCarousel(),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: HomeCheckinCard(),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: HomeServiceStatusSection(),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: HomeActionGrid(),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 18)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
