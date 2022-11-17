import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/cubits/login/login_cubit.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_cubit_test.mocks.dart';

@GenerateMocks([AuthenticationCubit])
@GenerateMocks([AccountRepository])
void main() {
  group('login cubit tests', () {
    late LoginCubit loginCubit;
    final authenticationCubit = MockAuthenticationCubit();
    final accountRepository = MockAccountRepository();

    setUp(() {
      loginCubit = LoginCubit(
        email: '',
        authenticationCubit: authenticationCubit,
        accountRepository: accountRepository,
      );
    });

    test('initial state is LoginTypingPasscode', () {
      expect(loginCubit.state, const LoginTypingPasscode(''));
    });

    blocTest<LoginCubit, LoginState>(
      'addPasscodeInput emits only TypingPasscode when passcode length is less than 4',
      build: () => loginCubit,
      act: (cubit) => cubit
        ..addPasscodeInput('1')
        ..addPasscodeInput('2')
        ..addPasscodeInput('3'),
      expect: () => [
        const LoginTypingPasscode('1'),
        const LoginTypingPasscode('12'),
        const LoginTypingPasscode('123'),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'addPasscodeInput emits TypingPasscode, Loading when passcode length is 4, then emits LoginError when login fails',
      build: () {
        when(accountRepository.login(any, any)).thenAnswer(
          (_) async => Left(RequestError('{"message": "ERROR"}', 0)),
        );
        return loginCubit
          ..addPasscodeInput('1')
          ..addPasscodeInput('2')
          ..addPasscodeInput('3');
      },
      act: (cubit) => cubit.addPasscodeInput('4'),
      expect: () => [
        const LoginTypingPasscode('1234'),
        const LoginLoading(),
        const LoginError('ERROR'),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'clearPasscode emits TypingPasscode with empty string',
      build: () => loginCubit,
      act: (cubit) => cubit
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

    tearDown(() {
      loginCubit.close();
    });
  });
}
