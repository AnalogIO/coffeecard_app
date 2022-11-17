import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/cubits/tickets/tickets_cubit.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/data/repositories/v1/ticket_repository.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tickets_cubit_test.mocks.dart';

final dummyReceipt = Receipt(
  productName: 'DUMMY_PRODUCT_NAME',
  transactionType: TransactionType.placeholder,
  timeUsed: DateTime.now(),
  price: 0,
  amountPurchased: 1,
  id: 0,
);

@GenerateMocks([TicketRepository])
void main() {
  group('tickets cubit tests', () {
    late TicketsCubit cubit;
    final repo = MockTicketRepository();

    setUp(() => cubit = TicketsCubit(repo));

    blocTest<TicketsCubit, TicketsState>(
      'getTickets emits Loading then Loaded (on successful fetch)',
      build: () {
        when(repo.getUserTickets()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.getTickets(),
      expect: () => [
        const TicketsLoading(),
        const TicketsLoaded([]),
      ],
    );

    blocTest<TicketsCubit, TicketsState>(
      'getTickets emits Loading then LoadError (on failed fetch)',
      build: () {
        when(repo.getUserTickets()).thenAnswer(
          (_) async => Left(RequestError('ERROR_MESSAGE', 0)),
        );
        return cubit;
      },
      act: (cubit) => cubit.getTickets(),
      expect: () => [
        const TicketsLoading(),
        const TicketsLoadError('ERROR_MESSAGE'),
      ],
    );

    blocTest<TicketsCubit, TicketsState>(
      'refreshTickets emits Loaded (on successful fetch)',
      build: () {
        when(repo.getUserTickets()).thenAnswer((_) async => const Right([]));
        return cubit;
      },
      act: (cubit) => cubit.refreshTickets(),
      expect: () => [const TicketsLoaded([])],
    );

    blocTest<TicketsCubit, TicketsState>(
      'refreshTickets emits LoadError (on failed fetch)',
      build: () {
        when(repo.getUserTickets()).thenAnswer(
          (_) async => Left(RequestError('ERROR_MESSAGE', 0)),
        );
        return cubit;
      },
      act: (cubit) => cubit.refreshTickets(),
      expect: () => [const TicketsLoadError('ERROR_MESSAGE')],
    );

    blocTest<TicketsCubit, TicketsState>(
      'useTicket emits nothing when state is not Loaded',
      build: () {
        when(repo.getUserTickets()).thenAnswer((_) async => const Right([]));
        when(repo.useTicket(any)).thenAnswer((_) async => Right(dummyReceipt));
        return cubit;
      },
      act: (cubit) => cubit.useTicket(0),
      expect: () => [],
    );

    blocTest<TicketsCubit, TicketsState>(
      'useTicket emits Using, Used (on success) then Loaded when state is Loaded',
      build: () {
        when(repo.getUserTickets()).thenAnswer((_) async => const Right([]));
        when(repo.useTicket(any)).thenAnswer((_) async => Right(dummyReceipt));
        return cubit;
      },
      act: (cubit) async {
        await cubit.getTickets();
        cubit.useTicket(0);
      },
      // skip the initial Loading/Loaded states emitted by getTickets
      skip: 2,
      expect: () => [
        const TicketUsing([]),
        TicketUsed(dummyReceipt, const []),
        const TicketsLoaded([]),
      ],
    );

    blocTest<TicketsCubit, TicketsState>(
      'useTicket emits Using, UseError (on use failure), then Loaded (on success fetch) when state is Loaded',
      build: () {
        when(repo.getUserTickets()).thenAnswer((_) async => const Right([]));
        when(repo.useTicket(any)).thenAnswer(
          (_) async => Left(RequestError('ERROR_MESSAGE', 0)),
        );
        return cubit;
      },
      act: (cubit) async {
        await cubit.getTickets();
        cubit.useTicket(0);
      },
      // skip the initial Loading/Loaded states emitted by getTickets
      skip: 2,
      expect: () => [
        const TicketUsing([]),
        const TicketsUseError('ERROR_MESSAGE'),
        const TicketsLoaded([]),
      ],
    );

    tearDown(() => cubit.close());
  });
}
