import 'package:coffeecard/features/opening_hours/domain/repositories/opening_hours_repository.dart';

class CheckOpenStatus {
  final OpeningHoursRepository repository;

  CheckOpenStatus({required this.repository});

  bool call() {
    return repository.isOpen(DateTime.now());
  }
}
