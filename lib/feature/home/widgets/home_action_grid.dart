import 'package:flutter/material.dart';

class HomeActionGrid extends StatelessWidget {
  const HomeActionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = <_Action>[
      const _Action(
        label: 'สร้างออเดอร์\nซัก อบ พับ',
        icon: Icons.local_laundry_service_rounded,
      ),
      const _Action(
        label: 'งานทั้งหมด',
        icon: Icons.list_alt_rounded,
      ),
      const _Action(
        label: 'รีวิว',
        icon: Icons.people_alt_rounded,
      ),
      const _Action(
        label: 'โปรโมชั่น',
        icon: Icons.local_offer_rounded,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'เมนูด่วน',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - 10) / 2;
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final a in actions)
                  SizedBox(
                    width: itemWidth,
                    child: _ActionTile(action: a),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final _Action action;

  const _ActionTile({required this.action});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE8F5E9),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Icon(action.icon, color: const Color(0xFF15B34A)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  action.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Action {
  final String label;
  final IconData icon;

  const _Action({required this.label, required this.icon});
}

