import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/voucher_code.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'voucher_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<VoucherCodeRepository>()])
void main() {
  late MockVoucherCodeRepository repository;
  late VoucherCubit cubit;

  setUp(() {
    repository = MockVoucherCodeRepository();
    cubit = VoucherCubit(voucherCodeRepository: repository);

    provideDummy<TaskEither<Failure, RedeemedVoucher>>(
      TaskEither.left(const ConnectionFailure()),
    );
  });

  const testErrorMessage = 'a';
  const testRedeemedVoucher = RedeemedVoucher(
    numberOfTickets: 0,
    productName: 'b',
  );

  group('redeemVoucher', () {
    blocTest(
      'GIVEN voucher code "c" is invalid '
      'WHEN redeemVoucherCode("c") is called '
      'THEN '
      '1) it should call repository.redeemVoucherCode("c") '
      '2) it should emit [Loading, Error(error message)]',
      build: () => cubit,
      setUp: () => when(repository.redeemVoucherCode(any)).thenReturn(
        TaskEither.left(const ServerFailure(testErrorMessage, 500)),
      ),
      act: (_) => cubit.redeemVoucherCode('c'),
      verify: (_) => verify(repository.redeemVoucherCode('c')).called(1),
      expect: () => const [
        VoucherLoading(),
        VoucherError(testErrorMessage),
      ],
    );

    blocTest(
      'GIVEN voucher code "c" is valid '
      'WHEN redeemVoucherCode("c") is called '
      'THEN '
      '1) it should call repository.redeemVoucherCode("c") '
      '2) it should emit [Loading, Success(redeemed voucher)]',
      build: () => cubit,
      setUp: () => when(repository.redeemVoucherCode(any)).thenReturn(
        TaskEither.of(testRedeemedVoucher),
      ),
      act: (_) => cubit.redeemVoucherCode('c'),
      verify: (_) => verify(repository.redeemVoucherCode('c')).called(1),
      expect: () => const [
        VoucherLoading(),
        VoucherSuccess(testRedeemedVoucher),
      ],
    );
  });
}
