/// A recurring fictional laboratory slot with an explicit booking capacity.
class LabAvailabilitySlot {
  const LabAvailabilitySlot({
    required this.laboratoryId,
    required this.weekdays,
    required this.hour,
    required this.minute,
    required this.capacity,
  }) : assert(capacity > 0);

  final String laboratoryId;

  /// ISO weekday numbers: Monday is 1 and Sunday is 7.
  final List<int> weekdays;
  final int hour;
  final int minute;
  final int capacity;

  DateTime onDate(DateTime date) {
    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  bool matches(String labId, DateTime dateTime) {
    return laboratoryId == labId &&
        weekdays.contains(dateTime.weekday) &&
        onDate(dateTime).isAtSameMomentAs(dateTime);
  }
}
