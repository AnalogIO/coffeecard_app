import 'package:coffeecard/features/opening_hours/domain/entities/timeslot.dart';

class OpeningHoursLocalDataSource {
  Map<int, Timeslot> getOpeningHours() {
    const normalOperation = Timeslot(start: 8, end: 16);
    const shortDayOperation = Timeslot(start: 8, end: 14);
    const closed = Timeslot();

    return {
      DateTime.monday: normalOperation,
      DateTime.tuesday: normalOperation,
      DateTime.wednesday: normalOperation,
      DateTime.thursday: normalOperation,
      DateTime.friday: shortDayOperation,
      DateTime.saturday: closed,
      DateTime.sunday: closed,
    };
  }
}
