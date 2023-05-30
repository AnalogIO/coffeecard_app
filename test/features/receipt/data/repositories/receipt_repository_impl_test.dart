import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/purchase/domain/entities/payment_status.dart';
import 'package:coffeecard/features/receipt/data/datasources/receipt_remote_data_source.dart';
import 'package:coffeecard/features/receipt/data/repositories/receipt_repository_impl.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/domain/repositories/receipt_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'receipt_repository_impl_test.mocks.dart';

@GenerateMocks([ReceiptRemoteDataSource])
void main() {
  late ReceiptRepository repository;
  late MockReceiptRemoteDataSource remoteDataSource;

  setUp(() {
    remoteDataSource = MockReceiptRemoteDataSource();
    repository = ReceiptRepositoryImpl(remoteDataSource: remoteDataSource);
  });

  group('getUserReceipts', () {
    test('should return [Left] if get user receipts fails', () async {
      // arrange
      when(remoteDataSource.getUsersUsedTicketsReceipts())
          .thenAnswer((_) async => const Left(ServerFailure('some error')));

      // act
      final actual = await repository.getUserReceipts();

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });

    test('should return [Left] if get user purchases fails', () async {
      // arrange
      when(remoteDataSource.getUsersUsedTicketsReceipts())
          .thenAnswer((_) async => const Right([]));
      when(remoteDataSource.getUserPurchasesReceipts())
          .thenAnswer((_) async => const Left(ServerFailure('some error')));

      // act
      final actual = await repository.getUserReceipts();

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });

    test(
      'should return [Right<List<Receipt>>] if api calls succeed',
      () async {
        // arrange
        final testSwipedReceipt = SwipeReceipt(
          productName: 'productName',
          timeUsed: DateTime.parse('2023-04-23'),
          id: 0,
        );

        final testPurchasedReceipt = PurchaseReceipt(
          productName: 'productName',
          timeUsed: DateTime.parse('2023-04-24'), // note this is a day later
          id: 0,
          price: 0,
          amountPurchased: 0,
          paymentStatus: PaymentStatus.completed,
        );

        when(remoteDataSource.getUsersUsedTicketsReceipts()).thenAnswer(
          (_) async => Right([
            testSwipedReceipt,
          ]),
        );
        when(remoteDataSource.getUserPurchasesReceipts()).thenAnswer(
          (_) async => Right([
            testPurchasedReceipt,
          ]),
        );

        // act
        final actual = await repository.getUserReceipts();

        // assert
        actual.map(
          (response) => expect(
            response,
            [
              testPurchasedReceipt,
              testSwipedReceipt,
            ], // note that it is sorted from oldest --> newest
          ),
        );
      },
    );
  });
}
