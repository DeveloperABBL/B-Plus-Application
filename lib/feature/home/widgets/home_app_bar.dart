import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  final String title;
  final String subtitle;

  const HomeAppBar({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xFFE8F5E9),
          foregroundColor: Color(0xFF15B34A),
          child: Icon(Icons.person_rounded),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF757575),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        _IconPillButton(
          icon: Icons.calendar_month_rounded,
          onPressed: () {},
        ),
        const SizedBox(width: 8),
        _IconPillButton(
          icon: Icons.notifications_none_rounded,
          onPressed: () {},
        ),
      ],
    );
  }
}

class _IconPillButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _IconPillButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 40,
      child: Material(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onPressed,
          child: Icon(icon, size: 22, color: const Color(0xFF424242)),
        ),
      ),
    );
  }
}

