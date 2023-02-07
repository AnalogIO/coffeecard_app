import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/opening_hours/domain/repositories/opening_hours_repository.dart';
import 'package:coffeecard/features/opening_hours/domain/usecases/fetch_opening_hours.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fetch_opening_hours_test.mocks.dart';

@GenerateMocks([OpeningHoursRepository])
void main() {
  late MockOpeningHoursRepository repository;
  late FetchOpeningHours fetchOpeningHours;

  setUp(() {
    repository = MockOpeningHoursRepository();
    fetchOpeningHours = FetchOpeningHours(repository: repository);
  });

  test('should call repository', () async {
    // arrange
    when(repository.getOpeningHours()).thenAnswer((_) async => const Right({}));

    // act
    await fetchOpeningHours(NoParams());

    // assert
    verify(repository.getOpeningHours());
    verifyNoMoreInteractions(repository);
  });
}
