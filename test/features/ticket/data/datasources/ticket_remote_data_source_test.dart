import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/ticket/data/datasources/ticket_remote_data_source.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'ticket_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CoffeecardApiV2>(),
  MockSpec<NetworkRequestExecutor>(),
])
void main() {
  late MockCoffeecardApiV2 apiV2;
  late MockNetworkRequestExecutor executor;
  late TicketRemoteDataSource dataSource;

  setUp(() {
    apiV2 = MockCoffeecardApiV2();
    executor = MockNetworkRequestExecutor();
    dataSource = TicketRemoteDataSource(api: apiV2, executor: executor);

    provideDummy<TaskEither<Failure, Iterable<TicketResponse>>>(
      TaskEither.left(const ConnectionFailure()),
    );
    provideDummy<Either<Failure, List<TicketResponse>>>(
      const Left(ConnectionFailure()),
    );
    provideDummy<Either<Failure, UsedTicketResponse>>(
      const Left(ConnectionFailure()),
    );
    provideDummy<TaskEither<Failure, UsedTicketResponse>>(
      TaskEither.left(const ConnectionFailure()),
    );
  });

  group('getUserTickets', () {
    test(
      'GIVEN executor returns a [Right] value '
      'WHEN calling getUserTickets '
      'THEN a [Right] value is returned',
      () async {
        // arrange
        when(executor.executeAsTask<Iterable<TicketResponse>>(any))
            .thenAnswer((_) => TaskEither.right([]));

        // act
        final actual = await dataSource.getUserTickets().run();

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
        when(executor.executeAsTask<Iterable<TicketResponse>>(any)).thenAnswer(
          (_) => TaskEither.left(const ServerFailure('some error', 500)),
        );

        // act
        final actual = await dataSource.getUserTickets().run();

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
        when(executor.executeAsTask<Iterable<TicketResponse>>(any)).thenAnswer(
          (_) => TaskEither.right([
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
        final actual = await dataSource.getUserTickets().run();

        // assert
        expect(actual.isRight(), isTrue);
        final right = actual.getOrElse((_) => []);
        expect(right, hasLength(2));
        expect(right.first.productId, equals(0));
        expect(right.first.productName, anyOf(['A/B', 'B/A']));
      },
      // TODO(marfavi): This test no longer belongs at this level. Skip for now.
      skip: 'This test no longer belongs at this level. Skip for now',
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
          when(executor.executeAsTask<UsedTicketResponse>(any)).thenAnswer(
            (_) => TaskEither.right(
              UsedTicketResponse(
                id: 0,
                dateCreated: DateTime.parse('2023-04-11'),
                dateUsed: DateTime.parse('2023-04-11'),
                productName: 'productName',
                menuItemName: 'menuItemName',
              ),
            ),
          );

          // act
          final actual = await dataSource.useTicket(0, 0).run();

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
          when(executor.executeAsTask<UsedTicketResponse>(any)).thenAnswer(
            (_) => TaskEither.left(const ServerFailure('some error', 500)),
          );

          // act
          final actual = await dataSource.useTicket(0, 0).run();

          // assert
          expect(actual.isLeft(), isTrue);
        },
      );
    },
  );
}
