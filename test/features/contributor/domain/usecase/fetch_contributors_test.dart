import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/occupation/data/datasources/occupation_remote_data_source.dart';
import 'package:coffeecard/features/occupation/domain/usecases/get_occupations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/contributor/data/datasources/contributor_local_data_source.dart';
import 'package:coffeecard/features/contributor/domain/entities/contributor.dart';
import 'package:dartz/dartz.dart';
import 'package:coffeecard/features/contributor/domain/usecases/fetch_contributors.dart';

import 'fetch_contributors_test.mocks.dart';

@GenerateMocks([ContributorLocalDataSource])
void main() {
  late MockContributorLocalDataSource dataSource;
  late FetchContributors usecase;

  setUp(() {
    dataSource = MockContributorLocalDataSource();
    usecase = FetchContributors(dataSource: dataSource);
  });

  test('should call repository', () async {
    // arrange
    when(dataSource.getContributors()).thenReturn(const []);

    // act
    await usecase(NoParams());

    // assert
    verify(dataSource.getContributors());
    verifyNoMoreInteractions(dataSource);
  });
}
