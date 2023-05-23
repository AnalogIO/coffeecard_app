import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/receipt/data/datasources/receipt_remote_data_source.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/receipt/domain/repositories/receipt_repository.dart';
import 'package:fpdart/fpdart.dart';

class ReceiptRepositoryImpl implements ReceiptRepository {
  final ReceiptRemoteDataSource remoteDataSource;

  ReceiptRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Receipt>>> getUserReceipts() async {
    final userReceiptsEither =
        await remoteDataSource.getUsersUsedTicketsReceipts();

    return userReceiptsEither.fold(
      (error) => Left(error),
      (userReceipts) async {
        final userPurchasesEither =
            await remoteDataSource.getUserPurchasesReceipts();

        return userPurchasesEither.fold(
          (error) => Left(error),
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
