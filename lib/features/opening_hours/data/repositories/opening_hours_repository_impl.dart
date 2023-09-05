import 'package:coffeecard/features/opening_hours/data/datasources/opening_hours_local_data_source.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/timeslot.dart';
import 'package:coffeecard/features/opening_hours/domain/repositories/opening_hours_repository.dart';

class OpeningHoursRepositoryImpl implements OpeningHoursRepository {
  final OpeningHoursLocalDataSource dataSource;

  OpeningHoursRepositoryImpl({required this.dataSource});

  @override
  Map<int, Timeslot> getOpeningHours() {
    return dataSource.getOpeningHours();
  }

  @override
  bool isOpen(DateTime now) {
    final timeslot = getOpeningHours()[DateTime.now().weekday]!;

    if (timeslot.isClosed) {
      return false;
    }

    if (now.hour < timeslot.start! || now.hour > timeslot.end!) return false;

    return true;
  }
}
