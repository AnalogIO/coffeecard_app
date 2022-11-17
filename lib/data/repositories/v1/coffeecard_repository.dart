import 'package:coffeecard/data/repositories/utils/executor.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/utils/either.dart';

class CoffeeCardRepository {
  CoffeeCardRepository({
    required this.apiV1,
    required this.executor,
  });

  final CoffeecardApi apiV1;
  final Executor executor;

  Future<Either<RequestError, CoffeeCardDto>> getCoffeeCards() async {
    return executor.execute(
      apiV1.apiV1CoffeeCardsGet,
      // FIXME no generated code as return type!
      transformer: (dto) => dto,
    );
  }
}
