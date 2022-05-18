import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/utils/extensions.dart';
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
      _logger.e(response.formatError());
      return Left(ApiError(response.error.toString()));
    }
  }
}
