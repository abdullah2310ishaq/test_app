import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../core/date/calendar_week_helper.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../providers/nutrition_insights_notifier.dart';

/// Dark calendar picker shown from the nutrition week chip.
abstract final class NutritionCalendarBottomSheet {
  NutritionCalendarBottomSheet._();

  static Future<void> show(BuildContext context) {
    final notifier = context.read<NutritionInsightsNotifier>();
    notifier.alignCalendarViewWithSelection();

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black54,
      builder: (sheetContext) {
        return Theme(
          data: AppTheme.darkNutrition(),
          child: const _CalendarSheetBody(),
        );
      },
    );
  }
}

class _CalendarSheetBody extends StatelessWidget {
  const _CalendarSheetBody();

  static const _dowHeaders = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Consumer<NutritionInsightsNotifier>(
      builder: (context, notifier, _) {
        final month = notifier.calendarViewMonth;
        final cells = CalendarWeekHelper.monthGridCells(month);
        final selected = CalendarWeekHelper.dateOnly(notifier.selectedDay);

        return Padding(
          padding: EdgeInsets.only(top: 8.h),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.bottomSheetBackground,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h + bottomInset),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.sheetDragHandle,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => notifier.shiftCalendarMonth(-1),
                        icon: Icon(
                          Icons.chevron_left,
                          color: AppColors.textPrimary,
                          size: 28.sp,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          CalendarWeekHelper.monthYearTitle(month),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => notifier.shiftCalendarMonth(1),
                        icon: Icon(
                          Icons.chevron_right,
                          color: AppColors.textPrimary,
                          size: 28.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _dowHeaders
                        .map(
                          (d) => Expanded(
                            child: Text(
                              d,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(height: 8.h),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cells.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 8.h,
                      crossAxisSpacing: 4.w,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final day = cells[index];
                      if (day == null) {
                        return const SizedBox.shrink();
                      }
                      final isSelected =
                          CalendarWeekHelper.dateOnly(day) == selected;
                      return GestureDetector(
                        onTap: () {
                          notifier.selectCalendarDay(day);
                          Navigator.of(context).pop();
                        },
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.accentGreen
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
