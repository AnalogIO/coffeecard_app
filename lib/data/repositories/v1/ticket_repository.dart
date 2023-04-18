import 'package:coffeecard/data/repositories/barista_product/barista_product_repository.dart';
import 'package:coffeecard/data/repositories/utils/executor.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
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
  final Executor executor;

  Future<Either<RequestFailure, List<TicketCount>>> getUserTickets() async {
    final baristaProductIds = baristaProductsRepository.getBaristaProductIds();
    return executor.execute(
      () => apiV2.apiV2TicketsGet(includeUsed: false),
      (dtoList) {
        return dtoList
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
            .toList();
      },
    );
  }

  Future<Either<RequestFailure, Receipt>> useTicket(int productId) async {
    return executor.execute(
      () => apiV1.apiV1TicketsUsePost(body: UseTicketDTO(productId: productId)),
      (dto) {
        return Receipt(
          productName: dto.productName,
          id: dto.id,
          transactionType: TransactionType.ticketSwipe,
          timeUsed: dto.dateUsed,
          // TODO(fremartini): Find a better alternative to these default values They are unused on the receipt overlay, https://github.com/AnalogIO/coffeecard_app/issues/384
          amountPurchased: -1,
          price: -1,
        );
      },
    );
  }
}
