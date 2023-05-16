import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:fpdart/fpdart.dart';

abstract class ReceiptRepository {
  Future<Either<Failure, List<Receipt>>> getUserReceipts();
}
