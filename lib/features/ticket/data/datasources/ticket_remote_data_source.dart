import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/receipt/data/models/swipe_receipt_model.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/features/ticket/data/models/ticket_count_model.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:collection/collection.dart';
import 'package:fpdart/fpdart.dart';

class TicketRemoteDataSource {
  TicketRemoteDataSource({
    required this.apiV1,
    required this.apiV2,
    required this.executor,
  });

  final CoffeecardApi apiV1;
  final CoffeecardApiV2 apiV2;
  final NetworkRequestExecutor executor;

  Future<Either<NetworkFailure, List<TicketCountModel>>> getUserTickets() {
    // Mapper function for mapping a list of tickets (all with the same product
    // id) to a TicketCountModel.
    //
    // This also takes into account that there might be
    // some tickets with the same product id, but different names.
    TicketCountModel mapper(MapEntry<int, List<TicketResponse>> entry) {
      final MapEntry(key: id, value: tickets) = entry;
      // If there are multiple ticket names present, join them with a slash.
      final ticketName = tickets.map((t) => t.productName).toSet().join('/');

      return TicketCountModel(
        count: tickets.length,
        productName: ticketName,
        productId: id,
      );
    }

    return executor
        .execute(() => apiV2.apiV2TicketsGet(includeUsed: false))
        .map(
          (result) => result
              .groupListsBy((t) => t.productId)
              .entries
              .map(mapper)
              .sortedBy<num>((t) => t.productId),
        );
  }

  Future<Either<NetworkFailure, Receipt>> useTicket(int productId) {
    final body = UseTicketDTO(productId: productId);
    return executor
        .execute(() => apiV1.apiV1TicketsUsePost(body: body))
        .map(SwipeReceiptModel.fromTicketDto);
  }
}
