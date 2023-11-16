import 'package:coffeecard/features/opening_hours/domain/entities/timeslot.dart';
import 'package:flutter/material.dart';

class OpeningHoursLocalDataSource {
  Map<int, Timeslot> getOpeningHours() {
    const openTime = TimeOfDay(hour: 8, minute: 0);
    const normalDayCloseTime = TimeOfDay(hour: 15, minute: 30);
    const shortDayCloseTime = TimeOfDay(hour: 13, minute: 30);

    const normalDayOpeningHours = Timeslot(openTime, normalDayCloseTime);
    const shortDayOpeningHours = Timeslot(openTime, shortDayCloseTime);

    return {
      DateTime.monday: normalDayOpeningHours,
      DateTime.tuesday: normalDayOpeningHours,
      DateTime.wednesday: normalDayOpeningHours,
      DateTime.thursday: normalDayOpeningHours,
      DateTime.friday: shortDayOpeningHours,
    };
  }
}
