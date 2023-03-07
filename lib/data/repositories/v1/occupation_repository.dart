import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/executor.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/models/occupation.dart';
import 'package:dartz/dartz.dart';

class OccupationRepository {
  OccupationRepository({
    required this.apiV1,
    required this.executor,
  });

  final CoffeecardApi apiV1;
  final Executor executor;

  Future<Either<Failure, List<Occupation>>> getOccupations() async {
    final result = await executor(
      apiV1.apiV1ProgrammesGet,
    );

    return result
        .bind((result) => Right(result.map(Occupation.fromDTO).toList()));
  }
}
