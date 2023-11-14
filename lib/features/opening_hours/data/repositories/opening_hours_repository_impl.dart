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

    final openTimeslot =
        (todaysOpeningHours.start!.$1, todaysOpeningHours.start!.$2);
    final closedTimeslot =
        (todaysOpeningHours.end!.$1, todaysOpeningHours.end!.$2);

    final currentHour = dateService.currentHour();
    final currentMinute = dateService.currentMinute();

    final beforeOpening =
        currentHour <= openTimeslot.$1 && currentMinute <= openTimeslot.$2;
    final afterClosing =
        currentHour >= closedTimeslot.$1 && currentMinute >= closedTimeslot.$2;

    if (beforeOpening || afterClosing) return false;

    return true;
  }
}
