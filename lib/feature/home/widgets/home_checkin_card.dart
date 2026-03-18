import 'package:flutter/material.dart';

class HomeCheckinCard extends StatelessWidget {
  const HomeCheckinCard({super.key});

  @override
  Widget build(BuildContext context) {
    const cardRadius = 14.0;
    const outerBg = Color(0xFFE9FFDF);
    const outerBorder = Color(0xFFCFEFBD);

    return Container(
      decoration: BoxDecoration(
        color: outerBg,
        borderRadius: BorderRadius.circular(18),
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
        borderRadius: BorderRadius.circular(18),
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
                    child: const Icon(
                      Icons.description_outlined,
                      size: 16,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'บันทึกเวลาเข้า-ออกงาน',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2E7D32),
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
                    height: 128,
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
                        const SizedBox(width: 10),
                        Expanded(
                          child: _PunchCard(
                            radius: cardRadius,
                            backgroundColor: const Color(0xFFCFEAFF),
                            bottomBarColor: const Color(0xFFB9D7EA),
                            bottomText: 'บันทึกเวลาเข้า',
                            badge: null,
                            primaryButton: null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _PunchCard(
                            radius: cardRadius,
                            backgroundColor: const Color(0xFFFFD3CC),
                            bottomBarColor: const Color(0xFF15B34A),
                            bottomText: 'บันทึกเวลาออก',
                            badge: const _TopBadge(
                              text: 'อย่าลืมนะ',
                              color: Color(0xFFEB5757),
                            ),
                            primaryButton: const _PrimaryPill(
                              text: 'บันทึกเวลาออก',
                              background: Color(0xFF15B34A),
                              foreground: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
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
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE7AB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(leadingIcon, color: const Color(0xFFB97900)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF6D4C00),
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF8D6E63)),
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: _DashedBorder(
        radius: radius - 2,
        color: const Color(0xFFBDBDBD),
        strokeWidth: 1.2,
        dashWidth: 6,
        dashGap: 4,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    month,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF616161),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                day,
                style: const TextStyle(
                  fontSize: 44,
                  height: 1,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF424242),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            timeIn,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF424242),
                            ),
                          ),
                          const SizedBox(height: 1),
                          const Text(
                            'เวลาเข้า',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            '--',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFBDBDBD),
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            'เวลาออก',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFBDBDBD),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
    return SizedBox(
      height: 2,
      child: CustomPaint(painter: _DashedLinePainter(color: color)),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 8.0;
    const dashGap = 6.0;
    var x = 0.0;

    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
      x += dashWidth + dashGap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _DashedBorder extends StatelessWidget {
  final Widget child;
  final double radius;
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;

  const _DashedBorder({
    required this.child,
    required this.radius,
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashGap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedRRectPainter(
        radius: radius,
        color: color,
        strokeWidth: strokeWidth,
        dashWidth: dashWidth,
        dashGap: dashGap,
      ),
      child: child,
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  final double radius;
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashGap;

  _DashedRRectPainter({
    required this.radius,
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashGap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        final extract = metric.extractPath(distance, next);
        canvas.drawPath(extract, paint);
        distance = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
    return oldDelegate.radius != radius ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashWidth != dashWidth ||
        oldDelegate.dashGap != dashGap;
  }
}
