part of 'opening_hours_cubit.dart';

abstract class OpeningHoursState extends Equatable {
  const OpeningHoursState();

  @override
  List<Object?> get props => [];
}

class OpeningHoursLoading extends OpeningHoursState {
  const OpeningHoursLoading();

  @override
  List<Object?> get props => [];
}

class OpeningHoursLoaded extends OpeningHoursState {
  const OpeningHoursLoaded({required this.isOpen, required this.openingHours});
  final bool isOpen;
  final Map<int, String> openingHours; // Map<Datetime.weekday, String>

  @override
  List<Object?> get props => [isOpen, openingHours];
}

class OpeningHoursError extends OpeningHoursState {
  const OpeningHoursError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
