import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/product/product_repository.dart';
import 'package:coffeecard/features/ticket/data/datasources/ticket_remote_data_source.dart';
import 'package:coffeecard/features/ticket/domain/entities/ticket.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.models.swagger.dart';
import 'package:collection/collection.dart';
import 'package:fpdart/fpdart.dart';

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

    return productRepository.getProduct(productId).map(
          (product) => Ticket(
            amountLeft: tickets.length,
            product: product,
          ),
        );
  }
}
