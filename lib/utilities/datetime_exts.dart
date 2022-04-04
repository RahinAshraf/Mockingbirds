/// DateTime extensions

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime date) {
    return day == date.day && month == date.month && year == date.year;
  }
}
