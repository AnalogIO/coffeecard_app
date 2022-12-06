import 'package:coffeecard/data/repositories/utils/executor.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/models/occupation.dart';
import 'package:coffeecard/utils/either.dart';

class OccupationRepository {
  OccupationRepository({
    required this.apiV1,
    required this.executor,
  });

  final CoffeecardApi apiV1;
  final Executor executor;

  Future<Either<RequestFailure, List<Occupation>>> getOccupations() async {
    return executor.execute(
      apiV1.apiV1ProgrammesGet,
      (dto) => dto.map(Occupation.fromDTO).toList(),
    );
  }
}
