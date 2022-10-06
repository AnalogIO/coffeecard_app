import 'package:coffeecard/generated/api/shiftplanning_api.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/models/opening_hours_day.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/utils/extensions.dart';
import 'package:collection/collection.dart';
import 'package:logger/logger.dart';

class OpeningHoursRepository {
  final ShiftplanningApi _api;
  final Logger _logger;

  OpeningHoursRepository(this._api, this._logger);

  Future<Either<ApiError, bool>> isOpen() async {
    final response = await _api.apiOpenShortKeyGet(
      shortKey: 'analog',
    );

    if (response.isSuccessful) {
      return Right(response.body!.open);
    } else {
      _logger.e(response.formatError());
      throw Left(ApiError(response.error.toString()));
    }
  }

  Future<Either<ApiError, Map<int, String>>> getOpeningHours() async {
    final response = await _api.apiShiftsShortKeyGet(shortKey: 'analog');

    if (response.isSuccessful) {
      final content = response.body!..sortBy((element) => element.start);

      final m =
          groupBy<OpeningHoursDTO, int>(content, (dto) => dto.start.weekday);

      final m2 = m.map((key, value) => MapEntry(
          key, OpeningHoursDay(value.first.start, value.last.end).toString()));

      for (var i = DateTime.monday; i <= DateTime.sunday; i++) {
        m2.putIfAbsent(i, () => 'Closed');
      }

      return Right(m2);
    } else {
      return Left(ApiError(response.error.toString()));
    }

/*
    final Map<int, String> openingHours = {
      DateTime.monday: normalOperation,
      DateTime.tuesday: normalOperation,
      DateTime.wednesday: normalOperation,
      DateTime.thursday: normalOperation,
      DateTime.friday: shortDayOperation,
      DateTime.saturday: closed,
      DateTime.sunday: closed,
    };

    return Future.value(Right(openingHours));
   */
  }
}
