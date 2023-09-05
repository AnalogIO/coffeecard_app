import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/opening_hours/domain/repositories/opening_hours_repository.dart';
import 'package:coffeecard/features/opening_hours/domain/usecases/check_open_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'check_open_status_test.mocks.dart';

@GenerateMocks([OpeningHoursRepository])
void main() {
  late OpeningHoursRepository repository;
  late CheckOpenStatus getIsOpen;

  setUp(() {
    repository = MockOpeningHoursRepository();
    getIsOpen = CheckOpenStatus(repository: repository);

    provideDummy<Either<Failure, bool>>(
      const Left(ConnectionFailure()),
    );
  });

  test('should call data source', () async {
    // arrange
    when(repository.isOpen(DateTime.now())).thenReturn(true);

    // act
    await getIsOpen(NoParams());

    // assert
    verify(repository.isOpen(DateTime.now()));
  });
}
