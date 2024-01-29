import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/register/data/datasources/register_remote_data_source.dart';
import 'package:coffeecard/features/register/domain/usecases/register_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'register_user_test.mocks.dart';

@GenerateMocks([RegisterRemoteDataSource])
void main() {
  late MockRegisterRemoteDataSource remoteDataSource;
  late RegisterUser usecase;

  setUp(() {
    remoteDataSource = MockRegisterRemoteDataSource();
    usecase = RegisterUser(remoteDataSource: remoteDataSource);

    provideDummy<Either<Failure, Unit>>(
      const Left(ConnectionFailure()),
    );
  });

  test('should call data source', () async {
    // arrange
    when(remoteDataSource.register(any, any, any, any))
        .thenAnswer((_) async => const Right(unit));

    // act
    await usecase(
      name: 'name',
      email: 'email',
      encodedPasscode: 'encodedPasscode',
      occupationId: 0,
    );

    // assert
    verify(remoteDataSource.register(any, any, any, any));
  });
}
