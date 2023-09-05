import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/opening_hours/data/datasources/opening_hours_remote_data_source.dart';
import 'package:coffeecard/features/opening_hours/domain/entities/opening_hours.dart';
import 'package:coffeecard/features/opening_hours/domain/usecases/get_opening_hours.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_opening_hours_test.mocks.dart';

@GenerateMocks([OpeningHoursRemoteDataSource])
void main() {
  late MockOpeningHoursRemoteDataSource dataSource;
  late GetOpeningHours fetchOpeningHours;

  setUp(() {
    dataSource = MockOpeningHoursRemoteDataSource();
    fetchOpeningHours = GetOpeningHours(dataSource: dataSource);

    provideDummy<Either<Failure, OpeningHours>>(
      const Left(ConnectionFailure()),
    );
  });

  test('should call data source', () async {
    const theOpeningHours = OpeningHours(
      allOpeningHours: {},
      todaysOpeningHours: '',
    );

    // arrange
    when(dataSource.getOpeningHours())
        .thenAnswer((_) async => const Right(theOpeningHours));

    // act
    await fetchOpeningHours(NoParams());

    // assert
    verify(dataSource.getOpeningHours()).called(1);
    verifyNoMoreInteractions(dataSource);
  });
}
