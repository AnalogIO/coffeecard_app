import 'package:coffeecard/core/errors/exceptions.dart';
import 'package:coffeecard/generated/api/shiftplanning_api.swagger.dart';

abstract class OpeningHoursRemoteDataSource {
  /// Check if the cafe is open.
  ///
  /// Throws a [ServerException] if the api call failed.
  Future<bool> isOpen();

  /// Get the opening hours of the cafe.
  ///
  /// Throws a [ServerException] if the api call failed.
  Future<List<OpeningHoursDTO>> getOpeningHours();
}

class OpeningHoursRemoteDataSourceImpl implements OpeningHoursRemoteDataSource {
  final ShiftplanningApi api;

  OpeningHoursRemoteDataSourceImpl({required this.api});

  final shortkey = 'analog';

  @override
  Future<bool> isOpen() async {
    final response = await api.apiOpenShortKeyGet(shortKey: shortkey);

    if (!response.isSuccessful) {
      throw ServerException.fromResponse(response);
    }

    return response.body!.open;
  }

  @override
  Future<List<OpeningHoursDTO>> getOpeningHours() async {
    final response = await api.apiShiftsShortKeyGet(shortKey: shortkey);

    if (!response.isSuccessful) {
      throw ServerException.fromResponse(response);
    }

    return response.body!;
  }
}
