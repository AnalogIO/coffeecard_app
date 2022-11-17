import 'package:chopper/chopper.dart' as chopper;
import 'package:coffeecard/data/repositories/utils/executor.dart';
import 'package:coffeecard/data/repositories/v1/ticket_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../responses.dart';
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
    when(apiV2.apiV2TicketsGet(includeUsed: anyNamed('includeUsed')))
        .thenAnswer(
      (_) async => chopper.Response(Responses.succeeding(), const []),
    );

    final actual = await repo.getUserTickets();
    expect(actual.isRight, isTrue);
  });

  test('getUserTickets given unsuccessfull api response returns left',
      () async {
    when(apiV2.apiV2TicketsGet(includeUsed: anyNamed('includeUsed')))
        .thenAnswer(
      (_) async => chopper.Response(Responses.failing(), const []),
    );

    final actual = await repo.getUserTickets();
    expect(actual.isLeft, isTrue);
  });
}
