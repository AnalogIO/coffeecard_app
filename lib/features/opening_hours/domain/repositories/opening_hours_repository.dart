import 'package:coffeecard/features/opening_hours/domain/entities/timeslot.dart';

abstract interface class OpeningHoursRepository {
  bool isOpen(DateTime now);
  Map<int, Timeslot> getOpeningHours();
}
