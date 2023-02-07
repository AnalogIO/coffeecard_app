part of 'opening_hours_cubit.dart';

abstract class OpeningHoursState extends Equatable {
  const OpeningHoursState();
}

class Loading extends OpeningHoursState {
  const Loading();

  @override
  List<Object?> get props => [];
}

class Loaded extends OpeningHoursState {
  const Loaded({required this.isOpen, required this.openingHours});
  final bool isOpen;

  /// Opening hours in the format of Map<Datetime.weekday, String>
  final Map<int, String> openingHours;

  @override
  List<Object?> get props => [isOpen, openingHours];
}

class Error extends OpeningHoursState {
  const Error(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
