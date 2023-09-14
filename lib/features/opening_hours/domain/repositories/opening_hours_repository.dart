import 'package:coffeecard/features/opening_hours/domain/entities/opening_hours.dart';

abstract interface class OpeningHoursRepository {
  bool isOpen();
  OpeningHours getOpeningHours();
}
