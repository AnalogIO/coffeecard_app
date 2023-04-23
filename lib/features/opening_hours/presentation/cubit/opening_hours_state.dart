part of 'opening_hours_cubit.dart';

abstract class OpeningHoursState extends Equatable {
  const OpeningHoursState();
}

class OpeningHoursLoading extends OpeningHoursState {
  const OpeningHoursLoading();

  @override
  List<Object?> get props => [];
}

class OpeningHoursLoaded extends OpeningHoursState {
  /// Opening hours in the format of Map<Datetime.weekday, String>
  final Map<int, String> openingHours;
  final bool isOpen;
  final String todaysOpeningHours;

  const OpeningHoursLoaded({
    required this.isOpen,
    required this.openingHours,
    required this.todaysOpeningHours,
  });

  @override
  List<Object?> get props => [isOpen, openingHours, todaysOpeningHours];
}

class OpeningHoursError extends OpeningHoursState {
  final String error;

  const OpeningHoursError({required this.error});

  @override
  List<Object?> get props => [error];
}
