import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../providers/bottom_nav_notifier.dart';

class MainShellBottomBar extends StatelessWidget {
  const MainShellBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<BottomNavNotifier>();
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Material(
      color: AppColors.dashboardBackground,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SizedBox(
          height: 56.h,
          child: Row(
            children: [
              _NavEntry(
                label: 'Nutrition',
                assetPath: 'assets/nutrition.svg',
                selected: nav.currentIndex == 0,
                onTap: () => context.read<BottomNavNotifier>().setIndex(0),
              ),
              _NavEntry(
                label: 'Plan',
                assetPath: 'assets/plan.svg',
                selected: nav.currentIndex == 1,
                onTap: () => context.read<BottomNavNotifier>().setIndex(1),
              ),
              _NavEntry(
                label: 'Mood',
                assetPath: 'assets/mood.svg',
                selected: nav.currentIndex == 2,
                onTap: () => context.read<BottomNavNotifier>().setIndex(2),
              ),
              _NavEntry(
                label: 'Profile',
                assetPath: 'assets/profile.svg',
                selected: nav.currentIndex == 3,
                onTap: () => context.read<BottomNavNotifier>().setIndex(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavEntry extends StatelessWidget {
  const _NavEntry({
    required this.label,
    required this.assetPath,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String assetPath;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.textPrimary : AppColors.navBarInactive;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.white12,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              assetPath,
              width: 24.sp,
              height: 24.sp,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
