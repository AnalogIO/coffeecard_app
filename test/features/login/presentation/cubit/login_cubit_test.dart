import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/authentication/domain/entities/authenticated_user.dart';
import 'package:coffeecard/features/authentication/presentation/cubits/authentication_cubit.dart';
import 'package:coffeecard/features/login/domain/usecases/login_user.dart';
import 'package:coffeecard/features/login/domain/usecases/resend_email.dart';
import 'package:coffeecard/features/login/presentation/cubit/login_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_cubit_test.mocks.dart';

@GenerateMocks([
  AuthenticationCubit,
  LoginUser,
  ResendEmail,
])
void main() {
  late LoginCubit cubit;
  late MockAuthenticationCubit authenticationCubit;
  late MockLoginUser loginUser;
  late MockResendEmail resendEmail;

  setUp(() {
    authenticationCubit = MockAuthenticationCubit();
    loginUser = MockLoginUser();
    resendEmail = MockResendEmail();
    cubit = LoginCubit(
        email: '',
        authenticationCubit: authenticationCubit,
        loginUser: loginUser,
        resendEmail: resendEmail);

    provideDummy<Either<Failure, AuthenticatedUser>>(
      const Left(ConnectionFailure()),
    );
  });

  test('initial state is [LoginTypingPasscode]', () {
    expect(cubit.state, const LoginTypingPasscode(''));
  });

  group('addPasscodeInput', () {
    blocTest(
      'should only emit [TypingPasscode] when passcode length is less than 4',
      build: () => cubit,
      act: (_) => cubit
        ..addPasscodeInput('1')
        ..addPasscodeInput('2')
        ..addPasscodeInput('3'),
      expect: () => [
        const LoginTypingPasscode('1'),
        const LoginTypingPasscode('12'),
        const LoginTypingPasscode('123'),
      ],
    );

    blocTest(
      'should emit [TypingPasscode, Loading, Error] when passcode length is 4 and login fails',
      build: () {
        when(
          loginUser(
            email: anyNamed('email'),
            encodedPasscode: anyNamed('encodedPasscode'),
          ),
        ).thenAnswer(
          (_) async => const Left(ServerFailure('some error', 500)),
        );
        return cubit
          ..addPasscodeInput('1')
          ..addPasscodeInput('2')
          ..addPasscodeInput('3');
      },
      act: (_) => cubit.addPasscodeInput('4'),
      expect: () => [
        const LoginTypingPasscode('1234'),
        const LoginLoading(),
        const LoginError('some error'),
      ],
    );
  });

  group('clearPasscode', () {
    blocTest(
      'should emit [TypingPasscode] with empty string',
      build: () => cubit,
      act: (_) => cubit
        ..addPasscodeInput('1')
        ..addPasscodeInput('2')
        ..addPasscodeInput('3')
        ..clearPasscode(),
      expect: () => [
        const LoginTypingPasscode('1'),
        const LoginTypingPasscode('12'),
        const LoginTypingPasscode('123'),
        const LoginTypingPasscode(''),
      ],
    );
  });
}
