import 'package:flutter/material.dart';

class HomeShell extends StatelessWidget {
  final Widget body;
  final int currentIndex;

  const HomeShell({
    super.key,
    required this.body,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF15B34A),
        foregroundColor: Colors.white,
        elevation: 0,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _NavItem(
                label: 'หน้าแรก',
                icon: Icons.home_rounded,
                selected: currentIndex == 0,
                onTap: () {},
              ),
              _NavItem(
                label: 'ร้าน',
                icon: Icons.store_rounded,
                selected: currentIndex == 1,
                onTap: () {},
              ),
              const SizedBox(width: 72),
              _NavItem(
                label: 'สแกน',
                icon: Icons.qr_code_scanner_rounded,
                selected: currentIndex == 2,
                onTap: () {},
              ),
              _NavItem(
                label: 'การเงิน',
                icon: Icons.account_balance_wallet_rounded,
                selected: currentIndex == 3,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
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
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: color,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

