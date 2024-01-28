import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/product/product_repository.dart';
import 'package:coffeecard/features/ticket/data/datasources/ticket_remote_data_source.dart';
import 'package:coffeecard/features/ticket/domain/usecases/load_tickets.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.models.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'load_tickets_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<TicketRemoteDataSource>(),
  MockSpec<ProductRepository>(),
])
void main() {
  late LoadTickets usecase;
  late MockTicketRemoteDataSource ticketRemoteDataSource;
  late MockProductRepository productRepository;

  setUp(() {
    ticketRemoteDataSource = MockTicketRemoteDataSource();
    productRepository = MockProductRepository();

    usecase = LoadTickets(
      ticketRemoteDataSource: ticketRemoteDataSource,
      productRepository: productRepository,
    );

    provideDummy<TaskEither<Failure, Iterable<TicketResponse>>>(
      TaskEither.left(const ConnectionFailure()),
    );
  });

  test('should call repository', () async {
    // arrange
    when(ticketRemoteDataSource.getUserTickets())
        .thenAnswer((_) => TaskEither.fromEither(const Right([])));

    // act
    await usecase().run();

    // assert
    verify(ticketRemoteDataSource.getUserTickets());
  });
}
