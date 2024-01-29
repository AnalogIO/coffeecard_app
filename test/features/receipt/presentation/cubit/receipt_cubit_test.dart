import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/domain/usecases/get_receipts.dart';
import 'package:coffeecard/features/receipt/presentation/cubit/receipt_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'receipt_cubit_test.mocks.dart';

@GenerateMocks([GetReceipts])
void main() {
  late ReceiptCubit cubit;
  late MockGetReceipts getReceipts;

  setUp(() {
    getReceipts = MockGetReceipts();
    cubit = ReceiptCubit(getReceipts: getReceipts);

    provideDummy<Either<Failure, List<Receipt>>>(
      const Left(ConnectionFailure()),
    );
  });

  group('fetchReceipts', () {
    blocTest(
      'should have [Error] status when use case fails',
      build: () => cubit,
      setUp: () => when(getReceipts.call()).thenAnswer(
        (_) async => const Left(ServerFailure('some error', 500)),
      ),
      act: (_) => cubit.fetchReceipts(),
      expect: () =>
          [ReceiptState(status: ReceiptStatus.failure, error: 'some error')],
    );

    blocTest(
      'should have [Success] status when use case succeeds',
      build: () => cubit,
      setUp: () =>
          when(getReceipts.call()).thenAnswer((_) async => const Right([])),
      act: (_) => cubit.fetchReceipts(),
      expect: () => [
        ReceiptState(
          status: ReceiptStatus.success,
          receipts: const [],
          filteredReceipts: const [],
        ),
      ],
    );
  });

  group('filterReceipts', () {
    final testReceipts = [
      SwipeReceipt(
        id: 1,
        productName: 'Coffee',
        timeUsed: DateTime.now(),
        menuItemName: 'Espresso',
      ),
      SwipeReceipt(
        id: 2,
        productName: 'Coffee',
        timeUsed: DateTime.now(),
        menuItemName: 'Espresso',
      ),
    ];

    blocTest(
      'should not emit new state if filter is the same',
      build: () => cubit,
      act: (_) => cubit.filterReceipts(ReceiptFilterCategory.all),
      expect: () => [],
    );

    blocTest<ReceiptCubit, ReceiptState>(
      'should emit new state with filter applied',
      build: () => cubit,
      seed: () => ReceiptState(receipts: testReceipts),
      act: (_) => cubit.filterReceipts(ReceiptFilterCategory.purchases),
      expect: () => [
        ReceiptState(
          receipts: testReceipts,
          filteredReceipts: const [],
          filterBy: ReceiptFilterCategory.purchases,
        ),
      ],
    );
  });
}
