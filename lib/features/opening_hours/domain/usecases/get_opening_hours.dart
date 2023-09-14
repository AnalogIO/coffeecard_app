import 'package:coffeecard/features/opening_hours/domain/entities/opening_hours.dart';
import 'package:coffeecard/features/opening_hours/domain/repositories/opening_hours_repository.dart';

class GetOpeningHours {
  final OpeningHoursRepository repository;

  GetOpeningHours({required this.repository});

  OpeningHours call() {
    return repository.getOpeningHours();
  }
}
