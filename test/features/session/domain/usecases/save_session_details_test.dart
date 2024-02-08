import 'package:coffeecard/features/session/data/datasources/session_local_data_source.dart';
import 'package:coffeecard/features/session/domain/usecases/save_session_details.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'save_session_details_test.mocks.dart';

@GenerateMocks([SessionLocalDataSource])
void main() {
  late MockSessionLocalDataSource localDataSource;
  late SaveSessionDetails usecase;

  setUp(() {
    localDataSource = MockSessionLocalDataSource();
    usecase = SaveSessionDetails(dataSource: localDataSource);
  });

  test('should call data source', () async {
    // arrange
    when(localDataSource.saveSessionDetails(any))
        .thenAnswer((_) async => const Right(null));

    // act
    await usecase(
      lastLogin: some(DateTime(2023)),
      sessionTimeout: some(Duration.zero),
    );

    // assert
    verify(localDataSource.saveSessionDetails(any));
  });
}
