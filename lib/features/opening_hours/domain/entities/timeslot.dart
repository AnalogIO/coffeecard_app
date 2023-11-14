import 'package:coffeecard/core/strings.dart';
import 'package:equatable/equatable.dart';

class Timeslot extends Equatable {
  final (int, int)? start;
  final (int, int)? end;

  const Timeslot({this.start, this.end});

  bool get isClosed => start == null || end == null;

  @override
  String toString() {
    if (isClosed) {
      return Strings.closed;
    }

    final startMinute = _pad(start!.$2.toString());
    final startHor = _pad(start!.$1.toString());

    final endMinute = _pad(end!.$2.toString());
    final endHour = _pad(end!.$1.toString());

    return '$startHor:$startMinute - $endHour:$endMinute';
  }

  String _pad(String s) {
    return s.padLeft(2, '0');
  }

  @override
  List<Object?> get props => [start, end];
}
