import 'package:coffeecard/core/errors/exceptions.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/opening_hours/data/datasources/opening_hours_remote_data_source.dart';
import 'package:coffeecard/features/opening_hours/data/repositories/opening_hours_repository_impl.dart';
import 'package:coffeecard/features/opening_hours/domain/repositories/opening_hours_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'opening_hours_repository_impl_test.mocks.dart';

@GenerateMocks([OpeningHoursRemoteDataSource])
void main() {
  late MockOpeningHoursRemoteDataSource dataSource;
  late OpeningHoursRepository repository;

  setUp(() {
    dataSource = MockOpeningHoursRemoteDataSource();
    repository = OpeningHoursRepositoryImpl(dataSource: dataSource);
  });

  group('getIsOpen', () {
    test('should return ServerFailure if data source call fails', () async {
      // arrange
      when(dataSource.isOpen()).thenThrow(ServerException(error: 'some error'));

      // act
      final actual = await repository.getIsOpen();

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });

    test('should return bool if data source call succeeds', () async {
      // arrange
      when(dataSource.isOpen()).thenAnswer((_) async => true);

      // act
      final actual = await repository.getIsOpen();

      // assert
      expect(actual, const Right(true));
    });
  });

  group('getOpeningHours', () {
    test('should return ServerFailure if data source call fails', () async {
      // arrange
      when(dataSource.getOpeningHours()).thenThrow(
        ServerException(error: 'some error'),
      );

      // act
      final actual = await repository.getOpeningHours();

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });

    test('should return map if data source call succeeds', () async {
      // arrange
      when(dataSource.getOpeningHours()).thenAnswer((_) async => []);

      // act
      final actual = await repository.getOpeningHours();

      // assert
      actual.fold(
        (l) => fail('use case was not a success'),
        // Dart's map equality is weird, unpack the value and use mapEquals
        (r) => expect(
          mapEquals(r, {
            6: 'Closed',
            7: 'Closed',
          }),
          true,
        ),
      );
    });
  });
}
