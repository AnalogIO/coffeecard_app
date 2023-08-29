import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/data/repositories/barista_product/barista_product_repository.dart';
import 'package:coffeecard/features/ticket/data/datasources/ticket_remote_data_source.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'ticket_remote_data_source_test.mocks.dart';

@GenerateMocks(
  [
    CoffeecardApi,
    CoffeecardApiV2,
    NetworkRequestExecutor,
    BaristaProductsRepository,
  ],
)
void main() {
  late MockCoffeecardApi apiV1;
  late MockCoffeecardApiV2 apiV2;
  late MockNetworkRequestExecutor executor;
  late TicketRemoteDataSource dataSource;
  late BaristaProductsRepository baristaProductsRepository;

  setUp(() {
    apiV1 = MockCoffeecardApi();
    apiV2 = MockCoffeecardApiV2();
    executor = MockNetworkRequestExecutor();
    baristaProductsRepository = MockBaristaProductsRepository();
    dataSource = TicketRemoteDataSource(
      apiV1: apiV1,
      apiV2: apiV2,
      executor: executor,
      baristaProductsRepository: baristaProductsRepository,
    );
  });

  group('getUserTickets', () {
    test(
      'GIVEN executor returns a [Right] value '
      'WHEN calling getUserTickets '
      'THEN a [Right] value is returned',
      () async {
        // arrange
        when(executor.call<List<TicketResponse>>(any))
            .thenAnswer((_) async => const Right([]));

        // act
        final actual = await dataSource.getUserTickets();

        // assert
        expect(actual.isRight(), isTrue);
      },
    );

    test(
      'GIVEN executor returns a [Left] value '
      'WHEN calling getUserTickets '
      'THEN a [Left] value is returned',
      () async {
        // arrange
        when(executor.call<List<TicketResponse>>(any))
            .thenAnswer((_) async => const Left(ServerFailure('some error')));

        // act
        final actual = await dataSource.getUserTickets();

        // assert
        expect(actual.isLeft(), isTrue);
      },
    );

    test(
      'GIVEN executor returns two [TicketResponse] with the same product id but different product names '
      'WHEN calling getUserTickets '
      'THEN a [TicketCountModel] with the count of tickets and joined ticket names is returned',
      () async {
        // arrange
        when(executor.call<List<TicketResponse>>(any)).thenAnswer(
          (_) async => Right([
            TicketResponse(
              id: 0,
              dateCreated: DateTime.parse('2023-05-23'),
              dateUsed: null,
              productId: 0,
              productName: 'A',
            ),
            TicketResponse(
              id: 0,
              dateCreated: DateTime.parse('2023-05-23'),
              dateUsed: null,
              productId: 0,
              productName: 'B',
            ),
          ]),
        );

        // act
        final actual = await dataSource.getUserTickets();

        // assert
        expect(actual.isRight(), isTrue);
        final right = actual.getOrElse((_) => []);
        expect(right, hasLength(1));
        expect(right.first.productId, equals(0));
        expect(right.first.count, equals(2));
        expect(right.first.productName, anyOf(['A/B', 'B/A']));
      },
    );
  });

  group(
    'useTicket',
    () {
      test(
        'GIVEN executor returns a [Right] value '
        'WHEN calling useTicket '
        'THEN a [Right] value is returned',
        () async {
          // arrange
          when(executor.call<TicketDto>(any)).thenAnswer(
            (_) async => Right(
              TicketDto(
                id: 0,
                dateCreated: DateTime.parse('2023-04-11'),
                dateUsed: DateTime.parse('2023-04-11'),
                productName: 'productName',
              ),
            ),
          );

          // act
          final actual = await dataSource.useTicket(0);

          // assert
          expect(actual.isRight(), isTrue);
        },
      );

      test(
        'GIVEN executor returns a [Left] value '
        'WHEN calling useTicket '
        'THEN a [Left] value is returned',
        () async {
          // arrange
          when(executor.call<TicketDto>(any))
              .thenAnswer((_) async => const Left(ServerFailure('some error')));

          // act
          final actual = await dataSource.useTicket(0);

          // assert
          expect(actual.isLeft(), isTrue);
        },
      );
    },
  );
}
