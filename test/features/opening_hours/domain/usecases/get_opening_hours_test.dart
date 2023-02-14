import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/opening_hours.dart';
import 'package:coffeecard/features/opening_hours/opening_hours.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_opening_hours_test.mocks.dart';

@GenerateMocks([OpeningHoursRepository])
void main() {
  late MockOpeningHoursRepository repository;
  late GetOpeningHours fetchOpeningHours;

  setUp(() {
    repository = MockOpeningHoursRepository();
    fetchOpeningHours = GetOpeningHours(repository: repository);
  });

  test('should call repository', () async {
    const theOpeningHours = OpeningHours(
      allOpeningHours: {},
      todaysOpeningHours: '',
    );

    // arrange
    when(repository.getOpeningHours(any))
        .thenAnswer((_) async => const Right(theOpeningHours));

    // act
    await fetchOpeningHours(NoParams());

    // assert
    verify(repository.getOpeningHours(any));
    verifyNoMoreInteractions(repository);
  });
}
