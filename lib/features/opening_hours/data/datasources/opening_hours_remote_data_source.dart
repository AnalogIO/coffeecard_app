import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/generated/api/shiftplanning_api.swagger.dart';
import 'package:fpdart/fpdart.dart';

class OpeningHoursRemoteDataSource {
  final ShiftplanningApi api;
  final NetworkRequestExecutor executor;

  OpeningHoursRemoteDataSource({
    required this.api,
    required this.executor,
  });

  // Hard-coded value required by API
  final shortkey = 'analog';

  /// Check if the cafe is open.
  Future<Either<Failure, bool>> isOpen() async {
    final result = await executor(
      () async => api.apiOpenShortKeyGet(shortKey: shortkey),
    );

    return result.map((result) => result.open);
  }

  /// Get the opening hours of the cafe.
  Future<Either<Failure, List<OpeningHoursDTO>>> getOpeningHours() async {
    return executor(
      () => api.apiShiftsShortKeyGet(shortKey: shortkey),
    );
  }
}
