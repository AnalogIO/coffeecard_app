import 'package:coffeecard/core/errors/exceptions.dart';
import 'package:coffeecard/features/occupation/data/datasources/occupation_remote_data_source.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../response.dart';
import 'occupation_remote_data_source_test.mocks.dart';

@GenerateMocks([CoffeecardApi])
void main() {
  late MockCoffeecardApi api;
  late OccupationRemoteDataSource dataSource;

  setUp(() {
    api = MockCoffeecardApi();
    dataSource = OccupationRemoteDataSourceImpl(api: api);
  });

  group('getOccupations', () {
    test('should throw [ServerException] if api call fails', () async {
      // arrange
      when(api.apiV1ProgrammesGet()).thenAnswer(
        (_) async => Response.fromStatusCode(500),
      );

      // act
      final call = dataSource.getOccupations;

      // assert
      expect(
        () async => call(),
        throwsA(const TypeMatcher<ServerException>()),
      );
    });

    test('should return occupation list if api call succeeds', () async {
      // arrange
      when(api.apiV1ProgrammesGet()).thenAnswer(
        (_) async => Response.fromStatusCode(
          200,
          body: [],
        ),
      );

      // act
      final actual = await dataSource.getOccupations();

      // assert
      expect(actual, []);
    });
  });
}
