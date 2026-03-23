import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      body: Stack(
        children: [
          widget.body,
          // Overlay dim
          if (_isMenuOpen)
            GestureDetector(
              onTap: _closeMenu,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Container(color: Colors.black.withValues(alpha: 0.45)),
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
            width: 65,
            height: 65,
            decoration: const BoxDecoration(
              ///กรอบปุ่มกลาง
              color: Color.fromARGB(255, 255, 255, 255),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: FloatingActionButton(
                onPressed: _toggleMenu,
                backgroundColor: const Color(0xFF15B34A),
                foregroundColor: Colors.white,
                elevation: 4,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, size: 34),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        padding: EdgeInsets.zero,
        // shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                _NavItem(
                  label: 'หน้าหลัก',
                  svgPath: 'assets/svg/ic_home.svg',
                  selected: widget.currentIndex == 0,
                  onTap: () {},
                ),
                _NavItem(
                  label: 'ร้าน',
                  svgPath: 'assets/svg/ic_shop.svg',
                  selected: widget.currentIndex == 1,
                  onTap: () {},
                ),
                const SizedBox(width: 60),
                _NavItem(
                  label: 'สแกน',
                  svgPath: 'assets/svg/ic_scan.svg',
                  selected: widget.currentIndex == 2,
                  onTap: () {},
                ),
                _NavItem(
                  label: 'กระเป๋าเงิน',
                  svgPath: 'assets/svg/ic_wallet.svg',
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
        svgPath: 'assets/svg/ic_chat.svg',
        iconColor: const Color(0xFF15B34A),
        bgColor: Colors.white,
        radius: sideRadius,
        dx: centerX - sideHorizontal,
        dy: baseY - sideVertical,
      ),
      _FabMenuItemData(
        label: 'ชัก อบ พับ',
        logoPath: 'assets/png/b+.png',
        iconColor: const Color(0xFF15B34A),
        bgColor: Colors.white,
        radius: centerRadius,
        dx: centerX,
        dy: baseY - centerVertical,
        isCenter: true,
      ),
      _FabMenuItemData(
        label: 'สต็อก',
        svgPath: 'assets/svg/ic_box.svg',
        iconColor: const Color(0xFF2EC065),
        bgColor: Colors.white,
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
            final labelOffset = 6.0;
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
                  onTap: onItemTap,
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
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIcon(),
            const SizedBox(height: 4),
            Text(
              item.label,
              style: TextStyle(
                color: item.iconColor,
                fontSize: 11,
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
          style: TextStyle(
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
    final color = selected ? const Color(0xFF15B34A) : const Color(0xFF9E9E9E);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                svgPath,
                width: 28,
                height: 28,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
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
