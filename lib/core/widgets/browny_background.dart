import 'package:flutter/material.dart';

class BrownyBackground extends StatelessWidget {
  const BrownyBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Transform.scale(
        scale: 3, // ขยาย 2 เท่า
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/png/PatternBrowny.png'),
              repeat: ImageRepeat.repeat,
              opacity: 0.1,
              alignment: Alignment.topLeft,
            ),
          ),
        ),
      ),
    );
  }
}
