import 'package:chopper/chopper.dart' as chopper;
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.swagger.dart'
    show CoffeecardApiV2;
import 'package:coffeecard/models/api/unauthorized_error.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'account_repository_test.mocks.dart';

@GenerateMocks([CoffeecardApi, CoffeecardApiV2, Logger])
void main() {
  test('register given successfull api response returns right', () async {
    final _coffeecardApi = MockCoffeecardApi();

    final _repository = AccountRepository(
      _coffeecardApi,
      MockCoffeecardApiV2(),
      MockLogger(),
    );

    when(_coffeecardApi.apiV1AccountRegisterPost(body: anyNamed('body')))
        .thenAnswer(
      (_) => Future.value(
        chopper.Response(Response('', 200), null),
      ),
    );

    final actual = await _repository.register('name', 'email', 'passcode');
    const Either<UnauthorizedError, void> expected = Right(null);

    expect(expected.isRight, actual.isRight);
  });

  test('register given unsuccessfull api response returns left', () async {
    final _coffeecardApi = MockCoffeecardApi();

    final _repository = AccountRepository(
      _coffeecardApi,
      MockCoffeecardApiV2(),
      MockLogger(),
    );

    when(_coffeecardApi.apiV1AccountRegisterPost(body: anyNamed('body')))
        .thenAnswer(
      (_) => Future.value(
        chopper.Response(Response('not found', 404), null),
      ),
    );

    final actual = await _repository.register('name', 'email', 'passcode');
    final Either<UnauthorizedError, void> expected =
        Left(UnauthorizedError('not found'));

    expect(expected.isLeft, actual.isLeft);
  });
}
