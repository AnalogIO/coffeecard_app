import 'package:coffeecard/features/opening_hours/domain/entities/timeslot.dart';

class OpeningHours {
  final Map<int, Timeslot> allOpeningHours;
  final Timeslot todaysOpeningHours;

  OpeningHours({
    required this.allOpeningHours,
    required this.todaysOpeningHours,
  });
}
