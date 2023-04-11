import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/ticket/data/datasources/ticket_remote_data_source.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class ConsumeTicket implements UseCase<Receipt, Params> {
  final TicketRemoteDataSource ticketRemoteDataSource;

  ConsumeTicket({required this.ticketRemoteDataSource});

  @override
  Future<Either<Failure, Receipt>> call(Params params) async {
    return ticketRemoteDataSource.useTicket(params.productId);
  }
}

class Params extends Equatable {
  final int productId;

  const Params({required this.productId});

  @override
  List<Object?> get props => [productId];
}
