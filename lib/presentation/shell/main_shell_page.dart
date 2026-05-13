import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/mood_page.dart';
import '../pages/nutrition_page.dart';
import '../pages/plan_page.dart';
import '../pages/profile_page.dart';
import '../providers/bottom_nav_notifier.dart';
import '../widgets/main_shell_bottom_bar.dart';

/// Root shell: bottom navigation with four separate pages.
class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key});

  static final List<Widget> _tabPages = <Widget>[
    const NutritionPage(),
    const PlanPage(),
    const MoodPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<BottomNavNotifier>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(index: nav.currentIndex, children: _tabPages),
      bottomNavigationBar: const MainShellBottomBar(),
    );
  }
}
