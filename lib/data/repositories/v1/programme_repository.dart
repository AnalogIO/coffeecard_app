import 'package:chopper/chopper.dart';
import 'package:coffeecard/errors/request_error.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/utils/extensions.dart';
import 'package:logger/logger.dart';

class ProgrammeRepository {
  final CoffeecardApi _api;
  final Logger _logger;

  ProgrammeRepository(this._api, this._logger);

  Future<Either<RequestError, List<ProgrammeDto>>> getProgramme() async {
    final Response<List<ProgrammeDto>> response;
    try {
      response = await _api.apiV1ProgrammesGet();
    } catch (e) {
      return Left(ClientNetworkError());
    }

    if (response.isSuccessful) {
      return Right(response.body!);
    }
    _logger.e(response.formatError());
    return Left(RequestError(response.error.toString(), response.statusCode));
  }
}
