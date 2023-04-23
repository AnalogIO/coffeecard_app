import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/receipt/data/datasources/receipt_remote_data_source.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/domain/repositories/receipt_repository.dart';
import 'package:dartz/dartz.dart';

class ReceiptRepositoryImpl implements ReceiptRepository {
  final ReceiptRemoteDataSource remoteDataSource;

  ReceiptRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Receipt>>> getUserReceipts() async {
    final userReceiptsEither = await remoteDataSource.getUserReceipts();

    return userReceiptsEither.fold(
      (l) => Left(l),
      (userReceipts) async {
        final userPurchasesEither = await remoteDataSource.getUserPurchases();

        return userPurchasesEither.fold(
          (l) => Left(l),
          (userPurchases) async {
            final allTickets = [...userReceipts, ...userPurchases];
            allTickets.sort((a, b) => b.timeUsed.compareTo(a.timeUsed));
            return Right(allTickets);
          },
        );
      },
    );
  }
}
