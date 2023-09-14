import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/occupation/data/datasources/occupation_remote_data_source.dart';
import 'package:coffeecard/features/occupation/data/models/occupation_model.dart';
import 'package:coffeecard/features/occupation/domain/usecases/get_occupations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_occupations_test.mocks.dart';

@GenerateMocks([OccupationRemoteDataSource])
void main() {
  late MockOccupationRemoteDataSource dataSource;
  late GetOccupations usecase;

  setUp(() {
    dataSource = MockOccupationRemoteDataSource();
    usecase = GetOccupations(dataSource: dataSource);

    provideDummy<Either<NetworkFailure, List<OccupationModel>>>(
      const Left(ConnectionFailure()),
    );
  });

  test('should call repository', () async {
    // arrange
    when(dataSource.getOccupations()).thenAnswer((_) async => const Right([]));

    // act
    await usecase();

    // assert
    verify(dataSource.getOccupations());
    verifyNoMoreInteractions(dataSource);
  });
}
