import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/ticket/domain/entities/ticket.dart';
import 'package:coffeecard/features/ticket/domain/usecases/consume_ticket.dart';
import 'package:coffeecard/features/ticket/domain/usecases/load_tickets.dart';
import 'package:coffeecard/features/ticket/presentation/cubit/tickets_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
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

    provideDummy<TaskEither<Failure, List<Ticket>>>(
      TaskEither.left(const ConnectionFailure()),
    );
    provideDummy<TaskEither<Failure, Receipt>>(
      TaskEither.left(const ConnectionFailure()),
    );
  });

  group('getTickets', () {
    blocTest<TicketsCubit, TicketsState>(
      'should emit [Loaded] when use case succeeds',
      build: () => cubit,
      setUp: () => when(loadTickets()).thenAnswer((_) => TaskEither.right([])),
      act: (_) => cubit.getTickets(),
      expect: () => [
        const TicketsLoaded(tickets: []),
      ],
    );

    blocTest<TicketsCubit, TicketsState>(
      'should emit [Error] when use case fails',
      build: () => cubit,
      setUp: () => when(loadTickets()).thenAnswer(
        (_) => TaskEither.left(const ServerFailure('some error', 500)),
      ),
      act: (_) => cubit.getTickets(),
      expect: () => [
        const TicketsLoadError(message: 'some error'),
      ],
    );
  });
  group('useTicket', () {
    final testReceipt = PlaceholderReceipt();

    blocTest<TicketsCubit, TicketsState>(
      'should not emit new state when state is not [Loaded]',
      build: () => cubit,
      setUp: () {
        when(loadTickets()).thenAnswer((_) => TaskEither.right([]));
        when(
          consumeTicket(
            productId: anyNamed('productId'),
            menuItemId: anyNamed('menuItemId'),
          ),
        ).thenAnswer((_) => TaskEither.right(testReceipt));
      },
      act: (cubit) => cubit.useTicket(0, 0),
      expect: () => [],
    );

    blocTest<TicketsCubit, TicketsState>(
      'should emit [Using, Used, Loaded] when state is Loaded',
      build: () => cubit,
      setUp: () async {
        when(loadTickets()).thenAnswer((_) => TaskEither.right([]));
        when(
          consumeTicket(
            productId: anyNamed('productId'),
            menuItemId: anyNamed('menuItemId'),
          ),
        ).thenAnswer((_) => TaskEither.right(testReceipt));
        await cubit.getTickets();
      },
      act: (_) async {
        await cubit.useTicket(0, 0);
      },
      expect: () => [
        const TicketUsing(tickets: []),
        TicketUsed(receipt: testReceipt, tickets: const []),
        const TicketsLoaded(tickets: []),
      ],
    );

    blocTest<TicketsCubit, TicketsState>(
      'should emit [Using, Error, Loaded] when state is Loaded',
      build: () => cubit,
      setUp: () async {
        when(loadTickets()).thenAnswer((_) => TaskEither.right([]));
        when(
          consumeTicket(
            productId: anyNamed('productId'),
            menuItemId: anyNamed('menuItemId'),
          ),
        ).thenAnswer(
          (_) => TaskEither.left(const ServerFailure('some error', 500)),
        );
        await cubit.getTickets();
      },
      act: (_) async {
        await cubit.useTicket(0, 0);
      },
      expect: () => [
        const TicketUsing(tickets: []),
        const TicketsUseError(message: 'some error', tickets: []),
        const TicketsLoaded(tickets: []),
      ],
    );
  });

  group('refreshTickets', () {
    blocTest<TicketsCubit, TicketsState>(
      'should emit [Loaded] when use case succeeds',
      build: () => cubit,
      setUp: () async {
        when(loadTickets()).thenAnswer((_) => TaskEither.right([]));
        await cubit.getTickets();
      },
      act: (cubit) => cubit.refreshTickets(),
      expect: () => const [
        TicketsRefreshing(tickets: []),
        TicketsLoaded(tickets: []),
      ],
    );

    blocTest<TicketsCubit, TicketsState>(
      'should emit [Error] when use case fails',
      build: () => cubit,
      setUp: () async {
        when(loadTickets()).thenAnswer((_) => TaskEither.right([]));
        await cubit.getTickets();
        when(loadTickets()).thenAnswer(
          (_) => TaskEither.left(const ServerFailure('some error', 500)),
        );
      },
      act: (cubit) => cubit.refreshTickets(),
      expect: () => const [
        TicketsRefreshing(tickets: []),
        TicketsLoadError(message: 'some error'),
      ],
    );
  });
}
