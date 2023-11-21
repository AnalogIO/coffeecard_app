import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// A range of time with a start and end [TimeOfDay].
///
/// To get the text representation of a timeslot, use [format].
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
  /// Returns true if [other] is before or equal to [this].
  bool operator <=(TimeOfDay other) {
    if (hour < other.hour) {
      return true;
    } else if (hour == other.hour) {
      return minute <= other.minute;
    } else {
      return false;
    }
  }

  /// Checks if [this] is between [start] and [end].
  ///
  /// Takes into account that [start] can be after [end] (crossing midnight).
  bool isBetween(TimeOfDay start, TimeOfDay end) {
    return start <= end
        ? start <= this && this <= end
        : start <= this || this <= end;
  }

  /// Checks if [this] is within [timeslot].
  bool isInTimeslot(Timeslot timeslot) {
    return timeslot.startTime <= this && this <= timeslot.endTime;
  }
}
