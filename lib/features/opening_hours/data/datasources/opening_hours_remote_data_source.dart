import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/executor.dart';
import 'package:coffeecard/generated/api/shiftplanning_api.swagger.dart';
import 'package:dartz/dartz.dart';

abstract class OpeningHoursRemoteDataSource {
  /// Check if the cafe is open.
  Future<Either<Failure, bool>> isOpen();

  /// Get the opening hours of the cafe.
  Future<Either<Failure, List<OpeningHoursDTO>>> getOpeningHours();
}

class OpeningHoursRemoteDataSourceImpl implements OpeningHoursRemoteDataSource {
  final ShiftplanningApi api;
  final Executor executor;

  OpeningHoursRemoteDataSourceImpl({
    required this.api,
    required this.executor,
  });

  final shortkey = 'analog';

  @override
  Future<Either<Failure, bool>> isOpen() async {
    final result = await executor(
      () async => api.apiOpenShortKeyGet(shortKey: shortkey),
    );

    return result.bind((result) => Right(result.open));
  }

  @override
  Future<Either<Failure, List<OpeningHoursDTO>>> getOpeningHours() async {
    final result = await executor(
      () => api.apiShiftsShortKeyGet(shortKey: shortkey),
    );

    return result.bind((result) => Right(result));
  }
}
