import 'package:coffeecard/data/repositories/utils/executor.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/environment.dart';
import 'package:dartz/dartz.dart';

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
      // both test and localdevelopment are treated as test
      case EnvironmentType.test:
      case EnvironmentType.localdevelopment:
        return Environment.test;
      case EnvironmentType.swaggerGeneratedUnknown:
        return Environment.unknown;
    }
  }

  Future<Either<RequestFailure, Environment>> getEnvironmentType() async {
    return executor.execute(
      apiV2.apiV2AppconfigGet,
      _onSuccessfulRequest,
    );
  }
}
