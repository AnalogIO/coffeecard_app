import 'package:coffeecard/core/strings.dart';
import 'package:equatable/equatable.dart';

class Timeslot extends Equatable {
  final int? start;
  final int? end;

  const Timeslot({this.start, this.end});

  bool get isClosed => start == null || end == null;

  @override
  String toString() => isClosed
      ? Strings.closed
      : '${start.toString().padLeft(2, '0')}:00 - $end:00';

  @override
  List<Object?> get props => [start, end];
}
