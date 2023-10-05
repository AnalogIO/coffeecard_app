import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/voucher/domain/entities/redeemed_voucher.dart';
import 'package:coffeecard/features/voucher/domain/usecases/redeem_voucher_code.dart';
import 'package:coffeecard/features/voucher/presentation/cubit/voucher_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'voucher_cubit_test.mocks.dart';

@GenerateMocks([RedeemVoucherCode])
void main() {
  late MockRedeemVoucherCode redeemVoucherCode;
  late VoucherCubit cubit;

  setUp(() {
    redeemVoucherCode = MockRedeemVoucherCode();
    cubit = VoucherCubit(redeemVoucherCode: redeemVoucherCode);

    provideDummy<Either<Failure, RedeemedVoucher>>(
      const Left(ConnectionFailure()),
    );
  });

  const testErrorMessage = 'some error';

  const testRedeemedVoucher =
      RedeemedVoucher(numberOfTickets: 0, productName: 'productName');

  group('redeemVoucher', () {
    blocTest(
      'should emit [Loading, Error] when use case fails',
      build: () => cubit,
      setUp: () => when(redeemVoucherCode(any)).thenAnswer(
        (_) async => const Left(ServerFailure(testErrorMessage, 500)),
      ),
      act: (_) => cubit.redeemVoucher('voucher'),
      expect: () => [
        VoucherLoading(),
        const VoucherError(testErrorMessage),
      ],
    );

    blocTest(
      'should emit [Loading, Success] when use case succeeds',
      build: () => cubit,
      setUp: () => when(redeemVoucherCode(any)).thenAnswer(
        (_) async => const Right(testRedeemedVoucher),
      ),
      act: (_) => cubit.redeemVoucher('voucher'),
      expect: () => [
        VoucherLoading(),
        const VoucherSuccess(testRedeemedVoucher),
      ],
    );
  });
}
