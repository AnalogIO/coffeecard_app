import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/ticket/data/datasources/ticket_remote_data_source.dart';
import 'package:coffeecard/features/ticket/data/models/ticket_count_model.dart';
import 'package:coffeecard/features/ticket/domain/usecases/load_tickets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'load_tickets_test.mocks.dart';

@GenerateMocks([TicketRemoteDataSource])
void main() {
  late LoadTickets usecase;
  late MockTicketRemoteDataSource ticketRemoteDataSource;

  setUp(() {
    ticketRemoteDataSource = MockTicketRemoteDataSource();
    usecase = LoadTickets(ticketRemoteDataSource: ticketRemoteDataSource);

    provideDummy<Either<NetworkFailure, List<TicketCountModel>>>(
      const Left(ConnectionFailure()),
    );
  });

  test('should call repository', () async {
    // arrange
    when(ticketRemoteDataSource.getUserTickets())
        .thenAnswer((_) async => const Right([]));

    // act
    await usecase();

    // assert
    verify(ticketRemoteDataSource.getUserTickets());
  });
}
