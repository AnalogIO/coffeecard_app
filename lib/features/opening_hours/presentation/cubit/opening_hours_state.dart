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
  final Map<int, Timeslot> week;
  final Option<Timeslot> today;

  const OpeningHoursLoaded({required this.week, required this.today});

  @override
  List<Object?> get props => [week, today];
}
