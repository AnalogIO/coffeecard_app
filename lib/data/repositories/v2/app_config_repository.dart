import 'package:coffeecard/data/repositories/utils/executor.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/environment.dart';
import 'package:coffeecard/utils/either.dart';

class AppConfigRepository {
  AppConfigRepository({
    required this.apiV2,
    required this.executor,
  });

  final CoffeecardApiV2 apiV2;
  final Executor executor;

  Environment _onSuccessfulRequest(AppConfig dto) {
    switch (environmentTypeFromJson(dto.environmentType as String)) {
      case EnvironmentType.production:
        return Environment.production;
      case EnvironmentType.localdevelopment:
      case EnvironmentType.test:
        return Environment.test;
      case EnvironmentType.swaggerGeneratedUnknown:
        return Environment.unknown;
    }
  }

  Future<Either<RequestError, Environment>> getEnvironmentType() async {
    return executor.execute(
      apiV2.apiV2AppconfigGet,
      transformer: _onSuccessfulRequest,
    );
  }
}
