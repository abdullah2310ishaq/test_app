import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../providers/nutrition_insights_notifier.dart';
import 'nutrition_calendar_bottom_sheet.dart';

/// Same week chip + headline + date strip as the nutrition dashboard.
class NutritionWeekCalendarHeader extends StatelessWidget {
  const NutritionWeekCalendarHeader({
    super.key,
    this.includeWeekPickerRow = true,
  });

  /// When false, the week chip row is omitted (e.g. week control lives in the app bar).
  final bool includeWeekPickerRow;

  @override
  Widget build(BuildContext context) {
    final insights = context.watch<NutritionInsightsNotifier>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(height: 2.h, color: AppColors.accentBlue),
        if (includeWeekPickerRow)
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 6.h),
            child: NutritionWeekPickerRow(
              weekLabel: insights.weekLabel,
              onWeekTap: () => NutritionCalendarBottomSheet.show(context),
            ),
          )
        else
          SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                insights.headlineDateLabel,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),
              NutritionWeekDateStrip(
                labels: insights.dayLabels,
                numbers: insights.dayNumbers,
                selectedIndex: insights.selectedDateIndex,
                onSelect: insights.selectStripIndex,
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ],
    );
  }
}

class NutritionWeekPickerRow extends StatelessWidget {
  const NutritionWeekPickerRow({
    super.key,
    required this.weekLabel,
    required this.onWeekTap,
  });

  final String weekLabel;
  final VoidCallback onWeekTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onWeekTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time,
                  size: 18.sp,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 6.w),
                Text(
                  weekLabel,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
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
      ),
    );
  }
}

class NutritionWeekDateStrip extends StatelessWidget {
  const NutritionWeekDateStrip({
    super.key,
    required this.labels,
    required this.numbers,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<String> labels;
  final List<String> numbers;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(labels.length, (index) {
        final selected = index == selectedIndex;
        return Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onSelect(index),
            child: Column(
              children: [
                Text(
                  labels[index],
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 11.sp,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  width: 40.w,
                  height: 40.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.dateCircleIdle,
                    border: Border.all(
                      color: selected
                          ? AppColors.accentGreen
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    numbers[index],
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected
                        ? AppColors.accentGreen
                        : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
