class DateService {
  DateTime now() => DateTime.now();
  int currentWeekday() => now().weekday;
  int currentHour() => now().hour;
}
