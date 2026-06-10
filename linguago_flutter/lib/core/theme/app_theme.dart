import 'package:flutter/material.dart';
import 'package:linguago_flutter/core/constants/colors.dart';

/// App theme using bundled fonts (no CDN / gstatic fetch on web).
class AppTheme {
  AppTheme._();

  static const String fontFamily = 'PlusJakartaSans';

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      fontFamilyFallback: const ['Roboto', 'sans-serif'],
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPurple,
        surface: AppColors.white,
      ),
      scaffoldBackgroundColor: AppColors.white,
    );
  }
}
