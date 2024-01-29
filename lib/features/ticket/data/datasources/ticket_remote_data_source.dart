import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/receipt/data/models/swipe_receipt_model.dart';
import 'package:coffeecard/features/receipt/domain/entities/receipt.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:fpdart/fpdart.dart';

class TicketRemoteDataSource {
  TicketRemoteDataSource({required this.api, required this.executor});

  final CoffeecardApiV2 api;
  final NetworkRequestExecutor executor;

  TaskEither<Failure, Iterable<TicketResponse>> getUserTickets() {
    return executor
        .executeAsTask(() => api.apiV2TicketsGet(includeUsed: false));
  }

  TaskEither<Failure, Receipt> useTicket(int productId, int menuItemId) {
    final body = UseTicketRequest(productId: productId, menuItemId: menuItemId);
    return executor
        .executeAsTask(() => api.apiV2TicketsUsePost(body: body))
        .map(SwipeReceiptModel.fromUsedTicketResponse);
  }
}
