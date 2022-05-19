import 'package:coffeecard/generated/api/shiftplanning_api.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/utils/extensions.dart';
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
    //TODO: fetch data when available
    const String normalOperation = '8.00-16:00';
    const String shortDayOperation = '8.00-14:00';
    const String closed = 'Closed';

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
  }
}
