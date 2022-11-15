import 'package:chopper/chopper.dart';
import 'package:coffeecard/errors/request_error.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/environment.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/utils/extensions.dart';
import 'package:logger/logger.dart';

class AppConfigRepository {
  final CoffeecardApiV2 _api;
  final Logger _logger;

  AppConfigRepository(this._api, this._logger);

  Future<Either<RequestError, Environment>> getEnvironmentType() async {
    final Response<AppConfig> response;
    try {
      response = await _api.apiV2AppconfigGet();
    } catch (e) {
      return Left(ClientNetworkError());
    }

    if (response.isSuccessful) {
      final environmentType = environmentTypeFromJson(
        response.body!.environmentType as String,
      );

      final Environment environment;
      switch (environmentType) {
        case EnvironmentType.swaggerGeneratedUnknown:
          environment = Environment.unknown;
          break;
        case EnvironmentType.production:
          environment = Environment.production;
          break;
        case EnvironmentType.test:
          environment = Environment.test;
          break;
        case EnvironmentType.localdevelopment:
          environment = Environment.test;
          break;
      }

      return Right(environment);
    }
    _logger.e(response.formatError());
    return Left(RequestError(response.error.toString(), response.statusCode));
  }
}
