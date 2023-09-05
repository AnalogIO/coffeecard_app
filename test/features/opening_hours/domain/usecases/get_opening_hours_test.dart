import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/timeslot.dart';
import 'package:coffeecard/features/opening_hours/domain/repositories/opening_hours_repository.dart';
import 'package:coffeecard/features/opening_hours/domain/usecases/get_opening_hours.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_opening_hours_test.mocks.dart';

@GenerateMocks([OpeningHoursRepository])
void main() {
  late OpeningHoursRepository repository;
  late GetOpeningHours fetchOpeningHours;

  setUp(() {
    repository = MockOpeningHoursRepository();
    fetchOpeningHours = GetOpeningHours(repository: repository);

    provideDummy<Either<Failure, Map<int, Timeslot>>>(
      const Left(ConnectionFailure()),
    );
  });

  test('should call data source', () async {
    // arrange
    when(repository.getOpeningHours()).thenReturn({});

    // act
    await fetchOpeningHours(NoParams());

    // assert
    verify(repository.getOpeningHours()).called(1);
    verifyNoMoreInteractions(repository);
  });
}
