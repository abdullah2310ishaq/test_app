import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../painters/hydration_gauge_painter.dart';
import '../providers/nutrition_insights_notifier.dart';
import '../widgets/nutrition_calendar_bottom_sheet.dart';
import '../widgets/nutrition_week_calendar_header.dart';

bool _isLocalNight() {
  final h = DateTime.now().hour;
  return h < 6 || h >= 19;
}

class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  static const double _appBarToolbarHeight = 56;

  @override
  Widget build(BuildContext context) {
    final insights = context.watch<NutritionInsightsNotifier>();

    final baseDark = ThemeData(
      brightness: Brightness.dark,
      fontFamily: AppFonts.family,
      useMaterial3: true,
    );
    final textTheme = baseDark.textTheme.apply(
      fontFamily: AppFonts.family,
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: textTheme,
        scaffoldBackgroundColor: AppColors.dashboardBackground,
        dividerColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.dashboardBackground,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.dashboardBackground,
          elevation: 0,
          toolbarHeight: _appBarToolbarHeight.h,
          centerTitle: true,
          titleSpacing: 0,
          leadingWidth: 48.w,
          leading: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 48.w, minHeight: 48.h),
            onPressed: () {},
            icon: SvgPicture.asset(
              'assets/not_bell.svg',
              width: 24.sp,
              height: 24.sp,
            ),
          ),
          title: const _NutritionAppBarWeekCenter(),
          actions: const [_AppBarTrailingBalance()],
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const NutritionWeekCalendarHeader(includeWeekPickerRow: false),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 6.h, bottom: 10.h),
                  child: const _WorkoutsCapsuleAccent(),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 18.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _WorkoutsHeaderRow(),
                      SizedBox(height: 10.h),
                      _WorkoutCard(
                        workoutDateLine: insights.workoutCardDateLine,
                      ),
                      SizedBox(height: 18.h),
                      Text(
                        'My Insights',
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _InsightsTopRow(insights: insights),
                      SizedBox(height: 10.h),
                      _HydrationCard(insights: insights),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Same width as [leading] so the centered title sits in true screen center.
class _AppBarTrailingBalance extends StatelessWidget {
  const _AppBarTrailingBalance();

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 48.w, height: 48.h);
  }
}

class _NutritionAppBarWeekCenter extends StatelessWidget {
  const _NutritionAppBarWeekCenter();

  @override
  Widget build(BuildContext context) {
    final insights = context.watch<NutritionInsightsNotifier>();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => NutritionCalendarBottomSheet.show(context),
        borderRadius: BorderRadius.circular(8.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/top_weeek.svg',
                width: 20.sp,
                height: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                insights.weekLabel,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textPrimary,
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkoutsHeaderRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Workouts',
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: Offset(-4.w, 0),
              child: SvgPicture.asset(
                _isLocalNight() ? 'assets/moon.svg' : 'assets/sun.svg',
                width: 18.sp,
                height: 18.sp,
                colorFilter: const ColorFilter.mode(
                  AppColors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              '9°',
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WorkoutsCapsuleAccent extends StatelessWidget {
  const _WorkoutsCapsuleAccent();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44.w,
      height: 14.h,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Align(
            child: Container(
              width: 36.w,
              height: 7.h,
              decoration: BoxDecoration(
                color: AppColors.bottomSheetBackground,
                borderRadius: BorderRadius.circular(26.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({required this.workoutDateLine});

  final String workoutDateLine;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.workoutCard,
        borderRadius: BorderRadius.circular(12.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4.w,
              decoration: const BoxDecoration(color: AppColors.accentTeal),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 13.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$workoutDateLine - 25m - 30m',
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: 11.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            'Upper Body',
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: AppColors.textPrimary,
                      size: 20.sp,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightsTopRow extends StatelessWidget {
  const _InsightsTopRow({required this.insights});

  final NutritionInsightsNotifier insights;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _CaloriesCard(insights: insights)),
          SizedBox(width: 10.w),
          Expanded(child: _WeightCard(insights: insights)),
        ],
      ),
    );
  }
}

class _CaloriesCard extends StatelessWidget {
  const _CaloriesCard({required this.insights});

  final NutritionInsightsNotifier insights;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.insightCard,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${insights.caloriesConsumed}',
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  'Calories',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 12.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Text(
            '${insights.caloriesRemaining} Remaining',
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 11.sp,
              color: AppColors.textMuted,
            ),
          ),
          SizedBox(height: 11.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0',
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 11.sp,
                  color: AppColors.textMuted,
                ),
              ),
              Text(
                '${NutritionInsightsNotifier.caloriesGoal}',
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 11.sp,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: insights.caloriesProgress,
              minHeight: 5.h,
              backgroundColor: AppColors.progressTrack,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.accentTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightCard extends StatelessWidget {
  const _WeightCard({required this.insights});

  final NutritionInsightsNotifier insights;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.insightCard,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${insights.weightKg}',
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: 4.w),
              Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Text(
                  'kg',
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 12.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Container(
                width: 20.w,
                height: 20.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.trendGreen,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.north_east,
                  size: 12.sp,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                insights.weightTrendLabel,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.trendGreen,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            'Weight',
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 12.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HydrationCard extends StatelessWidget {
  const _HydrationCard({required this.insights});

  final NutritionInsightsNotifier insights;

  @override
  Widget build(BuildContext context) {
    final pct = (insights.hydrationFraction * 100).round();
    final gaugeH = 108.h;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.insightCard,
        borderRadius: BorderRadius.circular(12.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 10.w, 12.h),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 5,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: gaugeH),
                        child: FittedBox(
                          alignment: Alignment.topLeft,
                          fit: BoxFit.scaleDown,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$pct%',
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.accentBlue,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                'Hydration',
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              GestureDetector(
                                onTap: insights.logHydrationNow,
                                behavior: HitTestBehavior.opaque,
                                child: Text(
                                  'Log Now',
                                  style: TextStyle(
                                    fontFamily: AppFonts.family,
                                    fontSize: 11.sp,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  SizedBox(
                    width: 28.w,
                    height: gaugeH,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: HydrationGaugeLayout.tickTopY(gaugeH) - 2.h,
                          right: 0,
                          child: Text(
                            '2 L',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                              height: 1.0,
                            ),
                          ),
                        ),
                        Positioned(
                          top:
                              HydrationGaugeLayout.tickBottomKeyY(gaugeH) - 5.h,
                          right: 0,
                          child: Text(
                            '0 L',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 2.w),
                  SizedBox(
                    width: 12.w,
                    height: gaugeH,
                    child: CustomPaint(
                      painter: HydrationGaugePainter(
                        progress: insights.hydrationFraction,
                        activeBlue: AppColors.accentBlue,
                        inactiveDash: AppColors.hydrationGaugeMuted,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      height: gaugeH,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: -14.w,
                            right: 0,
                            top: HydrationGaugeLayout.alignCenterOnTick(
                              HydrationGaugeLayout.tickBottomKeyY(gaugeH),
                              16.h,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: AppColors.textMuted.withValues(
                                      alpha: 0.45,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  '${insights.hydrationLoggedMl}ml',
                                  style: TextStyle(
                                    fontFamily: AppFonts.family,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 40.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.hydrationLogBar,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
            ),
            child: Text(
              insights.hydrationLogMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
