import 'package:equatable/equatable.dart';

class OpeningHours extends Equatable {
  final Map<int, String> allOpeningHours;
  final String todaysOpeningHours;

  const OpeningHours({
    required this.allOpeningHours,
    required this.todaysOpeningHours,
  });

  @override
  List<Object?> get props => [allOpeningHours, todaysOpeningHours];
}
