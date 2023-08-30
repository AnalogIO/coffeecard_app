import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/opening_hours/data/datasources/opening_hours_remote_data_source.dart';
import 'package:coffeecard/features/opening_hours/domain/usecases/check_open_status.dart';
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
    // TODO(marfavi): change thenAnswer to thenReturn

    // act
    await getIsOpen(NoParams());

    // assert
    verify(dataSource.isOpen());
  });
}
