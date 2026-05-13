import 'package:flutter/foundation.dart';

import '../../core/date/calendar_week_helper.dart';

class NutritionInsightsNotifier extends ChangeNotifier {
  NutritionInsightsNotifier() {
    final now = CalendarWeekHelper.dateOnly(DateTime.now());
    _selectedDay = now;
    _calendarViewMonth = DateTime(now.year, now.month, 1);
  }

  late DateTime _selectedDay;
  late DateTime _calendarViewMonth;

  DateTime get selectedDay => _selectedDay;

  /// First day of the month currently shown in the calendar bottom sheet.
  DateTime get calendarViewMonth => _calendarViewMonth;

  /// Top chip, e.g. "Week 2/5", derived from [selectedDay] via [CalendarWeekHelper].
  String get weekLabel => CalendarWeekHelper.weekLabelForDate(_selectedDay);

  List<String> get dayLabels => CalendarWeekHelper.stripWeekdayLabels;

  List<String> get dayNumbers => CalendarWeekHelper.weekDaysFrom(
    _selectedDay,
  ).map((d) => '${d.day}').toList();

  int get selectedDateIndex =>
      CalendarWeekHelper.dayIndexInWeek(_selectedDay).clamp(0, 6);

  String get headlineDateLabel =>
      CalendarWeekHelper.headlineDateLabel(_selectedDay);

  String get workoutCardDateLine =>
      CalendarWeekHelper.longMonthDay(_selectedDay);

  /// Calories consumed / daily goal (for progress bar).
  static const int caloriesGoal = 2500;

  int caloriesConsumed = 550;

  int get caloriesRemaining => caloriesGoal - caloriesConsumed;

  double get caloriesProgress =>
      (caloriesConsumed / caloriesGoal).clamp(0.0, 1.0);

  int weightKg = 75;

  String weightTrendLabel = '+1.6kg';

  static const int _hydrationGoalMl = 2000;

  int _hydrationLoggedMl = 0;

  int get hydrationLoggedMl => _hydrationLoggedMl;

  /// 0.0–1.0 of 2 L goal.
  double get hydrationFraction =>
      (_hydrationLoggedMl / _hydrationGoalMl).clamp(0.0, 1.0);

  String hydrationLogMessage = '500 ml added to water log';

  void logHydrationNow() {
    _hydrationLoggedMl = (_hydrationLoggedMl + 500).clamp(0, _hydrationGoalMl);
    notifyListeners();
  }

  /// Before opening the sheet, align the sheet month with the selected day.
  void alignCalendarViewWithSelection() {
    _calendarViewMonth = DateTime(_selectedDay.year, _selectedDay.month, 1);
    notifyListeners();
  }

  void shiftCalendarMonth(int monthDelta) {
    _calendarViewMonth = DateTime(
      _calendarViewMonth.year,
      _calendarViewMonth.month + monthDelta,
      1,
    );
    notifyListeners();
  }

  void selectStripIndex(int index) {
    if (index < 0 || index > 6) {
      return;
    }
    final monday = CalendarWeekHelper.mondayOfWeekContaining(_selectedDay);
    final next = monday.add(Duration(days: index));
    _setSelectedDay(next);
  }

  void selectCalendarDay(DateTime day) {
    _setSelectedDay(day);
  }

  void _setSelectedDay(DateTime day) {
    final next = CalendarWeekHelper.dateOnly(day);
    if (next == _selectedDay) {
      return;
    }
    _selectedDay = next;
    _calendarViewMonth = DateTime(next.year, next.month, 1);
    notifyListeners();
  }
}
