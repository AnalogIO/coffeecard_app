import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/user/data/datasources/user_remote_data_source.dart';
import 'package:coffeecard/features/user/domain/usecases/request_account_deletion.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'request_account_deletion_test.mocks.dart';

@GenerateMocks([UserRemoteDataSource])
void main() {
  late MockUserRemoteDataSource dataSource;
  late RequestAccountDeletion usecase;

  setUp(() {
    dataSource = MockUserRemoteDataSource();
    usecase = RequestAccountDeletion(dataSource: dataSource);

    provideDummy<Either<NetworkFailure, Unit>>(
      const Left(ConnectionFailure()),
    );
  });

  test('should call repository', () async {
    // arrange
    when(dataSource.requestAccountDeletion()).thenAnswer(
      (_) async => const Right(unit),
    );

    // act
    await usecase();

    // assert
    verify(dataSource.requestAccountDeletion());
  });
}
