import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/core/errors/exceptions.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/opening_hours.dart';
import 'package:coffeecard/features/opening_hours/opening_hours.dart';
import 'package:coffeecard/generated/api/shiftplanning_api.swagger.dart';
import 'package:coffeecard/models/opening_hours_day.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';

class OpeningHoursRepositoryImpl implements OpeningHoursRepository {
  final OpeningHoursRemoteDataSource dataSource;

  OpeningHoursRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, bool>> getIsOpen() async {
    try {
      final isOpen = await dataSource.isOpen();

      return Right(isOpen);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.error));
    }
  }

  @override
  Future<Either<Failure, OpeningHours>> getOpeningHours(int weekday) async {
    try {
      final openingHours = await dataSource.getOpeningHours();

      final openingHoursMap = transformOpeningHours(openingHours);

      return Right(
        OpeningHours(
          allOpeningHours: openingHoursMap,
          todaysOpeningHours: calculateTodaysOpeningHours(
            weekday,
            openingHoursMap,
          ),
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.error));
    }
  }

  Map<int, String> transformOpeningHours(List<OpeningHoursDTO> dtoList) {
    final content = dtoList..sortBy((dto) => dto.start);

    final openingHoursPerWeekday =
        groupBy<OpeningHoursDTO, int>(content, (dto) => dto.start.weekday);

    // create map associating each weekday to its opening hours:
    // {
    //   0: 8 - 16,
    //   1: 8 - 16, ...
    // }
    final weekDayOpeningHours = openingHoursPerWeekday.map(
      (day, value) => MapEntry(
        day,
        OpeningHoursDay(value.first.start, value.last.end).toString(),
      ),
    );

    // closed string is not capitalized
    var closed = Strings.closed;
    closed = closed.replaceFirst(closed[0], closed[0].toUpperCase());

    // the previous map only contains weekdays, mark weekends as closed
    weekDayOpeningHours.addAll({
      DateTime.saturday: closed,
      DateTime.sunday: closed,
    });

    return weekDayOpeningHours;
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
