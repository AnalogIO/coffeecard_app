import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/occupation/domain/repositories/occupation_repository.dart';
import 'package:coffeecard/features/occupation/domain/usecases/get_occupations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_occupations_test.mocks.dart';

@GenerateMocks([OccupationRepository])
void main() {
  late MockOccupationRepository repository;
  late GetOccupations usecase;

  setUp(() {
    repository = MockOccupationRepository();
    usecase = GetOccupations(repository: repository);
  });

  test('should call repository', () async {
    // arrange
    when(repository.getOccupations()).thenAnswer((_) async => const Right([]));

    // act
    await usecase(NoParams());

    // assert
    verify(repository.getOccupations());
    verifyNoMoreInteractions(repository);
  });
}
