import 'package:flutter/material.dart';
import 'package:brownyplus/core/res/colors/app_colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
      );
}

