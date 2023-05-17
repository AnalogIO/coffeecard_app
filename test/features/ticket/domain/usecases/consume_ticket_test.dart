import 'package:coffeecard/core/errors/failures.dart';
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
  });

  test('should call repository', () async {
    // arrange
    when(ticketRemoteDataSource.useTicket(any))
        .thenAnswer((_) async => const Left(ServerFailure('some error')));

    // act
    await usecase(const Params(productId: 0));

    // assert
    verify(ticketRemoteDataSource.useTicket(any));
  });
}
