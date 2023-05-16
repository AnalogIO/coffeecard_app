import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/occupation/data/datasources/occupation_remote_data_source.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'occupation_remote_data_source_test.mocks.dart';

@GenerateMocks([CoffeecardApi, NetworkRequestExecutor])
void main() {
  late MockCoffeecardApi api;
  late MockNetworkRequestExecutor executor;
  late OccupationRemoteDataSource dataSource;

  setUp(() {
    api = MockCoffeecardApi();
    executor = MockNetworkRequestExecutor();
    dataSource = OccupationRemoteDataSource(api: api, executor: executor);
  });

  group('getOccupations', () {
    test('should return [Left] if executor returns [Left]', () async {
      // arrange
      when(executor.call<List<ProgrammeDto>>(any)).thenAnswer(
        (_) async => const Left(ServerFailure('some error')),
      );

      // act
      final actual = await dataSource.getOccupations();

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });

    test(
      'should return [Right<List<OccupationModel>>] executor succeeds',
      () async {
        // arrange
        when(executor.call<List<ProgrammeDto>>(any)).thenAnswer(
          (_) async => const Right([]),
        );

        // act
        final actual = await dataSource.getOccupations();

        // assert
        expect(actual.isRight(), true);
        actual.map(
          (response) => expect(response, []),
        );
      },
    );
  });
}
