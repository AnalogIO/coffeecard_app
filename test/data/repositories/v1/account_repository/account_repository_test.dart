import 'package:chopper/chopper.dart' as chopper;
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/errors/request_error.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart'
    show CoffeecardApiV2;
import 'package:coffeecard/utils/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import './account_repository_test.mocks.dart';
import '../../responses.dart';

@GenerateMocks([CoffeecardApi, CoffeecardApiV2, Logger])
void main() {
  test('register given successfull api response returns right', () async {
    final coffeecardApi = MockCoffeecardApi();

    final repository = AccountRepository(
      coffeecardApi,
      MockCoffeecardApiV2(),
      MockLogger(),
    );

    when(coffeecardApi.apiV1AccountRegisterPost(body: anyNamed('body')))
        .thenAnswer(
      (_) => Future.value(
        chopper.Response(Responses.succeeding(), null),
      ),
    );

    final actual = await repository.register('name', 'email', 'passcode');
    const expected = Right(null);

    expect(expected.isRight, actual.isRight);
  });

  test('register given unsuccessfull api response returns left', () async {
    final coffeecardApi = MockCoffeecardApi();

    final repository = AccountRepository(
      coffeecardApi,
      MockCoffeecardApiV2(),
      MockLogger(),
    );

    when(coffeecardApi.apiV1AccountRegisterPost(body: anyNamed('body')))
        .thenAnswer(
      (_) => Future.value(
        chopper.Response(Responses.unauthorized(msg: 'not found'), null),
      ),
    );

    final actual = await repository.register('name', 'email', 'passcode');
    const expected = Left(RequestError('not found', 0));

    expect(expected.isLeft, actual.isLeft);
  });
}
