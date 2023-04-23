import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/receipt/data/datasources/receipt_remote_data_source.dart';
import 'package:coffeecard/features/receipt/data/repositories/receipt_repository_impl.dart';
import 'package:coffeecard/features/receipt/domain/entities/purchase_receipt.dart';
import 'package:coffeecard/features/receipt/domain/entities/swipe_receipt.dart';
import 'package:coffeecard/features/receipt/domain/repositories/receipt_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
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
      when(remoteDataSource.getUserReceipts())
          .thenAnswer((_) async => const Left(ServerFailure('some error')));

      // act
      final actual = await repository.getUserReceipts();

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });

    test('should return [Left] if get user purchases fails', () async {
      // arrange
      when(remoteDataSource.getUserReceipts())
          .thenAnswer((_) async => const Right([]));
      when(remoteDataSource.getUserReceipts())
          .thenAnswer((_) async => const Left(ServerFailure('some error')));

      // act
      final actual = await repository.getUserReceipts();

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });

    test('should return [Right<List<Receipt>>] if api calls succeed', () async {
      // arrange
      final tSwipedReceipt = SwipeReceipt(
        productName: 'productName',
        timeUsed: DateTime.parse('2023-04-23'),
        id: 0,
      );

      final tPurchasedReceipt = PurchaseReceipt(
        productName: 'productName',
        timeUsed: DateTime.parse('2023-04-24'), // note this is a day later
        id: 0,
        price: 0,
        amountPurchased: 0,
      );

      when(remoteDataSource.getUserReceipts()).thenAnswer(
        (_) async => Right([
          tSwipedReceipt,
        ]),
      );
      when(remoteDataSource.getUserPurchases()).thenAnswer(
        (_) async => Right([
          tPurchasedReceipt,
        ]),
      );

      // act
      final actual = await repository.getUserReceipts();

      // assert
      actual.map(
        (response) => expect(
          response,
          [
            tPurchasedReceipt,
            tSwipedReceipt
          ], // note that it is sorted from oldest --> newest
        ),
      );
    });
  });
}
