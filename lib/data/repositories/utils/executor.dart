import 'package:chopper/chopper.dart';
import 'package:coffeecard/errors/request_error.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:coffeecard/utils/extensions.dart';
import 'package:logger/logger.dart';

class Executor {
  Future<Either<RequestError, T>> executeNetworkRequestSafely<T>(
    Future<Response<T>> Function() f,
    Logger logger,
  ) async {
    final Response<T> response;
    try {
      response = await f();
      if (response.isSuccessful) {
        return Right(response.body!);
      }
    } catch (e) {
      return Left(ClientNetworkError());
    }

    logger.e(response.formatError());
    return Left(RequestError(response.error.toString(), response.statusCode));
  }
}
