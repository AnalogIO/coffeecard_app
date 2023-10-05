import 'package:coffeecard/features/contributor/data/datasources/contributor_local_data_source.dart';
import 'package:coffeecard/features/contributor/domain/usecases/fetch_contributors.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'fetch_contributors_test.mocks.dart';

@GenerateMocks([ContributorLocalDataSource])
void main() {
  late MockContributorLocalDataSource dataSource;
  late FetchContributors usecase;

  setUp(() {
    dataSource = MockContributorLocalDataSource();
    usecase = FetchContributors(dataSource: dataSource);
  });

  test('should call data source', () async {
    // arrange
    when(dataSource.getContributors()).thenReturn(const []);

    // act
    await usecase();

    // assert
    verify(dataSource.getContributors());
    verifyNoMoreInteractions(dataSource);
  });
}
