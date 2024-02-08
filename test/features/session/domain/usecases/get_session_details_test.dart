import 'package:coffeecard/features/session/data/datasources/session_local_data_source.dart';
import 'package:coffeecard/features/session/data/models/session_details_model.dart';
import 'package:coffeecard/features/session/domain/usecases/get_session_details.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_session_details_test.mocks.dart';

@GenerateMocks([SessionLocalDataSource])
void main() {
  late MockSessionLocalDataSource localDataSource;
  late GetSessionDetails usecase;

  setUp(() {
    localDataSource = MockSessionLocalDataSource();
    usecase = GetSessionDetails(dataSource: localDataSource);

    provideDummy<Option<SessionDetailsModel>>(none());
  });

  test('should call data source', () async {
    // arrange
    when(localDataSource.getSessionDetails()).thenAnswer((_) async => none());

    // act
    await usecase();

    // assert
    verify(localDataSource.getSessionDetails());
  });
}
