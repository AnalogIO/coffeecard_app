import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/opening_hours.dart';
import 'package:coffeecard/features/opening_hours/opening_hours.dart';
import 'package:coffeecard/generated/api/shiftplanning_api.swagger.dart';
import 'package:coffeecard/models/opening_hours_day.dart';
import 'package:dartz/dartz.dart';

class OpeningHoursRepositoryImpl implements OpeningHoursRepository {
  final OpeningHoursRemoteDataSource dataSource;

  OpeningHoursRepositoryImpl({required this.dataSource});

  @override
  Future<Either<ServerFailure, bool>> getIsOpen() async {
    return dataSource.isOpen();
  }

  @override
  Future<Either<ServerFailure, OpeningHours>> getOpeningHours(
    int weekday,
  ) async {
    final either = await dataSource.getOpeningHours();

    return either.flatMap(
      (openingHours) => Right(
        OpeningHours(
          allOpeningHours: transformOpeningHours(openingHours),
          todaysOpeningHours: calculateTodaysOpeningHours(
            weekday,
            transformOpeningHours(openingHours),
          ),
        ),
      ),
    );
  }

  // An [OpeningHoursDTO] actually represents a barista shift, so "dto.start"
  // means the start of the shift and "dto.end" means the end of the shift.
  Map<int, String> transformOpeningHours(List<OpeningHoursDTO> allShifts) {
    final shiftsByWeekday = <int, List<OpeningHoursDTO>>{
      DateTime.monday: [],
      DateTime.tuesday: [],
      DateTime.wednesday: [],
      DateTime.thursday: [],
      DateTime.friday: [],
      DateTime.saturday: [],
      DateTime.sunday: [],
    };

    for (final shift in allShifts) {
      final weekday = shift.start.weekday;
      shiftsByWeekday[weekday]!.add(shift);
    }

    // capitalize the closed string
    final closedString =
        Strings.closed[0].toUpperCase() + Strings.closed.substring(1);

    return shiftsByWeekday.map(
      (day, shifts) => MapEntry(
        day,
        shifts.isEmpty
            ? closedString
            : OpeningHoursDay(shifts.first.start, shifts.last.end).toString(),
      ),
    );
  }

  /// Return the current weekday and the corresponding opening hours e.g
  /// 'Monday: 8 - 16'
  String calculateTodaysOpeningHours(
    int weekday,
    Map<int, String> openingHours,
  ) {
    final weekdayPlural = Strings.weekdaysPlural[weekday]!;
    final hours = openingHours[weekday];
    return '$weekdayPlural: $hours';
  }
}
