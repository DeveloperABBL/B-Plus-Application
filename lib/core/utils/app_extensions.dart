import 'package:brownyplus/res/colors/app_colors.dart';
import 'package:brownyplus/res/dims/app_dims.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

extension AppBuildeContext on BuildContext {
  ThemeData get appTheme => Theme.of(this);
  TextTheme get textTheme => appTheme.textTheme;
  TextStyle get appBarTextThemeWhite => appTheme.textTheme.titleLarge!.copyWith(
    fontSize: AppDims.size_18.sp,
    color: AppColors.textWhite,
  );
  TextStyle get inputTextStyle => appTheme.textTheme.bodyLarge!.merge(
    GoogleFonts.prompt(
      fontSize: 14.sp,
    ),
  );

  String get languageCode => Localizations.localeOf(this).languageCode;
}

extension StringExtension on String? {
  String get orEmpty => this ?? '';

  String ifNullOrEmpty(String value) => orEmpty.isEmpty ? value : this!;

  String ifEmpty(String value) => orEmpty.isEmpty ? value : this!;

  String commaReplacer() => ifEmpty('').replaceAll(',', '');
}
