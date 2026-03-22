import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeServiceStatusSection extends StatelessWidget {
  const HomeServiceStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_ServiceItem>[
      const _ServiceItem(
        title: 'บริษัท ล. - 0800000000',
        statusText: 'สถานะ : ดำเนินการสำเร็จ',
        serviceText: 'บริการ : พับ',
        imagePath: 'assets/images/order/order1.png',
        statusTone: _StatusTone.success,
        actionLabel: 'ประเมินผล',
      ),
      const _ServiceItem(
        title: 'โวว - 0800000000',
        statusText: 'สถานะ : กำลังดำเนินการ + 24 นาที (เครื่องอบ 1)',
        serviceText: 'บริการ : ประเมินตัดจุดรอย',
        imagePath: 'assets/images/order/order2.png',
        statusTone: _StatusTone.warning,
        actionLabel: 'รายละเอียดการซัก',
      ),
      const _ServiceItem(
        title: 'โวว - 0800000000',
        statusText: 'สถานะ : รอดำเนินการ',
        serviceText: 'บริการ : ประเมินตัดจุดรอย',
        imagePath: 'assets/images/order/order3.png',
        statusTone: _StatusTone.neutral,
        actionLabel: 'รายละเอียดการซัก',
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
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              label: const Text('แสดงเพิ่มเติม'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF15B34A),
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(14),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(item.imagePath, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
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
                Row(
                  children: [
                    _StatusChip(tone: tone),
                    const Spacer(),
                    _ActionPill(label: item.actionLabel, onTap: () {}),
                  ],
                ),
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
        'สำเร็จ',
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

class _ActionPill extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionPill({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE8F5E9),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF15B34A),
            ),
          ),
        ),
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
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB9E2C6)),
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
  final String actionLabel;

  const _ServiceItem({
    required this.title,
    required this.statusText,
    required this.serviceText,
    required this.imagePath,
    required this.statusTone,
    required this.actionLabel,
  });
}
