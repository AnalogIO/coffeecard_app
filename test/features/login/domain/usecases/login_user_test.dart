import 'package:coffeecard/core/data/datasources/account_remote_data_source.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/login/domain/usecases/login_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_user_test.mocks.dart';

@GenerateMocks([AccountRemoteDataSource])
void main() {
  late MockAccountRemoteDataSource remoteDataSource;
  late LoginUser usecase;

  setUp(() {
    remoteDataSource = MockAccountRemoteDataSource();
    usecase = LoginUser(remoteDataSource: remoteDataSource);
  });

  const testError = 'some error';

  test('should call data source', () async {
    // arrange
    when(remoteDataSource.login(any, any)).thenAnswer(
      (_) async => const Left(ServerFailure(testError)),
    );

    // act
    final actual = await usecase(
      const Params(email: 'email', encodedPasscode: 'encodedPasscode'),
    );

    // assert
    verify(remoteDataSource.login(any, any)).called(1);
    expect(actual, const Left(ServerFailure(testError)));
  });
}
