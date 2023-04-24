import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:dartz/dartz.dart';

abstract class ReceiptRepository {
  Future<Either<Failure, List<Receipt>>> getUserReceipts();
}
