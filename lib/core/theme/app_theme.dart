import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

/// Shared themes; dark tokens match the nutrition dashboard.
abstract final class AppTheme {
  AppTheme._();

  static ThemeData darkNutrition() {
    const family = AppFonts.family;
    final scheme = ColorScheme.dark(
      surface: AppColors.bottomSheetBackground,
      onSurface: AppColors.textPrimary,
      primary: AppColors.accentGreen,
      onPrimary: AppColors.textPrimary,
      secondary: AppColors.accentTeal,
      outline: AppColors.textMuted,
    );

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: family,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.dashboardBackground,
      canvasColor: AppColors.dashboardBackground,
      dialogTheme: const DialogThemeData(
        backgroundColor: AppColors.bottomSheetBackground,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        fontFamily: family,
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.bottomSheetBackground,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: AppColors.bottomSheetBackground,
      ),
    );
  }
}
