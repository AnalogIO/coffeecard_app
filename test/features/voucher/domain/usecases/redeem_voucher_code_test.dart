import 'package:coffeecard/features/voucher/data/datasources/voucher_remote_data_source.dart';
import 'package:coffeecard/features/voucher/domain/entities/redeemed_voucher.dart';
import 'package:coffeecard/features/voucher/domain/usecases/redeem_voucher_code.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'redeem_voucher_code_test.mocks.dart';

@GenerateMocks([VoucherRemoteDataSource])
void main() {
  late MockVoucherRemoteDataSource dataSource;
  late RedeemVoucherCode usecase;

  setUp(() {
    dataSource = MockVoucherRemoteDataSource();
    usecase = RedeemVoucherCode(dataSource: dataSource);
  });

  test('should call repository', () async {
    // arrange
    when(dataSource.redeemVoucher(any)).thenAnswer(
      (_) async => const Right(
        RedeemedVoucher(numberOfTickets: 0, productName: 'productName'),
      ),
    );

    // act
    await usecase('voucher');

    // assert
    verify(dataSource.redeemVoucher(any));
  });
}
