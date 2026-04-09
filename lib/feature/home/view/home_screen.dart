import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:flutter/material.dart';

import '../widgets/home_action_grid.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_banner_carousel.dart';
import '../widgets/home_checkin_card.dart';
import '../widgets/home_service_status_section.dart';

/// หน้าหลักของแอปในส่วน Home
///
/// โครงสร้างหน้านี้ใช้ `CustomScrollView` + `SliverToBoxAdapter` เพื่อให้:
/// - ควบคุมการเรียงลำดับ section ต่าง ๆ แบบแนวตั้งได้ชัดเจน
/// - รองรับการเลื่อน (scroll) ทั้งหน้าอย่างลื่นไหล
/// - เพิ่ม/ลด section ในอนาคตได้ง่าย โดยแทรก sliver เพิ่มใน `slivers`
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// route path ที่ใช้สำหรับ navigation ไปยังหน้า Home
  static const pagePath = '/home_page';

  /// ชื่อ route สำหรับงานที่ต้องอ้างชื่อหน้า เช่น analytics หรือ logging
  static const pageName = 'HomePage';

  @override
  Widget build(BuildContext context) {
    return Container(
      // โปร่งใสเพื่อไม่ทับพื้นหลังหลักของหน้าหรือ parent widget
      color: AppColors.transparent,
      child: CustomScrollView(
        slivers: [
          // ส่วนหัวของหน้า:
          // - มีพื้นหลังสีหลักของหน้า Home
          // - ครอบด้วย SafeArea เพื่อหลบ notch / status bar
          // - ใช้ padding มาตรฐานของระบบดีไซน์
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

          // ระยะห่างระหว่างส่วนหัวกับแบนเนอร์โปรโมชัน
          SliverToBoxAdapter(child: AppDims.vericalPadding_16),

          // แบนเนอร์แบบ carousel สำหรับสื่อสารโปรโมชันหรือข่าวสารสำคัญ
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDims.size_16),
              child: const HomeBannerCarousel(),
            ),
          ),

          // ระยะห่างก่อนการ์ดเช็คอิน
          SliverToBoxAdapter(child: AppDims.vericalPadding_12),

          // การ์ดเช็คอิน (จุดกระตุ้น action หลักของผู้ใช้ในหน้า Home)
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDims.size_8),
              child: const HomeCheckinCard(),
            ),
          ),

          // ระยะห่างก่อน section สถานะการให้บริการ
          SliverToBoxAdapter(child: AppDims.vericalPadding_12),

          // แสดงสถานะการให้บริการ/ความพร้อมของสาขาหรือระบบ
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDims.size_16),
              child: const HomeServiceStatusSection(),
            ),
          ),

          // ระยะห่างก่อนปุ่มเมนูลัด
          SliverToBoxAdapter(child: AppDims.vericalPadding_12),

          // กริดเมนูการทำงานหลัก (quick actions) สำหรับเข้าฟีเจอร์สำคัญ
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDims.size_16),
              child: const HomeActionGrid(),
            ),
          ),

          // เว้นท้ายหน้าสำหรับความสบายตาและไม่ให้ content ชิดขอบล่างเกินไป
          SliverToBoxAdapter(child: AppDims.vericalPadding_18),
        ],
      ),
    );
  }
}
