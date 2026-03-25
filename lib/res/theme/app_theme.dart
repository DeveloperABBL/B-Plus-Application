import 'package:flutter/material.dart';
import 'package:brownyplus/res/colors/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    // ============================================================================
    // Card Theme
    // ============================================================================
    cardTheme: CardThemeData(
      color: AppColors.productBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.productStroke, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
    ),
  );
}
