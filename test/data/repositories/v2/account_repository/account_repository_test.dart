import 'package:coffeecard/core/network/executor.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart'
    hide MessageResponseDto;
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart'
    show CoffeecardApiV2, MessageResponseDto;
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'account_repository_test.mocks.dart';

@GenerateMocks([CoffeecardApi, CoffeecardApiV2, Executor])
void main() {
  late MockCoffeecardApi apiV1;
  late MockCoffeecardApiV2 apiV2;
  late MockExecutor executor;
  late AccountRepository repository;

  setUp(() {
    apiV1 = MockCoffeecardApi();
    apiV2 = MockCoffeecardApiV2();

    executor = MockExecutor();
    repository = AccountRepository(
      apiV1: apiV1,
      apiV2: apiV2,
      executor: executor,
    );
  });

  test('should call executor', () async {
    // arrange
    when(executor.call<MessageResponseDto?>(any)).thenAnswer(
      (_) => Future.value(),
    );

    // act
    final actual = await repository.register('name', 'email', 'passcode', 0);

    // assert
    expect(actual, const Right(null));
  });
}
