part of 'opening_hours_cubit.dart';

enum OpeningHoursStatus { open, closed, unknown }

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
  final OpeningHoursStatus status;

  const OpeningHoursLoaded({required this.status, required this.openingHours});

  bool get isOpen => status == OpeningHoursStatus.open;
  bool get isCloed => status == OpeningHoursStatus.closed;
  bool get isUnknown => status == OpeningHoursStatus.unknown;

  @override
  List<Object?> get props => [status, openingHours];
}
