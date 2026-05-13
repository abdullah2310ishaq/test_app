import 'package:flutter/material.dart';

/// Design tokens for colors used across the app.
abstract final class AppColors {
  static const Color primary = Color(0xFF6B4EFF);
  static const Color splashBackground = Color(0xFFF5F5F7);

  // Dark fitness / nutrition dashboard
  static const Color dashboardBackground = Color(0xFF000000);
  static const Color dateCircleIdle = Color(0xFF1A1A1A);
  static const Color workoutCard = Color(0xFF121212);
  static const Color insightCard = Color(0xFF1C1C1E);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentTeal = Color(0xFF4DB6AC);
  static const Color accentBlue = Color(0xFF42A5F5);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9E9E9E);

  /// Bottom nav: inactive label + icon tint.
  static const Color navBarInactive = Color(0xFF66667E);
  static const Color textMuted = Color(0xFF757575);
  static const Color trendGreen = Color(0xFF4CAF50);
  static const Color hydrationBanner = Color(0xFF4DB6AC);
  static const Color progressTrack = Color(0xFF2C2C2E);

  /// Hydration gauge: inactive dashes (muted blue-grey).
  static const Color hydrationGaugeMuted = Color(0xFF455A64);

  /// Bottom log strip (darker teal than [hydrationBanner]).
  static const Color hydrationLogBar = Color(0xFF00695C);

  /// Calendar bottom sheet (slightly lifted from pure black).
  static const Color bottomSheetBackground = Color(0xFF1A1B1E);
  static const Color sheetDragHandle = Color(0xFF4A4A4E);

  /// Plan / training calendar accents.
  static const Color planTealLine = Color(0xFF26A69A);
  static const Color planBadgeLegs = Color(0xFF7E57C2);

  /// Plan workout cards: arms category chip (green family).
  static const Color planWorkoutChipArms = Color(0xFF2E7D32);

  /// Plan workout cards: leg category chip (dark tag + light blue label).
  static const Color planWorkoutChipLegBg = Color(0xFF15294A);
  static const Color planWorkoutChipLegFg = Color(0xFF90CAF9);
  static const Color planNavTopBorder = Color(0xFF2C2C2E);

  /// Training calendar app bar underline (indigo).
  static const Color planAppBarAccentLine = Color(0xFF4A4ED7);

  /// Week header band behind "Week x/y" + range (slightly above pure black).
  static const Color planWeekHeaderBackground = Color(0xFF121212);

  /// Plan list secondary labels (iOS-style grey).
  static const Color planSecondaryText = Color(0xFF8E8E93);

  /// Teal separator between stacked week blocks (matches mood ring teal).
  static const Color planWeekSectionDivider = Color(0xFF6EB9AD);

  // Mood ring (sweep quadrants + thumb)
  static const Color moodRingTeal = Color(0xFF6EB9AD);
  static const Color moodRingPurple = Color(0xFFC9BBEF);
  static const Color moodRingPink = Color(0xFFF28DB3);
  static const Color moodRingOrange = Color(0xFFF99955);
  static const Color moodThumb = Color(0xFFFDFDFD);
  static const Color moodCenterCard = Color(0xFFFFD54F);
  static const Color moodNavIndicator = Color(0xFFC9BBEF);

  /// Mood header: deep navy radial spotlight (`#1A237E` at ~40% opacity → transparent).
  static const Color moodHeaderGlowNavy = Color(0x661A237E);
}
