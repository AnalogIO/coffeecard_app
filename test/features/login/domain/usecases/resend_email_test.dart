import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/login/data/datasources/account_remote_data_source.dart';
import 'package:coffeecard/features/login/domain/usecases/resend_email.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'resend_email_test.mocks.dart';

@GenerateMocks([AccountRemoteDataSource])
void main() {
  late MockAccountRemoteDataSource remoteDataSource;
  late ResendEmail usecase;

  setUp(() {
    remoteDataSource = MockAccountRemoteDataSource();
    usecase = ResendEmail(remoteDataSource: remoteDataSource);

    provideDummy<Either<NetworkFailure, Unit>>(
      const Left(ConnectionFailure()),
    );
  });

  const testError = 'some error';

  test('should call data source', () async {
    // arrange
    when(remoteDataSource.resendVerificationEmail(any)).thenAnswer(
      (_) async => const Left(ServerFailure(testError, 500)),
    );

    // act
    final actual = await usecase(
      'email',
    );

    // assert
    verify(remoteDataSource.resendVerificationEmail(any)).called(1);
    expect(actual, const Left(ServerFailure(testError, 500)));
  });
}
