import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/opening_hours/data/datasources/opening_hours_remote_data_source.dart';
import 'package:coffeecard/generated/api/shiftplanning_api.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'opening_hours_remote_data_source_test.mocks.dart';

@GenerateMocks([ShiftplanningApi, NetworkRequestExecutor])
void main() {
  late MockShiftplanningApi api;
  late MockNetworkRequestExecutor executor;
  late OpeningHoursRemoteDataSource dataSource;

  setUp(() {
    api = MockShiftplanningApi();
    executor = MockNetworkRequestExecutor();
    dataSource = OpeningHoursRemoteDataSource(api: api, executor: executor);

    provideDummy<Either<NetworkFailure, IsOpenDTO>>(
      const Left(ConnectionFailure()),
    );
    provideDummy<Either<NetworkFailure, List<OpeningHoursDTO>>>(
      const Left(ConnectionFailure()),
    );
  });

  group('isOpen', () {
    test('should call executor', () async {
      // arrange
      when(executor.execute<IsOpenDTO>(any)).thenAnswer(
        (_) async => Right(IsOpenDTO(open: true)),
      );

      // act
      await dataSource.isOpen();

      // assert
      verify(executor.execute<IsOpenDTO>(any));
    });
  });

  group('getOpeningHours', () {
    test('should call executor', () async {
      // arrange
      final List<OpeningHoursDTO> testOpeningHours = [];

      when(executor.execute<List<OpeningHoursDTO>>(any)).thenAnswer(
        (_) async => Right(testOpeningHours),
      );

      // act
      await dataSource.getOpeningHours();

      // assert
      verify(executor.execute<List<OpeningHoursDTO>>(any));
    });
  });
}
