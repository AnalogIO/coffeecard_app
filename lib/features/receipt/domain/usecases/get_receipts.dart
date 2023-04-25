import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/domain/repositories/receipt_repository.dart';
import 'package:dartz/dartz.dart';

class GetReceipts implements UseCase<List<Receipt>, NoParams> {
  final ReceiptRepository repository;

  GetReceipts({required this.repository});

  @override
  Future<Either<Failure, List<Receipt>>> call(NoParams params) async {
    return repository.getUserReceipts();
  }
}
