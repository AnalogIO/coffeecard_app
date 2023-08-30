import 'package:chopper/chopper.dart' show Response;
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/utils/firebase_analytics_event_logging.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';

typedef _NetworkRequest<Result> = Future<Response<Result>> Function();

class NetworkRequestExecutor {
  final Logger logger;
  final FirebaseAnalyticsEventLogging firebaseLogger;

  const NetworkRequestExecutor({
    required this.logger,
    required this.firebaseLogger,
  });

  /// Executes the network [request] and returns the result as an [Either].
  Future<Either<NetworkFailure, R>> execute<R>(_NetworkRequest<R> request) {
    return _execute(request);
  }

  /// Executes the network [request] and returns the result as an [Either],
  /// where the Right value of type [ResponseType] is transformed to an [R]
  /// using the given [transformer].
  Future<Either<NetworkFailure, R>> executeAndMap<R, ResponseType>(
    _NetworkRequest<ResponseType> request,
    R Function(ResponseType) transformer,
  ) async {
    final result = await execute(request);
    return result.map(transformer);
  }

  /// Executes the network [request] and returns the result as an [Either],
  /// where the Right value is an [Iterable] of [ResponseType], where each
  /// element herein is transformed to an [R] using the given [transformer].
  ///
  /// The result is returned as a [List].
  // TODO(marfavi): return Iterable instead of List?
  Future<Either<NetworkFailure, List<R>>> executeAndMapAll<R, ResponseType>(
    _NetworkRequest<Iterable<ResponseType>> request,
    R Function(ResponseType) transformer,
  ) {
    return executeAndMap(
      request,
      (items) => items.map(transformer).toList(),
    );
  }

  /// Executes a network request and returns the result as an [Either].
  Future<Either<NetworkFailure, Result>> _execute<Result>(
    Future<Response<Result>> Function() request,
  ) async {
    try {
      final response = await request();

      // request is successful if response code is >= 200 && <300
      if (!response.isSuccessful) {
        _logResponse(response);
        return Left(ServerFailure.fromResponse(response));
      }

      return Right(response.body as Result);
    } on Exception catch (e) {
      // could not connect to backend for whatever reason
      logger.e(e.toString());
      return const Left(ConnectionFailure());
    }
  }

  /// Logs the response to the console and to Firebase.
  ///
  /// Does not log 401 responses to Firebase since these are expected when
  /// the user is not logged in.
  void _logResponse<T>(Response<T> response) {
    logger.e(response.toString());

    if (response.statusCode != 401) {
      firebaseLogger.errorEvent(response.toString());
    }
  }
}
