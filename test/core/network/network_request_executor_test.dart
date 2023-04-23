import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/utils/firebase_analytics_event_logging.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';

import '../../response.dart';
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

  test('should return [ServerFailure] if api call fails', () async {
    // arrange
    final tResponse = responseFromStatusCode(500, body: '');

    // act
    final actual = await executor(() async => tResponse);

    // assert
    expect(actual, const Left(ServerFailure('')));
  });

  test('should return response body if api call succeeds', () async {
    // arrange
    final tResponse = responseFromStatusCode(200, body: 'some string');

    // act
    final actual = await executor(() async => tResponse);

    // assert
    expect(actual, const Right('some string'));
  });

  test('should return [ServerFailure] if call throws [Exception]', () async {
    // arrange
    final tException = Exception('some error');

    // act
    final actual = await executor(() async => throw tException);

    // assert
    expect(actual, const Left(ConnectionFailure()));
  });
}
