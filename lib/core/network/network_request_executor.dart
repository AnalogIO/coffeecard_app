import 'package:chopper/chopper.dart' show Response;
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/utils/firebase_analytics_event_logging.dart';
import 'package:dartz/dartz.dart';
import 'package:logger/logger.dart';

class NetworkRequestExecutor {
  final Logger logger;
  final FirebaseAnalyticsEventLogging firebaseLogger;

  const NetworkRequestExecutor({
    required this.logger,
    required this.firebaseLogger,
  });

  Future<Either<NetworkFailure, Result>> call<Result>(
    Future<Response<Result>> Function() request,
  ) async {
    try {
      final response = await request();

      // request is successful if response code is >= 200 && <300
      if (!response.isSuccessful) {
        logResponse(response);
        return Left(ServerFailure.fromResponse(response));
      }

      return Right(response.body as Result);
    } on Exception {
      // could not connect to backend for whatever reason
      return const Left(ConnectionFailure());
    }
  }

  void logResponse(Response response) {
    logger.e(response.toString());

    final ignore = [401];

    if (ignore.contains(response.statusCode)) {
      return;
    }

    firebaseLogger.errorEvent(response.toString());
  }
}
