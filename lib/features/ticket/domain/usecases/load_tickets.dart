import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/ticket/data/datasources/ticket_remote_data_source.dart';
import 'package:coffeecard/features/ticket/domain/entities/ticket_count.dart';
import 'package:dartz/dartz.dart';

class LoadTickets implements UseCase<List<TicketCount>, NoParams> {
  final TicketRemoteDataSource ticketRemoteDataSource;

  LoadTickets({required this.ticketRemoteDataSource});

  @override
  Future<Either<Failure, List<TicketCount>>> call(NoParams params) async {
    return ticketRemoteDataSource.getUserTickets();
  }
}
