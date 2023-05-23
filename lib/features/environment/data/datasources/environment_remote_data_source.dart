import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/extensions/either_extensions.dart';
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

  Future<Either<NetworkFailure, Environment>> getEnvironmentType() async {
    return executor(
      apiV2.apiV2AppconfigGet,
    ).bindFuture(Environment.fromAppConfig);
  }
}
