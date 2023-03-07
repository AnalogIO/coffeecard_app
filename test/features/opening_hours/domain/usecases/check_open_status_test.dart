import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/opening_hours/opening_hours.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'check_open_status_test.mocks.dart';

@GenerateMocks([OpeningHoursRepository])
void main() {
  late MockOpeningHoursRepository repository;
  late CheckOpenStatus getIsOpen;

  setUp(() {
    repository = MockOpeningHoursRepository();
    getIsOpen = CheckOpenStatus(dataSource: repository);
  });

  test('should call repository', () async {
    // arrange
    when(repository.getIsOpen()).thenAnswer((_) async => const Right(true));

    // act
    await getIsOpen(NoParams());

    // assert
    verify(repository.getIsOpen());
    verifyNoMoreInteractions(repository);
  });
}
