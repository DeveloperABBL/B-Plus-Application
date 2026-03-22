import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeAppBar extends StatelessWidget {
  final String title;
  final String subtitle;

  const HomeAppBar({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/banner/Frame2087327902.png', // Temporary placeholder that looks like the dog in the banner
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  const Icon(Icons.person_rounded, color: Color(0xFF15B34A)),
            ),
          ),
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
                  fontSize: 20, // Slightly larger
                  fontWeight: FontWeight.w800, // Bolder
                ),
              ),
              const SizedBox(height: 1),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9E9E9E),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        _IconWithDot(
          iconPath: 'assets/svg/ic_calendar.svg',
          dotColor: const Color(0xFFFF4848), // Red dot
        ),
        const SizedBox(width: 15),
        _IconWithDot(
          iconPath: 'assets/svg/ic_bell.svg',
          dotColor: const Color(0xFFFF4848), // Red dot
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _IconWithDot extends StatelessWidget {
  final String iconPath;
  final Color dotColor;

  const _IconWithDot({required this.iconPath, required this.dotColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SvgPicture.asset(
          iconPath,
          width: 26,
          height: 26,
          colorFilter: const ColorFilter.mode(
            Color(0xFF15B34A),
            BlendMode.srcIn,
          ),
        ),
        Positioned(
          top: 0,
          right: -1,
          child: Container(
            width: 9,
            height: 9,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _IconPillButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _IconPillButton({required this.icon, required this.onPressed});

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
