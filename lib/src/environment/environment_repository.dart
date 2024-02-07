// FIXME: Add linter rule to allow function declarations over variables
// ignore_for_file: prefer_function_declarations_over_variables

import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/environment.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:fpdart/fpdart.dart';

class EnvironmentRepository {
  EnvironmentRepository({
    required CoffeecardApiV2 apiV2,
    required NetworkRequestExecutor executor,
  })  : _executor = executor,
        _apiV2 = apiV2;

  final CoffeecardApiV2 _apiV2;
  final NetworkRequestExecutor _executor;

  TaskEither<Failure, Environment> getEnvironment() {
    return _executor
        .executeAsTask(_apiV2.apiV2AppconfigGet)
        .chainEither(_parseSwaggerEnvironmentType)
        .chainEither(_getValidEnvironmentType);
  }
}

/// Safely parses the environment type from the API
/// response using the generated Swagger code.
final _parseSwaggerEnvironmentType = (AppConfig config) {
  return Either.tryCatch(
    () => environmentTypeFromJson(config.environmentType as String),
    (_, __) => const UnknownFailure(
      'The response from the server did not contain valid '
      'environment type information.',
    ),
  );
};

/// Converts the Swagger-generated environment type
/// to a supported [Environment] type.
final _getValidEnvironmentType = (EnvironmentType swaggerEnvType) {
  final r = (Environment env) => Right<Failure, Environment>(env);
  final l = (String msg) => Left<Failure, Environment>(UnknownFailure(msg));

  return switch (swaggerEnvType) {
    EnvironmentType.production => r(Environment.production),
    EnvironmentType.test => r(Environment.testing),
    EnvironmentType.localdevelopment => l('Unsupported environment type.'),
    EnvironmentType.swaggerGeneratedUnknown => l('Unknown environment type.'),
  };
};
