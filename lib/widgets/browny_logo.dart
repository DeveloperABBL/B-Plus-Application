import 'package:flutter/material.dart';

class BrownyLogo extends StatelessWidget {
  const BrownyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // โลโก้หลัก
        Image.asset(
          'assets/images/BrownyPlusLogo.png',
          width: 140,
          height: 140,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
        // ชื่อแอป
        Text(
          'Browny+',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
        ),
      ],
    );
  }
}

