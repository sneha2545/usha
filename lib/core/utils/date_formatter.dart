/// Human-readable date and time helpers for appointment content.
abstract final class AppDateFormatter {
  static const List<String> _monthsShort = <String>[
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

  static const List<String> _weekdaysLong = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> _weekdaysShort = <String>[
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static String fullDate(DateTime value) {
    return '${_weekdaysShort[value.weekday - 1]}, ${value.day} '
        '${_monthsShort[value.month - 1]} ${value.year}';
  }

  static String dayMonth(DateTime value) {
    return '${value.day} ${_monthsShort[value.month - 1]}';
  }

  static String weekday(DateTime value) {
    return _weekdaysLong[value.weekday - 1];
  }

  static String weekdayShort(DateTime value) {
    return _weekdaysShort[value.weekday - 1];
  }

  static String dayNumber(DateTime value) => value.day.toString();

  static String monthShortUpper(DateTime value) {
    return _monthsShort[value.month - 1].toUpperCase();
  }

  static String time(DateTime value) {
    final int hour12 = value.hour % 12 == 0 ? 12 : value.hour % 12;
    final String minute = value.minute.toString().padLeft(2, '0');
    final String suffix = value.hour < 12 ? 'AM' : 'PM';
    return '$hour12:$minute $suffix';
  }
}
