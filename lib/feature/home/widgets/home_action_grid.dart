import 'package:flutter/material.dart';

class HomeActionGrid extends StatelessWidget {
  const HomeActionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = <_Action>[
      const _Action(
        imagePath: 'assets/images/home_menu/create_order.png',
      ),
      const _Action(
        imagePath: 'assets/images/home_menu/task.png',
      ),
      const _Action(
        imagePath: 'assets/images/home_menu/review.png',
      ),
      const _Action(
        imagePath: 'assets/images/home_menu/promotion.png',
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
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {},
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.asset(
            action.imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _Action {
  final String imagePath;

  const _Action({required this.imagePath});
}
