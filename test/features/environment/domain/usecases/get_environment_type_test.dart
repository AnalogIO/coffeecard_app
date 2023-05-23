import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/environment/data/datasources/environment_remote_data_source.dart';
import 'package:coffeecard/features/environment/domain/entities/environment.dart';
import 'package:coffeecard/features/environment/domain/usecases/get_environment_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_environment_type_test.mocks.dart';

@GenerateMocks([EnvironmentRemoteDataSource])
void main() {
  late MockEnvironmentRemoteDataSource remoteDataSource;
  late GetEnvironmentType usecase;

  setUp(() {
    remoteDataSource = MockEnvironmentRemoteDataSource();
    usecase = GetEnvironmentType(remoteDataSource: remoteDataSource);
  });

  test('should call data source', () async {
    // arrange
    when(remoteDataSource.getEnvironmentType())
        .thenAnswer((_) async => const Right(Environment.production));

    // act
    await usecase(NoParams());

    // assert
    verify(remoteDataSource.getEnvironmentType());
  });
}
