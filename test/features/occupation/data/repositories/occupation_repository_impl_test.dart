import 'package:coffeecard/core/errors/exceptions.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/occupation/data/datasources/occupation_remote_data_source.dart';
import 'package:coffeecard/features/occupation/data/models/occupation_model.dart';
import 'package:coffeecard/features/occupation/data/repositories/occupation_repository_impl.dart';
import 'package:coffeecard/features/occupation/domain/repositories/occupation_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'occupation_repository_impl_test.mocks.dart';

@GenerateMocks([OccupationRemoteDataSource])
void main() {
  late MockOccupationRemoteDataSource dataSource;
  late OccupationRepository repository;

  setUp(() {
    dataSource = MockOccupationRemoteDataSource();
    repository = OccupationRepositoryImpl(remoteDataSource: dataSource);
  });

  group('getOccupations', () {
    test('should return ServerFailure if data source call fails', () async {
      // arrange
      when(dataSource.getOccupations())
          .thenThrow(ServerException(error: 'some error'));

      // act
      final actual = await repository.getOccupations();

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });

    test('should return occupation list if data source call succeeds',
        () async {
      // arrange
      final List<OccupationModel> tModels = [];

      when(dataSource.getOccupations()).thenAnswer((_) async => tModels);

      // act
      final actual = await repository.getOccupations();

      // assert
      expect(actual, Right(tModels));
    });
  });
}
