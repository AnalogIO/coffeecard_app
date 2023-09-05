import 'package:chopper/chopper.dart' show Response;
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/utils/firebase_analytics_event_logging.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';

part 'network_request_executor_mapping.dart';

typedef _NetworkRequest<BodyType> = Future<Response<BodyType>> Function();
typedef _ExecutorResult<R> = Future<Either<NetworkFailure, R>>;

class NetworkRequestExecutor {
  final Logger logger;
  final FirebaseAnalyticsEventLogging firebaseLogger;

  const NetworkRequestExecutor({
    required this.logger,
    required this.firebaseLogger,
  });

  /// Executes a network request and returns an [Either].
  ///
  /// If the request fails, a [NetworkFailure] is returned in a [Left].
  /// If the request succeeds, the response body of type
  /// [Body] is returned in a [Right].
  ///
  /// If the response body type is empty or dynamic, use [executeAndDiscard]
  /// instead, which always returns [Unit] in a [Right] if the request succeeds.
  _ExecutorResult<Body> execute<Body>(_NetworkRequest<Body> request) async {
    try {
      final response = await request();

      // request is successful if response code is >= 200 && <300
      if (!response.isSuccessful) {
        _logResponse(response);
        return Left(ServerFailure.fromResponse(response));
      }
      return Right(response.body as Body);
    } on Exception catch (e) {
      // could not connect to backend for whatever reason
      logger.e(e.toString());
      return const Left(ConnectionFailure());
    }
  }

  /// Executes the network [request] and returns the result as an [Either].
  ///
  /// If the request fails, a [NetworkFailure] is returned in a [Left].
  /// If the request succeeds, [Unit] is returned in a [Right] and
  /// the orignial response body is discarded.
  ///
  /// This method is useful as it allows to discard the response body when its
  /// type is dynamic, e.g. when it is expected to be empty. This avoids having
  /// to provide dummy values for dynamic response bodies in Mockito tests.
  _ExecutorResult<Unit> executeAndDiscard<B>(_NetworkRequest<B> request) async {
    final result = await execute(request);
    return result.map((_) => unit);
  }

  /// Logs the response to the console and to Firebase.
  ///
  /// Does not log 401 responses to Firebase since these are expected when
  /// the user is not logged in.
  void _logResponse<Body>(Response<Body> response) {
    logger.e(response.toString());

    final ignoreCodes = [401];

    if (!ignoreCodes.contains(response.statusCode)) {
      firebaseLogger.errorEvent(response.toString());
    }
  }
}
