import 'package:coffeecard/core/network/executor.dart';
import 'package:coffeecard/data/repositories/v1/ticket_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../response.dart';
import 'ticket_repository_test.mocks.dart';

@GenerateMocks([CoffeecardApi, CoffeecardApiV2, Logger])
void main() {
  late MockCoffeecardApi apiV1;
  late MockCoffeecardApiV2 apiV2;
  late MockLogger logger;

  late Executor executor;
  late TicketRepository repo;

  setUp(() {
    apiV1 = MockCoffeecardApi();
    apiV2 = MockCoffeecardApiV2();
    logger = MockLogger();

    executor = Executor(logger);
    repo = TicketRepository(apiV1: apiV1, apiV2: apiV2, executor: executor);
  });

  test('getUserTickets given successfull api response returns right', () async {
    // arrange
    when(apiV2.apiV2TicketsGet(includeUsed: anyNamed('includeUsed')))
        .thenAnswer(
      (_) async => Response.fromStatusCode(200, body: []),
    );

    // act
    final actual = await repo.getUserTickets();

    // assert
    expect(actual.isRight(), isTrue);
  });

  test('getUserTickets given unsuccessfull api response returns left',
      () async {
    // arrange
    when(apiV2.apiV2TicketsGet(includeUsed: anyNamed('includeUsed')))
        .thenAnswer(
      (_) async => Response.fromStatusCode(500, body: []),
    );

    // act
    final actual = await repo.getUserTickets();

    // assert
    expect(actual.isLeft(), isTrue);
  });
}
