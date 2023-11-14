import 'package:coffeecard/features/opening_hours/domain/entities/timeslot.dart';

class OpeningHoursLocalDataSource {
  Map<int, Timeslot> getOpeningHours() {
    const open = (8, 0);

    const normalOperation = Timeslot(start: open, end: (15, 30));
    const shortDayOperation = Timeslot(start: open, end: (14, 30));
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
