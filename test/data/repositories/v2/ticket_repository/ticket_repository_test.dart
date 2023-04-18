import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/data/repositories/barista_product/barista_product_repository.dart';
import 'package:coffeecard/data/repositories/v1/ticket_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/utils/firebase_analytics_event_logging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../response.dart';
import 'ticket_repository_test.mocks.dart';

@GenerateMocks(
  [CoffeecardApi, CoffeecardApiV2, Logger, FirebaseAnalyticsEventLogging],
)
void main() {
  late MockCoffeecardApi apiV1;
  late MockCoffeecardApiV2 apiV2;
  late MockLogger logger;

  late NetworkRequestExecutor executor;
  late TicketRepository repo;
  late BaristaProductsRepository baristaProductsRepository;
  late MockFirebaseAnalyticsEventLogging firebaseLogger;

  setUp(() {
    apiV1 = MockCoffeecardApi();
    apiV2 = MockCoffeecardApiV2();
    logger = MockLogger();
    firebaseLogger = MockFirebaseAnalyticsEventLogging();

    executor = NetworkRequestExecutor(
      logger: logger,
      firebaseLogger: firebaseLogger,
    );
    baristaProductsRepository = BaristaProductsRepository();
    repo = TicketRepository(
      apiV1: apiV1,
      apiV2: apiV2,
      executor: executor,
      baristaProductsRepository: baristaProductsRepository,
    );
  });

  test('getUserTickets given successfull api response returns right', () async {
    // arrange
    when(apiV2.apiV2TicketsGet(includeUsed: anyNamed('includeUsed')))
        .thenAnswer(
      (_) async => responseFromStatusCode(200, body: []),
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
      (_) async => responseFromStatusCode(500, body: []),
    );
    when(firebaseLogger.errorEvent(any)).thenReturn(null);

    // act
    final actual = await repo.getUserTickets();

    // assert
    expect(actual.isLeft(), isTrue);
  });
}
