import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// One scheduled workout row on the plan calendar.
class PlanWorkoutEntry {
  const PlanWorkoutEntry({
    required this.title,
    required this.category,
    required this.badgeColor,
    required this.minutesLow,
    required this.minutesHigh,
  });

  final String title;
  final String category;
  final Color badgeColor;
  final int minutesLow;
  final int minutesHigh;

  String get durationLabel => '${minutesLow}m - ${minutesHigh}m';

  /// Used for "Total: Xmin" (upper bound per session).
  int get minutesTotal => minutesHigh;
}

/// Workout template for Plan; week comes from [NutritionInsightsNotifier.selectedDay].
class PlanCalendarNotifier extends ChangeNotifier {
  PlanCalendarNotifier();

  /// Which pair of Mon–Sun blocks is shown on the plan (0 → weeks 1–2, …, 3 → weeks 7–8).
  int _programWeekPairIndex = 0;

  int get selectedProgramWeekPairIndex => _programWeekPairIndex;

  void selectProgramWeekPair(int index) {
    if (index < 0 || index > 3 || index == _programWeekPairIndex) {
      return;
    }
    _programWeekPairIndex = index;
    notifyListeners();
  }

  static const PlanWorkoutEntry armBlaster = PlanWorkoutEntry(
    title: 'Arm Blaster',
    category: 'Arms Workout',
    badgeColor: Color(0xFF2E7D32),
    minutesLow: 25,
    minutesHigh: 30,
  );

  static const PlanWorkoutEntry legDayBlitz = PlanWorkoutEntry(
    title: 'Leg Day Blitz',
    category: 'Leg Workout',
    badgeColor: AppColors.planBadgeLegs,
    minutesLow: 25,
    minutesHigh: 30,
  );

  /// Explicit overrides / moves. Keys from [dateKey]. Absent key → weekday demo.
  final Map<String, PlanWorkoutEntry?> _byDate = {};

  static String dateKey(DateTime day) => '${day.year}-${day.month}-${day.day}';

  /// Demo pattern when no override: Monday arms, Thursday legs (design default).
  PlanWorkoutEntry? _defaultForWeekday(DateTime day) {
    switch (day.weekday) {
      case DateTime.monday:
        return armBlaster;
      case DateTime.thursday:
        return legDayBlitz;
      default:
        return null;
    }
  }

  /// Resolved session for this calendar date (override or demo default).
  PlanWorkoutEntry? workoutOnDay(DateTime day) {
    final key = dateKey(day);
    if (_byDate.containsKey(key)) {
      return _byDate[key];
    }
    return _defaultForWeekday(day);
  }

  /// Long-press drag onto another day: empty target receives session; two sessions swap.
  void moveWorkoutBetween({
    required DateTime fromDay,
    required DateTime toDay,
  }) {
    final fromKey = dateKey(fromDay);
    final toKey = dateKey(toDay);
    if (fromKey == toKey) {
      return;
    }

    final moving = workoutOnDay(fromDay);
    if (moving == null) {
      return;
    }

    final targetCurrent = workoutOnDay(toDay);

    _byDate[fromKey] = targetCurrent;
    _byDate[toKey] = moving;
    notifyListeners();
  }

  int totalMinutesForDays(List<DateTime> days) {
    var sum = 0;
    for (final d in days) {
      final w = workoutOnDay(d);
      if (w != null) {
        sum += w.minutesTotal;
      }
    }
    return sum;
  }
}
