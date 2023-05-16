import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/environment.dart';
import 'package:fpdart/fpdart.dart';

class AppConfigRepository {
  AppConfigRepository({
    required this.apiV2,
    required this.executor,
  });

  final CoffeecardApiV2 apiV2;
  final NetworkRequestExecutor executor;

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

  Future<Either<NetworkFailure, Environment>> getEnvironmentType() async {
    final result = await executor(
      apiV2.apiV2AppconfigGet,
    );

    return result.map(_onSuccessfulRequest);
  }
}
