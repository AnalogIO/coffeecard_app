import 'package:intl/intl.dart';

class OpeningHoursDay {
  final DateTime start;
  final DateTime end;

  const OpeningHoursDay(this.start, this.end);

  @override
  String toString() {
    return '${DateFormat.Hm().format(start)}-${DateFormat.Hm().format(end)}';
  }
}
