part of 'opening_hours_cubit.dart';

sealed class OpeningHoursState extends Equatable {
  const OpeningHoursState();
}

class OpeningHoursInitial extends OpeningHoursState {
  const OpeningHoursInitial();

  @override
  List<Object?> get props => [];
}

class OpeningHoursLoaded extends OpeningHoursState {
  final Map<int, Timeslot> openingHours;
  final bool isOpen;
  final Timeslot todaysOpeningHours;

  const OpeningHoursLoaded({
    required this.isOpen,
    required this.openingHours,
    required this.todaysOpeningHours,
  });

  @override
  List<Object?> get props => [isOpen, openingHours, todaysOpeningHours];
}
