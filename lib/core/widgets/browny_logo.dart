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
          width: 180,
          height: 180,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
