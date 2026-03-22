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
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: HomeAppBar(
                  title: 'บราวนี่ บราวนี่',
                  subtitle: 'สาขา... (ใส่เพิ่มทีหลัง)',
                ),
              ),
            ),
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
    );
  }
}
