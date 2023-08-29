import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/opening_hours/opening_hours.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'check_open_status_test.mocks.dart';

@GenerateMocks([OpeningHoursRemoteDataSource])
void main() {
  late MockOpeningHoursRemoteDataSource dataSource;
  late CheckOpenStatus getIsOpen;

  setUp(() {
    dataSource = MockOpeningHoursRemoteDataSource();
    getIsOpen = CheckOpenStatus(dataSource: dataSource);

    provideDummy<Either<Failure, bool>>(
      const Left(ConnectionFailure()),
    );
  });

  test('should call data source', () async {
    // arrange
    when(dataSource.isOpen()).thenAnswer((_) async => const Right(true));

    // act
    await getIsOpen(NoParams());

    // assert
    verify(dataSource.isOpen());
  });
}
