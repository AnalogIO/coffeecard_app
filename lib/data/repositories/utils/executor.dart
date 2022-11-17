import 'package:chopper/chopper.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:logger/logger.dart';

/// Helper class that executes network requests and handles errors
class Executor {
  const Executor(this.logger);
  final Logger logger;

  /// Executes a network request and handles errors, including IO errors.
  /// Returns either a [RequestError] or the transformed success type.
  Future<Either<RequestError, Ret>> execute<Dto, Ret>(
    Future<Response<Dto>> Function() request, {
    required Ret Function(Dto dto) transformer,
  }) async {
    try {
      final response = await request();
      if (response.isSuccessful) {
        return Right(transformer(response.body as Dto));
      } else {
        logger.e('API Error: (${response.statusCode}) ${response.error}');
        return Left(RequestError.fromResponse(response));
      }
    } on Exception catch (e) {
      logger.e('HTTP Client Error: $e');
      return Left(RequestError.clientNetworkError());
    }
  }
}
