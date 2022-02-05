import 'package:coffeecard/generated/api/shiftplanning_api.swagger.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:logger/logger.dart';

class OpeningHoursRepository {
  final ShiftplanningApi _api;
  final Logger _logger;

  OpeningHoursRepository(this._api, this._logger);

  Future<Either<ApiError,bool>> isOpen() async {
    final response = await _api.apiOpenShortKeyGet(
      shortKey: 'analog',
    );

    if (response.isSuccessful) {
      return Right(response.body!.open!);
    } else {
      _logger.e('API Error ${response.statusCode} ${response.error}');
      throw Left(ApiError(response.error.toString()));
    }
  }
}
