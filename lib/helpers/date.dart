class DateHelpers {

  static List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(formatToDateOnly(startDate.add(Duration(days: i))));
    }
    return days;
  }

  static DateTime formatToDateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static bool isBetween({required DateTime startDate, DateTime? endDate, required DateTime date}) {
    if(endDate == null) {
      if(date.isAfter(startDate)){
        return true;
      } else if (date.isAtSameMomentAs(startDate)) {
        return true;
      } else {
        return false;
      }
    } else if(date.isAfter(startDate) && date.isBefore(endDate)){
      return true;
    } else if (date.isAtSameMomentAs(startDate) || date.isAtSameMomentAs(endDate)){
      return true;
    } else {
      return false;
    }
  }
}