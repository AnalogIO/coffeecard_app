import 'package:chopper/chopper.dart' as chopper;
import 'package:coffeecard/data/repositories/v1/ticket_repository.dart';
import 'package:coffeecard/errors/request_error.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/models/ticket/ticket_count.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../responses.dart';
import '../../v1/account_repository/account_repository_test.mocks.dart';

@GenerateMocks([CoffeecardApi, Logger])
void main() {
  test('getUserTickets given successfull api response returns right ',
      () async {
    final coffeecardApiV2 = MockCoffeecardApiV2();

    final repository = TicketRepository(
      MockCoffeecardApi(),
      coffeecardApiV2,
      MockLogger(),
    );

    when(coffeecardApiV2.apiV2TicketsGet(includeUsed: anyNamed('includeUsed')))
        .thenAnswer(
      (_) => Future.value(
        chopper.Response(Responses.succeeding(), const []),
      ),
    );

    final actual = await repository.getUserTickets();
    const Either<RequestError, List<TicketCount>> expected = Right([]);

    expect(expected.isRight, actual.isRight);
  });

  test('getUserTickets given unsuccessfull api response returns left ',
      () async {
    final coffeecardApiV2 = MockCoffeecardApiV2();

    final repository = TicketRepository(
      MockCoffeecardApi(),
      coffeecardApiV2,
      MockLogger(),
    );

    when(coffeecardApiV2.apiV2TicketsGet(includeUsed: anyNamed('includeUsed')))
        .thenAnswer(
      (_) => Future.value(
        chopper.Response(Responses.failing(), const []),
      ),
    );

    final actual = await repository.getUserTickets();
    const expected = Left(RequestError('', 0));
    expect(expected.isLeft, actual.isLeft);
  });
}
