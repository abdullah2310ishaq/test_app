import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../providers/mood_selection_notifier.dart';
import '../widgets/mood_ring_selector.dart';

/// Mood check-in: blurred sweep ring, polar thumb, quadrant assets, Continue CTA.
class MoodPage extends StatelessWidget {
  const MoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dashboardBackground,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: double.infinity,
              height: 400.h,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    // Slightly below top so glow reaches “Moment?” line.
                    center: const Alignment(0, -0.52),
                    radius: 1.42,
                    colors: [AppColors.moodHeaderGlowNavy, Colors.transparent],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mood',
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Start your day',
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        'How are you feeling at the\nMoment?',
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const MoodRingSelector(),
                    SizedBox(height: 28.h),
                    Selector<MoodSelectionNotifier, String>(
                      selector: (_, n) => n.mood.label,
                      builder: (context, label, _) {
                        return Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SafeArea(
                top: false,
                left: false,
                right: false,
                minimum: EdgeInsets.fromLTRB(24.w, 0, 24.w, 12.h),
                child: FilledButton(
                  onPressed: () {
                    final mood = context.read<MoodSelectionNotifier>().mood;
                    final messenger = ScaffoldMessenger.of(context);
                    messenger.hideCurrentSnackBar();
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          'Mood saved Now I now that you are: ${mood.label}',
                          style: TextStyle(fontFamily: AppFonts.family),
                        ),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    minimumSize: Size(double.infinity, 52.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26.r),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
