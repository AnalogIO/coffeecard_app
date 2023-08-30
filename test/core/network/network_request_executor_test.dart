import 'package:chopper/chopper.dart' as chopper;
import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/utils/firebase_analytics_event_logging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';

import 'network_request_executor_test.mocks.dart';

@GenerateMocks([Logger, FirebaseAnalyticsEventLogging])
void main() {
  late MockLogger logger;
  late MockFirebaseAnalyticsEventLogging firebaseLogger;
  late NetworkRequestExecutor executor;

  setUp(() {
    logger = MockLogger();
    firebaseLogger = MockFirebaseAnalyticsEventLogging();
    executor = NetworkRequestExecutor(
      logger: logger,
      firebaseLogger: firebaseLogger,
    );
  });

  chopper.Response<T> responseFromStatusCode<T>(
    int statusCode, {
    T? body,
  }) {
    return chopper.Response(
      http.Response('', statusCode),
      body,
    );
  }

  test('should return [ServerFailure] if api call fails', () async {
    // arrange
    final testResponse = responseFromStatusCode(500, body: '');

    // act
    final actual = await executor.executeAndMap(
      () async => testResponse,
      identity,
    );
// TODO... MAKE SURE TO TRANSFORM ALL THE EXECUTOR CALLS TO CALLANDMAPLIST WHERE
//  IT IS APPROPRIATE
    // assert
    expect(actual, const Left(ServerFailure(Strings.unknownErrorOccured)));
  });

  test('should return response body if api call succeeds', () async {
    // arrange
    final testResponse = responseFromStatusCode(200, body: 'some string');

    // act
    final actual = await executor.execute(() async => testResponse);

    // assert
    expect(actual, const Right('some string'));
  });

  test('should return [ServerFailure] if call throws [Exception]', () async {
    // arrange
    final testException = Exception('some error');

    // act
    final actual = await executor.execute(() async => throw testException);

    // assert
    expect(actual, const Left(ConnectionFailure()));
    // FIXME: this is not the correct error message
  });
}
