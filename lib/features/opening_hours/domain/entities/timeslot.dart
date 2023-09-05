import 'package:coffeecard/base/strings.dart';

class Timeslot {
  final int? start;
  final int? end;

  Timeslot({this.start, this.end});

  bool get isClosed => start == null || end == null;

  @override
  String toString() => isClosed
      ? Strings.closed
      : '${start.toString().padLeft(2, '0')}:00 - $end:00';
}
