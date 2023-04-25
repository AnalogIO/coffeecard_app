import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/ticket/data/datasources/ticket_remote_data_source.dart';
import 'package:coffeecard/data/repositories/barista_product/barista_product_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
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
        baristaProductsRepository: baristaProductsRepository);
  });

  group('getUserTickets', () {
    test('should return [Right] when executor returns [Right]', () async {
      // arrange
      when(executor.call<List<TicketResponse>>(any))
          .thenAnswer((_) async => const Right([]));
      when(baristaProductsRepository.getBaristaProductIds())
          .thenAnswer((_) => const []);

      // act
      final actual = await dataSource.getUserTickets();

      // assert
      expect(actual.isRight(), isTrue);
    });

    test('should return [Left] if executor returns [Left]', () async {
      // arrange
      when(executor.call<List<TicketResponse>>(any))
          .thenAnswer((_) async => const Left(ServerFailure('some error')));
      when(baristaProductsRepository.getBaristaProductIds())
          .thenAnswer((_) => const []);

      // act
      final actual = await dataSource.getUserTickets();

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });
  });

  group('useTicket', () {
    test('should return [Right] when executor returns [Right]', () async {
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
    });

    test('should return [Left] if executor returns [Left]', () async {
      // arrange
      when(executor.call<TicketDto>(any))
          .thenAnswer((_) async => const Left(ServerFailure('some error')));

      // act
      final actual = await dataSource.useTicket(0);

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });
  });
}
