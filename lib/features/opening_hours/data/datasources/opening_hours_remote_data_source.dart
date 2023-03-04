import 'package:coffeecard/core/network/executor.dart';
import 'package:coffeecard/generated/api/shiftplanning_api.swagger.dart';

abstract class OpeningHoursRemoteDataSource {
  /// Check if the cafe is open.
  Future<bool> isOpen();

  /// Get the opening hours of the cafe.
  Future<List<OpeningHoursDTO>> getOpeningHours();
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
  Future<bool> isOpen() async {
    final result = await executor(
      () async => api.apiOpenShortKeyGet(shortKey: shortkey),
    );

    return result!.open;
  }

  @override
  Future<List<OpeningHoursDTO>> getOpeningHours() async {
    final result = await executor(
      () => api.apiShiftsShortKeyGet(shortKey: shortkey),
    );

    return result!;
  }
}
