import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/extensions/either_extensions.dart';
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

  Future<Either<NetworkFailure, List<TicketCountModel>>>
      getUserTickets() async {
    return executor(
      () => apiV2.apiV2TicketsGet(includeUsed: false),
    ).bindFuture(
      (result) => result
          .groupListsBy((t) => t.productName)
          .entries
          .map(
            (t) => TicketCountModel(
              count: t.value.length,
              productName: t.key,
              productId: t.value.first.productId,
            ),
          )
          .sortedBy<num>((t) => t.productId)
          .toList(),
    );
  }

  Future<Either<NetworkFailure, Receipt>> useTicket(int productId) async {
    return executor(
      () => apiV1.apiV1TicketsUsePost(
        body: UseTicketDTO(productId: productId),
      ),
    ).bindFuture(SwipeReceiptModel.fromTicketDto);
  }
}
