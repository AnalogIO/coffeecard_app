import 'package:coffeecard/core/data/datasources/account_remote_data_source.dart';
import 'package:coffeecard/features/register/domain/usecases/register_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'register_user_test.mocks.dart';

@GenerateMocks([AccountRemoteDataSource])
void main() {
  late MockAccountRemoteDataSource remoteDataSource;
  late RegisterUser usecase;

  setUp(() {
    remoteDataSource = MockAccountRemoteDataSource();
    usecase = RegisterUser(remoteDataSource: remoteDataSource);
  });

  test('should call data source', () async {
    // arrange
    when(remoteDataSource.register(any, any, any, any))
        .thenAnswer((_) async => const Right(null));

    // act
    await usecase(
      const Params(
        name: 'name',
        email: 'email',
        encodedPasscode: 'encodedPasscode',
        occupationId: 0,
      ),
    );

    // assert
    verify(remoteDataSource.register(any, any, any, any));
  });
}
