import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/occupation/data/models/occupation_model.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:dartz/dartz.dart';

class OccupationRemoteDataSource {
  final CoffeecardApi api;
  final NetworkRequestExecutor executor;

  OccupationRemoteDataSource({
    required this.api,
    required this.executor,
  });

  Future<Either<NetworkFailure, List<OccupationModel>>> getOccupations() async {
    final result = await executor(
      () => api.apiV1ProgrammesGet(),
    );
    return result
        .map((result) => result.map(OccupationModel.fromDTOV1).toList());
  }
}
