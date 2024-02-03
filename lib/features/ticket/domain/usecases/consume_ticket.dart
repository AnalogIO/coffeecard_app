import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/store_utils.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/ticket/data/datasources/ticket_remote_data_source.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ConsumeTicket {
  final TicketRemoteDataSource ticketRemoteDataSource;

  ConsumeTicket({required this.ticketRemoteDataSource});

  TaskEither<Failure, Receipt> call({
    required int productId,
    required int menuItemId,
  }) {
    return ticketRemoteDataSource
        .useTicket(productId, menuItemId)
        .chainFirst((_) => _cacheLastUsedMenuItem(productId, menuItemId));
  }

  TaskEither<Failure, Unit> _cacheLastUsedMenuItem(
    int productId,
    int menuItemId,
  ) {
    return Hive.openBoxAsTask<int>('lastUsedMenuItemByProductId')
        .flatMap((box) => box.putAsTask(productId, menuItemId))
        .toTaskEither<Failure>();
  }
}
