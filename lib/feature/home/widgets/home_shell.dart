import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:brownyplus/res/styles/app_text_styles.dart';

class HomeShell extends StatefulWidget {
  final Widget body;
  final int currentIndex;

  const HomeShell({super.key, required this.body, required this.currentIndex});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell>
    with SingleTickerProviderStateMixin {
  bool _isMenuOpen = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
      if (_isMenuOpen) {
        _animController.forward();
      } else {
        _animController.reverse();
      }
    });
  }

  void _closeMenu() {
    if (_isMenuOpen) {
      setState(() {
        _isMenuOpen = false;
        _animController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bareBackground,
      body: Stack(
        children: [
          widget.body,
          // Overlay dim
          if (_isMenuOpen)
            GestureDetector(
              onTap: _closeMenu,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Container(color: AppColors.overlay),
              ),
            ),
          // FAB Menu Items
          _FabMenuOverlay(scaleAnim: _scaleAnim, onItemTap: _closeMenu),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Transform.translate(
        offset: const Offset(0, 12),
        child: AnimatedRotation(
          turns: _isMenuOpen ? 0.125 : 0,
          duration: const Duration(milliseconds: 280),
          child: Container(
            width: AppDims.size_65,
            height: AppDims.size_65,
            decoration: const BoxDecoration(
              ///กรอบปุ่มกลาง
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(AppDims.size_5),
              child: FloatingActionButton(
                onPressed: _toggleMenu,
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 4,
                shape: const CircleBorder(),
                child: Icon(Icons.add, size: AppDims.size_33),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: AppColors.white,
        elevation: 8,
        shadowColor: AppColors.black.withValues(alpha: 0.08),
        padding: EdgeInsets.zero,
        notchMargin: 8,
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: AppDims.size_60,
            child: Row(
              children: [
                _NavItem(
                  label: 'หน้าหลัก',
                  svgPath: Assets.svg.icHome,
                  selected: widget.currentIndex == 0,
                  onTap: () {},
                ),
                _NavItem(
                  label: 'ร้าน',
                  svgPath: Assets.svg.icShop,
                  selected: widget.currentIndex == 1,
                  onTap: () {},
                ),
                SizedBox(width: AppDims.size_60),
                _NavItem(
                  label: 'สแกน',
                  svgPath: Assets.svg.icScan,
                  selected: widget.currentIndex == 2,
                  onTap: () {},
                ),
                _NavItem(
                  label: 'กระเป๋าเงิน',
                  svgPath: Assets.svg.icWallet,
                  selected: widget.currentIndex == 3,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FabMenuOverlay extends StatelessWidget {
  final Animation<double> scaleAnim;
  final VoidCallback onItemTap;

  const _FabMenuOverlay({required this.scaleAnim, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenWidth = mq.size.width;
    final screenHeight = mq.size.height;
    final bottomPadding = mq.viewPadding.bottom; // safe area

    final centerX = screenWidth / 2;

    // Responsive: nav bar 60 + safe area + FAB half-height
    const navBarHeight = 50.0;
    final fabCenterY = navBarHeight + bottomPadding + 28.0;
    final baseY = screenHeight - fabCenterY;

    // Circle sizes
    const sideRadius = 38.0; // แจ้งเรื่อง / สต็อก
    const centerRadius = 38.0; // ชัก อบ พับ

    // Distances — push items higher and closer
    const sideHorizontal = 70.0;
    const sideVertical = 78.0; // raised well above FAB
    const centerVertical = 120.0; // straight up higher

    final items = [
      _FabMenuItemData(
        label: 'แจ้งเรื่อง',
        svgPath: Assets.svg.icChat,
        iconColor: AppColors.primary,
        bgColor: AppColors.white,
        radius: sideRadius,
        dx: centerX - sideHorizontal,
        dy: baseY - sideVertical,
      ),
      _FabMenuItemData(
        label: 'ชัก อบ พับ',
        logoPath: Assets.png.b.path,
        iconColor: AppColors.primary,
        bgColor: AppColors.white,
        radius: centerRadius,
        dx: centerX,
        dy: baseY - centerVertical,
        isCenter: true,
      ),
      _FabMenuItemData(
        label: 'สต็อก',
        svgPath: Assets.svg.icBox,
        iconColor: AppColors.primary,
        bgColor: AppColors.white,
        radius: sideRadius,
        dx: centerX + sideHorizontal,
        dy: baseY - sideVertical,
      ),
    ];

    return AnimatedBuilder(
      animation: scaleAnim,
      builder: (context, _) {
        return Stack(
          children: items.map((item) {
            final totalW = item.radius * 2;
            const labelOffset = 6.0;
            return Positioned(
              left: item.dx - item.radius,
              top: item.dy - item.radius,
              child: ScaleTransition(
                scale: scaleAnim,
                alignment: Alignment.bottomCenter,
                child: _FabMenuItemWidget(
                  item: item,
                  totalW: totalW,
                  labelOffset: labelOffset,
                  onTap: () {
                    onItemTap();
                    if (item.label == 'แจ้งเรื่อง') {
                      context.push('/service_page?tab=report');
                    } else if (item.label == 'ชัก อบ พับ') {
                      context.push('/service_page?tab=wash');
                    } else if (item.label == 'สต็อก') {
                      context.push('/service_page?tab=stock');
                    }
                  },
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────
class _FabMenuItemData {
  final String label;
  final String? svgPath;
  final String? logoPath;
  final Color iconColor;
  final Color bgColor;
  final double radius;
  final double dx;
  final double dy;
  final bool isCenter;

  const _FabMenuItemData({
    required this.label,
    this.svgPath,
    this.logoPath,
    required this.iconColor,
    required this.bgColor,
    required this.radius,
    required this.dx,
    required this.dy,
    this.isCenter = false,
  });
}

// ─────────────────────────────────────────────
// Menu Item Widget
// ─────────────────────────────────────────────
class _FabMenuItemWidget extends StatelessWidget {
  final _FabMenuItemData item;
  final double totalW;
  final double labelOffset;
  final VoidCallback onTap;

  const _FabMenuItemWidget({
    required this.item,
    required this.totalW,
    required this.labelOffset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
        // TODO: handle navigation per item
      },
      child: Container(
        width: totalW,
        height: totalW,
        decoration: BoxDecoration(
          color: item.bgColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.18),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(),
            AppDims.vericalPadding_4,
            Text(
              item.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: item.iconColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    // Center item: show BrownyPlus logo image
    if (item.isCenter && item.logoPath != null) {
      return Image.asset(
        item.logoPath!,
        width: item.radius * 1.0,
        height: item.radius * 1.0,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => Text(
          'B+',
          style: AppTextStyles.headlineLarge.copyWith(
            color: item.iconColor,
            fontWeight: FontWeight.w900,
            fontSize: 22,
          ),
        ),
      );
    }

    // SVG icon
    if (item.svgPath != null) {
      return SvgPicture.asset(
        item.svgPath!,
        width: item.radius * 0.75,
        height: item.radius * 0.75,
        colorFilter: ColorFilter.mode(item.iconColor, BlendMode.srcIn),
      );
    }

    return const SizedBox.shrink();
  }
}

// ─────────────────────────────────────────────
// Bottom Nav Item
// ─────────────────────────────────────────────
class _NavItem extends StatelessWidget {
  final String label;
  final String svgPath;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.svgPath,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textSecondary;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                svgPath,
                width: AppDims.size_28,
                height: AppDims.size_28,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              AppDims.vericalPadding_2,
              Text(
                label,
                style: AppTextStyles.labelLarge.copyWith(
                  fontSize: 14,
                  color: color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
