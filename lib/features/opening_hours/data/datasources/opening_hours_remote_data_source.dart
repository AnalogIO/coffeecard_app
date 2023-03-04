import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/generated/api/shiftplanning_api.swagger.dart';
import 'package:dartz/dartz.dart';

class OpeningHoursRemoteDataSource {
  final ShiftplanningApi api;
  final shortkey = 'analog';

  OpeningHoursRemoteDataSource({required this.api});

  /// Check if the cafe is open.
  Future<Either<ServerFailure, bool>> isOpen() async {
    final response = await api.apiOpenShortKeyGet(shortKey: shortkey);

    return response.isSuccessful
        ? Right(response.body!.open)
        : Left(ServerFailure.fromResponse(response));
  }

  /// Get the opening hours of the cafe.
  Future<Either<ServerFailure, List<OpeningHoursDTO>>> getOpeningHours() async {
    final response = await api.apiShiftsShortKeyGet(shortKey: shortkey);

    return response.isSuccessful
        ? Right(response.body!)
        : Left(ServerFailure.fromResponse(response));
  }
}
