import 'package:chopper/chopper.dart' as chopper;
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/core/strings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';

import 'network_request_executor_test.mocks.dart';

@GenerateMocks([Logger])
void main() {
  late MockLogger logger;
  late NetworkRequestExecutor executor;

  setUp(() {
    logger = MockLogger();
    executor = NetworkRequestExecutor(logger: logger);
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

  group('execute', () {
    test('should return [ServerFailure] if api call fails', () async {
      // arrange
      final testResponse = responseFromStatusCode(500, body: '');

      // act
      final actual = await executor.execute(() async => testResponse);

      // assert
      expect(
        actual,
        const Left(ServerFailure(Strings.unknownErrorOccured, 500)),
      );
    });

    test('should return response body if api call succeeds', () async {
      // arrange
      final testResponse = responseFromStatusCode(200, body: 'some string');

      // act
      final actual = await executor.execute(() async => testResponse);

      // assert
      expect(actual, const Right('some string'));
    });

    test('should return [ConnectionFailure] if exception is caught', () async {
      // arrange
      final testException = Exception('some error');

      // act
      final actual = await executor.execute(() async => throw testException);

      // assert
      expect(actual, const Left(ConnectionFailure()));
    });
  });

  group('executeAndDiscard', () {
    test('should return [Unit] if api call succeeds', () async {
      // arrange
      final testResponse = responseFromStatusCode(200, body: 'some string');

      // act
      final actual = await executor.executeAndDiscard(() async => testResponse);

      // assert
      expect(actual, const Right(unit));
    });
  });
}
