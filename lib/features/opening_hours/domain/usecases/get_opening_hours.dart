import 'package:coffeecard/features/opening_hours/domain/entities/timeslot.dart';
import 'package:coffeecard/features/opening_hours/domain/repositories/opening_hours_repository.dart';

class GetOpeningHours {
  final OpeningHoursRepository repository;

  GetOpeningHours({required this.repository});

  Map<int, Timeslot> call() {
    return repository.getOpeningHours();
  }
}
