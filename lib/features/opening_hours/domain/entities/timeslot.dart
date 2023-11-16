import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// A timeslot with a start and end time.
class Timeslot extends Equatable {
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  const Timeslot(this.startTime, this.endTime);

  String format(BuildContext context) {
    final start = startTime.format(context);
    final end = endTime.format(context);
    return '$start-$end';
  }

  @override
  List<Object?> get props => [startTime, endTime];
}

/// Operators for comparing [TimeOfDay]s.
extension TimeOfDayOperators on TimeOfDay {
  /// Returns true if [other] is before [this].
  bool operator <=(TimeOfDay other) {
    if (hour < other.hour) {
      return true;
    } else if (hour == other.hour) {
      return minute <= other.minute;
    } else {
      return false;
    }
  }

  bool isInTimeslot(Timeslot timeslot) {
    return timeslot.startTime <= this && this <= timeslot.endTime;
  }
}
