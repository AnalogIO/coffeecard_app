import 'package:coffeecard/core/external/date_service.dart';
import 'package:coffeecard/features/opening_hours/data/datasources/opening_hours_local_data_source.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/opening_hours.dart';
import 'package:coffeecard/features/opening_hours/domain/repositories/opening_hours_repository.dart';

class OpeningHoursRepositoryImpl implements OpeningHoursRepository {
  final OpeningHoursLocalDataSource dataSource;
  final DateService dateService;

  OpeningHoursRepositoryImpl({
    required this.dataSource,
    required this.dateService,
  });

  @override
  OpeningHours getOpeningHours() {
    final allOpeningHours = dataSource.getOpeningHours();
    final currentWeekDay = dateService.currentWeekday();

    final todaysOpeningHours = allOpeningHours[currentWeekDay]!;

    return OpeningHours(
      allOpeningHours: allOpeningHours,
      todaysOpeningHours: todaysOpeningHours,
    );
  }

  @override
  bool isOpen() {
    final todaysOpeningHours = getOpeningHours().todaysOpeningHours;

    if (todaysOpeningHours.isClosed) {
      return false;
    }

    final currentHour = dateService.currentHour();

    if (currentHour < todaysOpeningHours.start! ||
        currentHour > todaysOpeningHours.end!) return false;

    return true;
  }
}
