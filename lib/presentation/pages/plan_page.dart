import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/date/calendar_week_helper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../providers/nutrition_insights_notifier.dart';
import '../providers/plan_calendar_notifier.dart';

class PlanDayDragData {
  const PlanDayDragData({required this.sourceDay});

  final DateTime sourceDay;
}

/// Dark training calendar: week header + seven equal cards, second week after teal divider.
class PlanPage extends StatelessWidget {
  const PlanPage({super.key});

  static const _dowShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  static const double _appBarToolbarHeight = 56;

  /// Every day row uses the same card height (filled or rest).
  static double _cardHeight() => 84.h;

  /// Hold longer than 1s, then drag to any day in the two visible weeks (swap supported).
  static const Duration _dragLongPressDelay = Duration(milliseconds: 1200);

  @override
  Widget build(BuildContext context) {
    final nutrition = context.watch<NutritionInsightsNotifier>();
    final plan = context.watch<PlanCalendarNotifier>();
    final anchorMonday = CalendarWeekHelper.mondayOfWeekContaining(
      nutrition.selectedDay,
    );
    final w = plan.selectedProgramWeekPairIndex;
    final week1Days = CalendarWeekHelper.weekDaysFrom(
      anchorMonday.add(Duration(days: 14 * w)),
    );
    final week2Days = CalendarWeekHelper.weekDaysFrom(
      anchorMonday.add(Duration(days: 14 * w + 7)),
    );

    return Scaffold(
      backgroundColor: AppColors.dashboardBackground,
      appBar: AppBar(
        backgroundColor: AppColors.dashboardBackground,
        elevation: 0,
        toolbarHeight: _appBarToolbarHeight.h,
        centerTitle: false,
        title: Text(
          'Training Calendar',
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final messenger = ScaffoldMessenger.of(context);
              messenger.hideCurrentSnackBar();
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    'Wait ? Wasnot it just for UI design.',
                    style: TextStyle(fontFamily: AppFonts.family),
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Text(
              'Save',
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.h),
          child: Container(
            height: 2.h,
            width: double.infinity,
            color: AppColors.planAppBarAccentLine,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: ListView(
          padding: EdgeInsets.only(bottom: 12.h),
          children: [
            _WeekSection(
              weekDays: week1Days,
              dragLongPressDelay: _dragLongPressDelay,
              dowLabels: _dowShort,
              cardHeight: _cardHeight(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Container(
                height: 2.h,
                width: double.infinity,
                color: AppColors.planWeekSectionDivider,
              ),
            ),
            _WeekSection(
              weekDays: week2Days,
              dragLongPressDelay: _dragLongPressDelay,
              dowLabels: _dowShort,
              cardHeight: _cardHeight(),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeekSection extends StatelessWidget {
  const _WeekSection({
    required this.weekDays,
    required this.dragLongPressDelay,
    required this.dowLabels,
    required this.cardHeight,
  });

  final List<DateTime> weekDays;
  final Duration dragLongPressDelay;
  final List<String> dowLabels;
  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    final plan = context.watch<PlanCalendarNotifier>();
    final weekTitle = CalendarWeekHelper.planWeekLabelFour(weekDays.first);
    final rangeLabel = CalendarWeekHelper.weekCalendarRangeLabel(
      weekDays.first,
    );
    final total = plan.totalMinutesForDays(weekDays);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: AppColors.planWeekHeaderBackground,
          padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      weekTitle,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      rangeLabel,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.planSecondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Total: ${total}min',
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.planSecondaryText,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            children: [
              for (var i = 0; i < weekDays.length; i++)
                _PlanDayRow(
                  day: weekDays[i],
                  dowLabel: dowLabels[weekDays[i].weekday - 1],
                  entry: plan.workoutOnDay(weekDays[i]),
                  cardHeight: cardHeight,
                  dragLongPressDelay: dragLongPressDelay,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanDayRow extends StatelessWidget {
  const _PlanDayRow({
    required this.day,
    required this.dowLabel,
    required this.entry,
    required this.cardHeight,
    required this.dragLongPressDelay,
  });

  final DateTime day;
  final String dowLabel;
  final PlanWorkoutEntry? entry;
  final double cardHeight;
  final Duration dragLongPressDelay;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IntrinsicHeight(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 56.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dowLabel,
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${day.day}',
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.planSecondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: SizedBox(
                    height: cardHeight,
                    child: DragTarget<PlanDayDragData>(
                      onWillAcceptWithDetails: (details) =>
                          PlanCalendarNotifier.dateKey(
                            details.data.sourceDay,
                          ) !=
                          PlanCalendarNotifier.dateKey(day),
                      onAcceptWithDetails: (details) {
                        context.read<PlanCalendarNotifier>().moveWorkoutBetween(
                          fromDay: details.data.sourceDay,
                          toDay: day,
                        );
                      },
                      builder: (context, candidate, rejected) {
                        final hovering = candidate.isNotEmpty;
                        final session = entry;
                        final card = _PlanWorkoutCard(
                          entry: session,
                          dropHighlight: hovering,
                        );
                        if (session == null) {
                          return card;
                        }
                        return LongPressDraggable<PlanDayDragData>(
                          delay: dragLongPressDelay,
                          data: PlanDayDragData(sourceDay: day),
                          feedback: Material(
                            color: Colors.transparent,
                            elevation: 10,
                            borderRadius: BorderRadius.circular(8.r),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.sizeOf(context).width - 32.w,
                              ),
                              child: SizedBox(
                                height: cardHeight,
                                child: _PlanWorkoutCard(
                                  entry: session,
                                  dropHighlight: false,
                                ),
                              ),
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.35,
                            child: _PlanWorkoutCard(
                              entry: session,
                              dropHighlight: false,
                            ),
                          ),
                          child: card,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(height: 1, thickness: 1, color: AppColors.progressTrack),
      ],
    );
  }
}

class _PlanWorkoutCard extends StatelessWidget {
  const _PlanWorkoutCard({required this.entry, required this.dropHighlight});

  final PlanWorkoutEntry? entry;
  final bool dropHighlight;

  @override
  Widget build(BuildContext context) {
    final e = entry;

    if (e == null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: dropHighlight
                  ? AppColors.planAppBarAccentLine
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: const SizedBox.expand(),
        ),
      );
    }

    final Widget body;
    final isLeg = e.category.toLowerCase().contains('leg');
    final chipIcon = isLeg
        ? Icons.directions_run_rounded
        : Icons.fitness_center_rounded;
    late final Color chipFg;
    late final Color chipFill;
    late final Color chipBorder;
    if (isLeg) {
      chipFg = AppColors.planWorkoutChipLegFg;
      chipFill = AppColors.planWorkoutChipLegBg;
      chipBorder = chipFg.withValues(alpha: 0.35);
    } else {
      chipFg = AppColors.planWorkoutChipArms;
      chipFill = chipFg.withValues(alpha: 0.22);
      chipBorder = chipFg.withValues(alpha: 0.45);
    }

    body = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 2.h),
          child: Icon(
            Icons.drag_indicator_rounded,
            color: AppColors.planSecondaryText,
            size: 20.sp,
          ),
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: chipFill,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: chipBorder, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(chipIcon, size: 14.sp, color: chipFg),
                      SizedBox(width: 6.w),
                      Text(
                        e.category,
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: chipFg,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      e.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    e.durationLabel,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    final inner = ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: AppColors.insightCard,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: dropHighlight
                ? AppColors.planAppBarAccentLine
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 4.w, color: AppColors.textPrimary),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(8.w, 10.h, 12.w, 10.h),
                child: body,
              ),
            ),
          ],
        ),
      ),
    );

    return inner;
  }
}
