import 'package:chopper/chopper.dart' show Response;
import 'package:coffeecard/core/errors/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

class Executor {
  final Logger logger;

  const Executor(this.logger);

  /// Executes a network request.
  Future<Either<ServerFailure, Result>> call<Result>(
    Future<Response<Result>> Function() request,
  ) async {
    try {
      final response = await request();

      if (!response.isSuccessful) {
        logger.e(response.toString());
        return Left(ServerFailure.fromResponse(response));
      }

      return Right(response.body as Result);
    } on Exception {
      // could not connect to backend for whatever reason
      return const Left(ServerFailure('connection refused'));
    }
  }
}
