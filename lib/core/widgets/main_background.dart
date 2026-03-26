import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/icons/assets.gen.dart';

/// A reusable background widget for the BrownyPlus app.
/// It consists of a primary gradient and a pattern overlay.
class MainBackground extends StatelessWidget {
  const MainBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.07,
              child: Assets.png.patternBrowny.image(
                fit: BoxFit.cover,
                // Using 1.sw and 0.7.sh as seen in other implementations
                width: 1.sw,
                height: 0.7.sh,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Alias for MainBackground to maintain compatibility with existing code.
class BrownyBackground extends MainBackground {
  const BrownyBackground({super.key});
}
