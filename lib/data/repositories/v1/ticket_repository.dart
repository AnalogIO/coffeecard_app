import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/data/repositories/barista_product/barista_product_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/receipts/receipt.dart';
import 'package:coffeecard/models/ticket/ticket_count.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';

class TicketRepository {
  TicketRepository({
    required this.apiV1,
    required this.apiV2,
    required this.executor,
    required this.baristaProductsRepository,
  });

  final CoffeecardApi apiV1;
  final CoffeecardApiV2 apiV2;
  final BaristaProductsRepository baristaProductsRepository;
  final NetworkRequestExecutor executor;

  Future<Either<NetworkFailure, List<TicketCount>>> getUserTickets() async {
    final result = await executor(
      () => apiV2.apiV2TicketsGet(includeUsed: false),
    );

    final baristaProductIds = baristaProductsRepository.getBaristaProductIds();

    return result.map(
      (result) => result
          .groupListsBy((t) => t.productName)
          .entries
          .map(
            (t) => TicketCount(
              count: t.value.length,
              productName: t.key,
              productId: t.value.first.productId,
              isBaristaTicket:
                  baristaProductIds.contains(t.value.first.productId),
            ),
          )
          .sortedBy<num>((t) => t.productId)
          .toList(),
    );
  }

  Future<Either<NetworkFailure, Receipt>> useTicket(int productId) async {
    final result = await executor(
      () => apiV1.apiV1TicketsUsePost(
        body: UseTicketDTO(productId: productId),
      ),
    );

    return result.map(Receipt.fromTicketDto);
  }
}
