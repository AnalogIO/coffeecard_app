import 'package:coffeecard/core/errors/failures.dart';
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
    return TaskEither(() async {
      final cache = await Hive.openBox<int>('lastUsedMenuItemByProductId');
      await cache.put(productId, menuItemId);
      return const Right(unit);
    });
  }
}
