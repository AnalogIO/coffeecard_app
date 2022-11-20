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
  const OpeningHoursLoaded({required this.isOpen, required this.openingHours});
  final bool isOpen;

  /// Opening hours in the format of Map<Datetime.weekday, String>
  final Map<int, String> openingHours;

  @override
  List<Object?> get props => [isOpen, openingHours];
}

class OpeningHoursError extends OpeningHoursState {
  const OpeningHoursError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
