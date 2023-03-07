import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/executor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';

import '../../response.dart';
import 'executor_test.mocks.dart';

@GenerateMocks([Logger])
void main() {
  late MockLogger logger;
  late Executor executor;

  setUp(() {
    logger = MockLogger();
    executor = Executor(logger);
  });

  test('should return [ServerFailure] if api call fails', () async {
    // arrange
    final tResponse = Response.fromStatusCode(500, body: 'some error');

    // act
    final actual = executor(() async => tResponse);

    // assert
    expect(actual, const ServerFailure('some error'));
  });

  test('should return response body if api call succeeds', () async {
    // arrange
    final tResponse = Response.fromStatusCode(200, body: 'some string');

    // act
    final actual = await executor(() async => tResponse);

    // assert
    expect(actual, 'some string');
  });
}
