import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/opening_hours/data/models/opening_hours_model.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/opening_hours.dart';
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
  Future<Either<Failure, bool>> isOpen() {
    return executor
        .execute(() => api.apiOpenShortKeyGet(shortKey: shortkey))
        .map((result) => result.open);
  }

  /// Get the opening hours of the cafe, including today's opening hours and
  /// the opening hours for the next 7 days.
  Future<Either<Failure, OpeningHours>> getOpeningHours() {
    return executor
        .execute(() => api.apiShiftsShortKeyGet(shortKey: shortkey))
        .map(OpeningHoursModel.fromDTO);
  }
}
