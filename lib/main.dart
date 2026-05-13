import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_colors.dart';
import 'core/theme/app_fonts.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/bottom_nav_notifier.dart';
import 'presentation/providers/mood_selection_notifier.dart';
import 'presentation/providers/nutrition_insights_notifier.dart';
import 'presentation/providers/plan_calendar_notifier.dart';
import 'presentation/splash/splash_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => BottomNavNotifier()),
            ChangeNotifierProvider(create: (_) => MoodSelectionNotifier()),
            ChangeNotifierProvider(create: (_) => NutritionInsightsNotifier()),
            ChangeNotifierProvider(create: (_) => PlanCalendarNotifier()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Wellness',
            theme: _buildLightTheme(),
            darkTheme: AppTheme.darkNutrition(),
            home: child,
          ),
        );
      },
      child: const SplashPage(),
    );
  }
}

ThemeData _buildLightTheme() {
  const family = AppFonts.family;
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  );
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: family,
  );
  return base.copyWith(textTheme: base.textTheme.apply(fontFamily: family));
}
