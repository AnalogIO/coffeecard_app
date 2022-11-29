import 'package:chopper/chopper.dart' as chopper;
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/data/repositories/utils/executor.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart'
    show CoffeecardApiV2;
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../responses.dart';
import 'account_repository_test.mocks.dart';

@GenerateMocks([CoffeecardApi, CoffeecardApiV2, Logger])
void main() {
  late MockCoffeecardApi apiV1;
  late MockCoffeecardApiV2 apiV2;
  late MockLogger logger;

  late Executor executor;
  late AccountRepository repo;

  setUp(() {
    apiV1 = MockCoffeecardApi();
    apiV2 = MockCoffeecardApiV2();
    logger = MockLogger();

    executor = Executor(logger);
    repo = AccountRepository(apiV1: apiV1, apiV2: apiV2, executor: executor);
  });

  test('register given successful api response returns right', () async {
    when(apiV1.apiV1AccountRegisterPost(body: anyNamed('body'))).thenAnswer(
      (_) async {
        return chopper.Response(Responses.succeeding(), MessageResponseDto());
      },
    );

    final actual = await repo.register('name', 'email', 'passcode', 0);
    expectLater(actual.isRight, isTrue);
  });

  test('register given unsuccessful api response returns left', () async {
    when(apiV1.apiV1AccountRegisterPost(body: anyNamed('body'))).thenAnswer(
      (_) async => chopper.Response(Responses.failing(), null),
    );

    final actual = await repo.register('name', 'email', 'passcode', 0);
    expect(actual.isLeft, isTrue);
  });
}
