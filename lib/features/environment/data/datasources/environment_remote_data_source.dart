import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/environment/domain/entities/environment.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:fpdart/fpdart.dart';

class EnvironmentRemoteDataSource {
  EnvironmentRemoteDataSource({
    required this.apiV2,
    required this.executor,
  });

  final CoffeecardApiV2 apiV2;
  final NetworkRequestExecutor executor;

  Environment _onSuccessfulRequest(AppConfig dto) {
    return switch (environmentTypeFromJson(dto.environmentType as String)) {
      EnvironmentType.production => Environment.production,
      EnvironmentType.test ||
      EnvironmentType.localdevelopment =>
        Environment.test,
      EnvironmentType.swaggerGeneratedUnknown => Environment.unknown,
    };
  }

  Future<Either<NetworkFailure, Environment>> getEnvironmentType() async {
    final result = await executor(
      apiV2.apiV2AppconfigGet,
    );

    return result.map(_onSuccessfulRequest);
  }
}
