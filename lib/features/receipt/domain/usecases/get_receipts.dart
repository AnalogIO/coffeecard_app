import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/domain/repositories/receipt_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetReceipts {
  final ReceiptRepository repository;

  GetReceipts({required this.repository});

  Future<Either<Failure, List<Receipt>>> call() async {
    return repository.getUserReceipts();
  }
}
