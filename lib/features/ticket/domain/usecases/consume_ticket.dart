import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/store/store.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/ticket/data/datasources/ticket_remote_data_source.dart';
import 'package:fpdart/fpdart.dart';

class ConsumeTicket {
  final TicketRemoteDataSource ticketRemoteDataSource;
  final Crate<int> crate;

  ConsumeTicket({
    required this.ticketRemoteDataSource,
    required this.crate,
  });

  TaskEither<Failure, Receipt> call({
    required int productId,
    required int menuItemId,
  }) {
    return ticketRemoteDataSource
        .useTicket(productId, menuItemId)
        // Side effect: Cache the last used menu item id for the given product
        .chainFirst((_) => crate.put(productId, menuItemId).toTaskEither());
  }
}
