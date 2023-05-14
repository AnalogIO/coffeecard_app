import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/occupation/data/datasources/occupation_remote_data_source.dart';
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
  });

  test('should call repository', () async {
    // arrange
    when(dataSource.getOccupations()).thenAnswer((_) async => const Right([]));

    // act
    await usecase(NoParams());

    // assert
    verify(dataSource.getOccupations());
    verifyNoMoreInteractions(dataSource);
  });
}
