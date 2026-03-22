import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dotted_line/dotted_line.dart';

class HomeCheckinCard extends StatelessWidget {
  const HomeCheckinCard({super.key});

  @override
  Widget build(BuildContext context) {
    const cardRadius = 5.0;
    const outerBg = Color(0xFFE9FFDF);
    const outerBorder = Color(0xFFCFEFBD);

    return Container(
      decoration: BoxDecoration(
        color: outerBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: outerBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Column(
          children: [
            // Header strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              color: const Color(0xFFDDF9CE),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFFBFEFC3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SvgPicture.asset(
                      'assets/svg/ic_note.svg',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'บันทึกเวลาเข้า-ออกงาน',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const _DashedDivider(color: Color(0xFFB7E0A5)),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                children: [
                  SizedBox(
                    height: 140,
                    child: Row(
                      children: [
                        Expanded(
                          child: _DateCard(
                            radius: cardRadius,
                            month: 'กุมภาพันธ์',
                            day: '18',
                            timeIn: '9.50',
                          ),
                        ),
                        const SizedBox(width: 8),
                        const _VerticalDashedDivider(color: Color(0xFFB7E0A5)),
                        const SizedBox(width: 8),
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topCenter,
                          children: [
                            Image.asset(
                              'assets/images/clock/clockin.png',
                              height: 150,
                            ),
                            Positioned(
                              top: -8,
                              child: Image.asset(
                                'assets/images/clock/repeat_badge.png',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topCenter,
                          children: [
                            Image.asset(
                              'assets/images/clock/clocked_out.png',
                              height: 150,
                            ),
                            // Image.asset(
                            //   'assets/images/clock/clockout.png',
                            //   height: 150,
                            // ),
                            // Positioned(
                            //   top: -8,
                            //   child: Image.asset(
                            //     'assets/images/clock/repeat_badge.png',
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  _BottomInfoBar(
                    radius: cardRadius,
                    leadingIcon: Icons.calendar_month_rounded,
                    text: '14.00 น. : ซ่อมบำรุงร้าน',
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomInfoBar extends StatelessWidget {
  final double radius;
  final IconData leadingIcon;
  final String text;
  final VoidCallback onTap;

  const _BottomInfoBar({
    required this.radius,
    required this.leadingIcon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFF3CF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: const BorderSide(color: Color(0xFFFFE7AB), width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFE7AB),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/svg/ic_calendar_yellow.svg',
                  width: 18,
                  height: 18,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF6D4C00),
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Color(0xFF8D6E63),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateCard extends StatelessWidget {
  final double radius;
  final String month;
  final String day;
  final String timeIn;

  const _DateCard({
    required this.radius,
    required this.month,
    required this.day,
    required this.timeIn,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius * 1.5),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      padding: const EdgeInsets.all(5),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFDCF8C6),
              borderRadius: BorderRadius.circular(radius),
            ),
            alignment: Alignment.center,
            child: Text(
              month,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF616161),
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const _DashedDivider(color: Color(0xFFE0E0E0)),
          const Spacer(),
          Text(
            day,
            style: const TextStyle(
              fontSize: 42,
              height: 1,
              fontWeight: FontWeight.w600,
              color: Color(0xFF555555),
            ),
          ),
          const Spacer(),
          const Divider(color: Color(0xFFE0E0E0), height: 1, thickness: 1),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(radius),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        timeIn,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF616161),
                        ),
                      ),
                      const SizedBox(height: 1),
                      const Text(
                        'เวลาเข้า',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 20, color: const Color(0xFFE0E0E0)),
                const Expanded(
                  child: Column(
                    children: [
                      Text(
                        '-',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFBDBDBD),
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        'เวลาออก',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFBDBDBD),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PunchCard extends StatelessWidget {
  final double radius;
  final Color backgroundColor;
  final Color bottomBarColor;
  final String bottomText;
  final _TopBadge? badge;
  final _PrimaryPill? primaryButton;

  const _PunchCard({
    required this.radius,
    required this.backgroundColor,
    required this.bottomBarColor,
    required this.bottomText,
    required this.badge,
    required this.primaryButton,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(color: backgroundColor),
              child: const Center(
                child: Icon(Icons.image_outlined, color: Color(0x4D000000)),
              ),
            ),
          ),
          if (badge != null)
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: badge!.color,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    badge!.text,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          if (primaryButton != null)
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: _PrimaryPill(
                text: primaryButton!.text,
                background: primaryButton!.background,
                foreground: primaryButton!.foreground,
              ),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: bottomBarColor.withValues(alpha: 0.85),
              child: Center(
                child: Text(
                  bottomText,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: bottomBarColor == const Color(0xFF15B34A)
                        ? Colors.white
                        : const Color(0xFF616161),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryPill extends StatelessWidget {
  final String text;
  final Color background;
  final Color foreground;

  const _PrimaryPill({
    required this.text,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.w900, color: foreground),
        ),
      ),
    );
  }
}

class _TopBadge {
  final String text;
  final Color color;

  const _TopBadge({required this.text, required this.color});
}

class _DashedDivider extends StatelessWidget {
  final Color color;

  const _DashedDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return DottedLine(
      direction: Axis.horizontal,
      lineLength: double.infinity,
      lineThickness: 2.0,
      dashLength: 8.0,
      dashColor: color,
      dashGapLength: 6.0,
    );
  }
}

class _VerticalDashedDivider extends StatelessWidget {
  final Color color;

  const _VerticalDashedDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return DottedLine(
      direction: Axis.vertical,
      lineLength: double.infinity,
      lineThickness: 2.0,
      dashLength: 8.0,
      dashColor: color,
      dashGapLength: 6.0,
    );
  }
}
