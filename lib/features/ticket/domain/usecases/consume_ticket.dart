import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/ticket/data/datasources/ticket_remote_data_source.dart';
import 'package:fpdart/fpdart.dart';

class ConsumeTicket {
  final TicketRemoteDataSource ticketRemoteDataSource;

  ConsumeTicket({required this.ticketRemoteDataSource});

  Future<Either<Failure, Receipt>> call({required int productId}) async {
    return ticketRemoteDataSource.useTicket(productId);
  }
}
