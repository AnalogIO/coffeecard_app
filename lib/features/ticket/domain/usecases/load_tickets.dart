import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/ticket/data/datasources/ticket_remote_data_source.dart';
import 'package:coffeecard/features/ticket/domain/entities/ticket_count.dart';
import 'package:fpdart/fpdart.dart';

class LoadTickets {
  final TicketRemoteDataSource ticketRemoteDataSource;

  LoadTickets({required this.ticketRemoteDataSource});

  Future<Either<Failure, List<TicketCount>>> call() async {
    return ticketRemoteDataSource.getUserTickets();
  }
}
