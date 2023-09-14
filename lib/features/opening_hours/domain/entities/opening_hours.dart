import 'package:coffeecard/features/opening_hours/domain/entities/timeslot.dart';
import 'package:equatable/equatable.dart';

class OpeningHours extends Equatable {
  final Map<int, Timeslot> allOpeningHours;
  final Timeslot todaysOpeningHours;

  const OpeningHours({
    required this.allOpeningHours,
    required this.todaysOpeningHours,
  });

  @override
  List<Object?> get props => [allOpeningHours, todaysOpeningHours];
}
