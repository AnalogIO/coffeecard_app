import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:logger/logger.dart';

class ProgrammeRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  ProgrammeRepository(this._api, this._logger);

  Future<Either<ApiError, List<ProgrammeDto>>> getProgramme() async {
    final response = await _api.apiV1ProgrammesGet();

    if (response.isSuccessful) {
      return Right(response.body!);
    } else {
      _logger.e(Strings.formatApiError(response));
      return Left(ApiError(response.error.toString()));
    }
  }
}
