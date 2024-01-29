import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/product/product.dart';
import 'package:coffeecard/features/ticket/data/datasources/ticket_remote_data_source.dart';
import 'package:coffeecard/features/ticket/domain/entities/ticket.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.models.swagger.dart';
import 'package:collection/collection.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LoadTickets {
  final TicketRemoteDataSource ticketRemoteDataSource;
  final ProductRepository productRepository;

  const LoadTickets({
    required this.ticketRemoteDataSource,
    required this.productRepository,
  });

  TaskEither<Failure, List<Ticket>> call() {
    return ticketRemoteDataSource
        .getUserTickets()
        // create groups of ticket reponse objects grouped by product id,
        // creating a list of key-value pairs (product id, list of tickets)
        .map((ts) => ts.groupListsBy((t) => t.productId).entries.toList())
        // map each key-value pair to a Ticket
        .flatMap((list) => TaskEither.traverseList(list, _mapToTicket))
        // sort the list by product id
        .map((list) => list.sortWith((t) => t.product.id, Order.orderInt));
  }

  TaskEither<Failure, Ticket> _mapToTicket(
    MapEntry<int, List<TicketResponse>> ticketGroup,
  ) {
    final productId = ticketGroup.key;
    final tickets = ticketGroup.value;

    return productRepository
        .getProduct(productId)
        .map(
          (product) => Ticket(
            product: product,
            amountLeft: tickets.length,
            lastUsedMenuItem: const None(),
          ),
        )
        .flatMap(_addLastUsedMenuItemToTicket);
  }

  /// If there is a cached last used menu item id for the given [ticket],
  /// add it to the [ticket] and return it.
  /// Otherwise, return the [ticket] as is.
  TaskEither<Failure, Ticket> _addLastUsedMenuItemToTicket(Ticket ticket) {
    // See if there is a cached menu item id for the given product id
    final getCachedMenuItemId = TaskEither<Failure, int>(() async {
      final cache = await Hive.openBox<int>('lastUsedMenuItemByProductId');
      return Either.fromNullable(
        cache.get(ticket.product.id),
        () => const LocalStorageFailure('No last used menu item found'),
      );
    });

    // Get the menu item from the product's eligible menu items
    TaskEither<Failure, MenuItem> getMenuItemFromId(lastUsedMenuItemId) {
      return TaskEither.fromNullable(
        ticket.product.eligibleMenuItems
            .firstWhereOrNull((mi) => mi.id == lastUsedMenuItemId),
        () => LocalStorageFailure(
          'Last used menu item found ($lastUsedMenuItemId), '
          'but it is not eligible for product ${ticket.product.id}.',
        ),
      );
    }

    return getCachedMenuItemId
        .flatMap(getMenuItemFromId)
        .map((menuItem) => ticket.copyWith(lastUsedMenuItem: Some(menuItem)))
        .orElse((_) => TaskEither.of(ticket));
  }
}
