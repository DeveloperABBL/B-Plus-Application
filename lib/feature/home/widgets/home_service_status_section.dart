import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeServiceStatusSection extends StatelessWidget {
  const HomeServiceStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_ServiceItem>[
      const _ServiceItem(
        title: 'บริษัทนีย์ ส. - 0800000000',
        statusText: 'สถานะ : ดำเนินการสำเร็จ',
        serviceText: 'บริการ : พับ',
        imagePath: 'assets/images/order/order1.png',
        statusTone: _StatusTone.success,
      ),
      const _ServiceItem(
        title: 'โจจิ - 0800000000',
        statusText: 'สถานะ : กำลังดำเนินการ',
        serviceText: 'บริการ : อบร้อนต่ำ + 24 นาที (เครื่องอบ 1)',
        imagePath: 'assets/images/order/order2.png',
        statusTone: _StatusTone.warning,
      ),
      const _ServiceItem(
        title: 'โจจิ - 0800000000',
        statusText: 'สถานะ : รอดำเนินการ',
        serviceText: 'บริการ : -',
        imagePath: 'assets/images/order/order3.png',
        statusTone: _StatusTone.warning,
      ),
    ];

    return _SectionCard(
      icon: SvgPicture.asset(
        'assets/svg/ic_refresh_double.svg',
        width: 24,
        height: 24,
      ),
      title: 'สถานะการบริการซัก อบ พับ',
      child: Column(
        children: [
          ...items.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ServiceRow(item: e),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF15B34A),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'แสดงเพิ่มเติม',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  Icon(Icons.keyboard_arrow_down_rounded, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  final _ServiceItem item;

  const _ServiceRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final tone = item.statusTone;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(14),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(item.imagePath, fit: BoxFit.cover),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SvgPicture.asset(
                      'assets/svg/arrow_right.svg',
                      width: 24,
                      height: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.statusText,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF616161),
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
                Text(
                  item.serviceText,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF616161),
                    fontWeight: FontWeight.w500,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 8),
                _StatusChip(tone: tone),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final _StatusTone tone;

  const _StatusChip({required this.tone});

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (tone) {
      _StatusTone.success => (
        const Color(0xFFD8FDE8),
        const Color(0xFF15B51F),
        'ชำระแล้ว',
      ),
      _StatusTone.warning => (
        const Color(0xFFFFF8E1),
        const Color(0xFF8D6E00),
        'ชำระโดยผู้จัดการสาขา',
      ),
      _StatusTone.neutral => (
        const Color(0xFFF5F5F5),
        const Color(0xFF616161),
        'รอดำเนินการ',
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: fg),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? icon;

  const _SectionCard({required this.title, required this.child, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 8)],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

enum _StatusTone { success, warning, neutral }

class _ServiceItem {
  final String title;
  final String statusText;
  final String serviceText;
  final String imagePath;
  final _StatusTone statusTone;

  const _ServiceItem({
    required this.title,
    required this.statusText,
    required this.serviceText,
    required this.imagePath,
    required this.statusTone,
  });
}
