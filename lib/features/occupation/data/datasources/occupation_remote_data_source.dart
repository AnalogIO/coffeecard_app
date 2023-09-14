import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/occupation/data/models/occupation_model.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:fpdart/fpdart.dart';

class OccupationRemoteDataSource {
  final CoffeecardApi api;
  final NetworkRequestExecutor executor;

  OccupationRemoteDataSource({
    required this.api,
    required this.executor,
  });

  Future<Either<NetworkFailure, List<OccupationModel>>> getOccupations() {
    return executor
        .execute(api.apiV1ProgrammesGet)
        .mapAll(OccupationModel.fromDTOV1);
  }
}
