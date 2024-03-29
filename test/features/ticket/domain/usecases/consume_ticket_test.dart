import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/ticket/data/datasources/ticket_remote_data_source.dart';
import 'package:coffeecard/features/ticket/domain/usecases/consume_ticket.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'consume_ticket_test.mocks.dart';

@GenerateMocks([TicketRemoteDataSource])
void main() {
  late ConsumeTicket usecase;
  late MockTicketRemoteDataSource ticketRemoteDataSource;

  setUp(() {
    ticketRemoteDataSource = MockTicketRemoteDataSource();
    usecase = ConsumeTicket(ticketRemoteDataSource: ticketRemoteDataSource);

    provideDummy<TaskEither<Failure, Receipt>>(
      TaskEither.left(const ConnectionFailure()),
    );
  });

  test('should call repository', () async {
    // arrange
    when(ticketRemoteDataSource.useTicket(any, any)).thenAnswer(
      (_) => TaskEither.left(const ServerFailure('some error', 500)),
    );

    // act
    await usecase(productId: 0, menuItemId: 0).run();

    // assert
    verify(ticketRemoteDataSource.useTicket(any, any));
  });
}
