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
  final Timeslot todaysOpeningHours;
  final bool isOpen;

  const OpeningHoursLoaded({
    required this.openingHours,
    required this.todaysOpeningHours,
    required this.isOpen,
  });

  @override
  List<Object?> get props => [openingHours, todaysOpeningHours, isOpen];
}
