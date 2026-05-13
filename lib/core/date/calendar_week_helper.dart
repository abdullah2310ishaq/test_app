abstract final class CalendarWeekHelper {
  CalendarWeekHelper._();

  static const _monthShort = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  /// Calendar strip labels (matches common fitness UI).
  static const List<String> stripWeekdayLabels = [
    'M',
    'TU',
    'W',
    'TH',
    'F',
    'SA',
    'SU',
  ];

  static DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Monday = 0 … Sunday = 6 (Dart uses Mon=1 … Sun=7).
  static int weekdayIndexFromMonday(DateTime d) {
    return (d.weekday - DateTime.monday + 7) % 7;
  }

  /// Midnight Monday of the ISO-style week that contains [day].
  static DateTime mondayOfWeekContaining(DateTime day) {
    final only = dateOnly(day);
    return only.subtract(Duration(days: weekdayIndexFromMonday(only)));
  }

  /// Seven calendar days starting Monday of the week that contains [anchor].
  static List<DateTime> weekDaysFrom(DateTime anchor) {
    final mon = mondayOfWeekContaining(anchor);
    return List.generate(7, (i) => mon.add(Duration(days: i)));
  }

  /// Index 0–6 of [day] inside its Monday-start week.
  static int dayIndexInWeek(DateTime day) {
    return weekdayIndexFromMonday(day);
  }

  /// How many Mon–Sun rows the month needs (4–6).
  static int totalWeekRowsInMonth(DateTime yearMonth) {
    final first = DateTime(yearMonth.year, yearMonth.month, 1);
    final daysInMonth = DateTime(yearMonth.year, yearMonth.month + 1, 0).day;
    final leading = weekdayIndexFromMonday(first);
    final cells = leading + daysInMonth;
    return (cells / 7).ceil();
  }

  /// 1-based row index for [day] inside its own month grid (Mon-first).
  static int weekRowIndexInMonth(DateTime day) {
    final first = DateTime(day.year, day.month, 1);
    final leading = weekdayIndexFromMonday(first);
    final cellIndex = leading + day.day - 1;
    return cellIndex ~/ 7 + 1;
  }

  /// "Week 2/5" for the month that contains [day].
  static String weekLabelForDate(DateTime day) {
    final month = DateTime(day.year, day.month, 1);
    final current = weekRowIndexInMonth(day);
    final total = totalWeekRowsInMonth(month);
    return 'Week $current/$total';
  }

  /// Plan tab: cycles 1–4 against the calendar row in the month (…/4).
  static String planWeekLabelFour(DateTime dayInWeek) {
    final row = weekRowIndexInMonth(dayInWeek);
    final w = ((row - 1) % 4) + 1;
    return 'Week $w/4';
  }

  /// e.g. "December 8-14" when Mon–Sun stay in one month.
  static String weekCalendarRangeLabel(DateTime anchorInWeek) {
    final days = weekDaysFrom(anchorInWeek);
    final mon = days.first;
    final sun = days.last;
    if (mon.month == sun.month && mon.year == sun.year) {
      final long = _longMonth(mon.month);
      return '$long ${mon.day}-${sun.day}';
    }
    return '${_monthShort[mon.month - 1]} ${mon.day} - ${_monthShort[sun.month - 1]} ${sun.day}';
  }

  static String _longMonth(int month) {
    const long = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return long[month - 1];
  }

  /// Up to 42 cells (6 rows × 7); `null` = padding outside the month.
  static List<DateTime?> monthGridCells(DateTime yearMonth) {
    final first = DateTime(yearMonth.year, yearMonth.month, 1);
    final lastDay = DateTime(yearMonth.year, yearMonth.month + 1, 0).day;
    final leading = weekdayIndexFromMonday(first);
    final out = <DateTime?>[];

    for (var i = 0; i < leading; i++) {
      out.add(null);
    }
    for (var d = 1; d <= lastDay; d++) {
      out.add(DateTime(yearMonth.year, yearMonth.month, d));
    }
    while (out.length % 7 != 0) {
      out.add(null);
    }
    while (out.length < 42) {
      out.add(null);
    }
    return out;
  }

  static String monthYearTitle(DateTime anyDayInMonth) {
    final m = anyDayInMonth.month;
    return '${_monthShort[m - 1]} ${anyDayInMonth.year}';
  }

  static String shortDateWithYear(DateTime d) {
    return '${d.day} ${_monthShort[d.month - 1]} ${d.year}';
  }

  static String longMonthDay(DateTime d) {
    return '${_longMonth(d.month)} ${d.day}';
  }

  /// "Today, 22 Dec 2024" when [selected] is today, else "Mon, 22 Dec 2024".
  static String headlineDateLabel(DateTime selected, {DateTime? today}) {
    final t = dateOnly(today ?? DateTime.now());
    final s = dateOnly(selected);
    final body = shortDateWithYear(s);
    if (s == t) {
      return 'Today, $body';
    }
    const dow = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final prefix = dow[s.weekday - 1];
    return '$prefix, $body';
  }
}
