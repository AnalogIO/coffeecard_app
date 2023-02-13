import 'dart:io';

import 'package:chopper/chopper.dart' show Response;
import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' show ClientException;
import 'package:logger/logger.dart';

/// Helper class that executes network requests and handles errors
class Executor {
  const Executor(this.logger);
  final Logger logger;

  /// Executes a network request and handles errors, including IO errors.
  ///
  /// Returns an [Either] with a [RequestFailure]
  /// or the transformed success type [RightType].
  Future<Either<RequestFailure, RightType>> execute<Dto, RightType>(
    Future<Response<Dto>> Function() request,
    RightType Function(Dto dto) transformer,
  ) async {
    try {
      final response = await request();
      if (response.isSuccessful) {
        return Right(transformer(response.body as Dto));
      } else {
        logger.e('API failure: (${response.statusCode}) ${response.error}');
        return Left(RequestHttpFailure.fromResponse(response));
      }
    } on SocketException catch (e) {
      logger.e('HTTP client failure: ${e.message}');
      return Left(RequestFailure(Strings.noInternet));
    } on ClientException catch (e) {
      logger.e('HTTP client failure: ${e.message}');
      return Left(RequestFailure(Strings.noInternet));
    }
  }
}
