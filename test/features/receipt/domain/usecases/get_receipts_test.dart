import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/domain/repositories/receipt_repository.dart';
import 'package:coffeecard/features/receipt/domain/usecases/get_receipts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_receipts_test.mocks.dart';

@GenerateMocks([ReceiptRepository])
void main() {
  late MockReceiptRepository repository;
  late GetReceipts getReceipts;

  setUp(() {
    repository = MockReceiptRepository();
    getReceipts = GetReceipts(repository: repository);

    provideDummy<Either<Failure, List<Receipt>>>(
      const Left(ConnectionFailure()),
    );
  });

  test('should call data source', () async {
    // arrange
    when(repository.getUserReceipts()).thenAnswer((_) async => const Right([]));

    // act
    await getReceipts();

    // assert
    verify(repository.getUserReceipts());
  });
}
