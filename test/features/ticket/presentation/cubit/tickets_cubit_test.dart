import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/ticket/domain/usecases/consume_ticket.dart';
import 'package:coffeecard/features/ticket/domain/usecases/load_tickets.dart';
import 'package:coffeecard/features/ticket/presentation/cubit/tickets_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tickets_cubit_test.mocks.dart';

@GenerateMocks([LoadTickets, ConsumeTicket])
void main() {
  late MockLoadTickets loadTickets;
  late MockConsumeTicket consumeTicket;
  late TicketsCubit cubit;

  setUp(() {
    loadTickets = MockLoadTickets();
    consumeTicket = MockConsumeTicket();
    cubit = TicketsCubit(
      loadTickets: loadTickets,
      consumeTicket: consumeTicket,
    );
  });

  group('getTickets', () {
    blocTest<TicketsCubit, TicketsState>(
      'should emit [Loading, Loaded] when use case succeeds',
      build: () => cubit,
      setUp: () =>
          when(loadTickets(any)).thenAnswer((_) async => const Right([])),
      act: (_) => cubit.getTickets(),
      expect: () => [
        const TicketsLoading(),
        const TicketsLoaded([]),
      ],
    );

    blocTest<TicketsCubit, TicketsState>(
      'should emit [Loading, Error] when use case fails',
      build: () => cubit,
      setUp: () => when(loadTickets(any)).thenAnswer(
        (_) async => const Left(ServerFailure('some error')),
      ),
      act: (_) => cubit.getTickets(),
      expect: () => [
        const TicketsLoading(),
        const TicketsLoadError('some error'),
      ],
    );
  });
  group('useTicket', () {
    final tReceipt = Receipt(
      productName: 'productName',
      transactionType: TransactionType.placeholder,
      timeUsed: DateTime.now(),
      id: 0,
    );

    blocTest<TicketsCubit, TicketsState>(
      'should not emit new state when state is not [Loaded]',
      build: () => cubit,
      setUp: () {
        when(loadTickets(any)).thenAnswer((_) async => const Right([]));
        when(consumeTicket(any)).thenAnswer((_) async => Right(tReceipt));
      },
      act: (cubit) => cubit.useTicket(0),
      expect: () => [],
    );

    blocTest<TicketsCubit, TicketsState>(
      'should emit [Using, Used, Loaded] when state is Loaded',
      build: () => cubit,
      setUp: () {
        when(loadTickets(any)).thenAnswer((_) async => const Right([]));
        when(consumeTicket(any)).thenAnswer((_) async => Right(tReceipt));
      },
      act: (_) async {
        await cubit.getTickets();
        cubit.useTicket(0);
      },
      // skip the initial Loading/Loaded states emitted by getTickets
      skip: 2,
      expect: () => [
        const TicketUsing([]),
        TicketUsed(tReceipt, const []),
        const TicketsLoaded([]),
      ],
    );

    blocTest<TicketsCubit, TicketsState>(
      'should emit [Using, Error Loaded] when state is Loaded',
      build: () => cubit,
      setUp: () {
        when(loadTickets(any)).thenAnswer((_) async => const Right([]));
        when(consumeTicket(any)).thenAnswer(
          (_) async => const Left(ServerFailure('some error')),
        );
      },
      act: (_) async {
        await cubit.getTickets();
        cubit.useTicket(0);
      },
      // skip the initial Loading/Loaded states emitted by getTickets
      skip: 2,
      expect: () => [
        const TicketUsing([]),
        const TicketsUseError('some error'),
        const TicketsLoaded([]),
      ],
    );
  });
  group('refreshTickets', () {
    blocTest<TicketsCubit, TicketsState>(
      'should emit [Loaded] when use case succeeds',
      build: () => cubit,
      setUp: () =>
          when(loadTickets(any)).thenAnswer((_) async => const Right([])),
      act: (_) => cubit.refreshTickets(),
      expect: () => [const TicketsLoaded([])],
    );

    blocTest<TicketsCubit, TicketsState>(
      'should emit [Error] when use case fails',
      build: () => cubit,
      setUp: () => when(loadTickets(any)).thenAnswer(
        (_) async => const Left(ServerFailure('some error')),
      ),
      act: (_) => cubit.refreshTickets(),
      expect: () => [const TicketsLoadError('some error')],
    );
  });
}
