import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/features/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'authentication_cubit_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthenticationRepository>()])
void main() {
  late AuthenticationCubit cubit;
  late MockAuthenticationRepository repo;

  provideDummy(TaskOption<AuthenticationInfo>.none());
  provideDummy(Task.of(unit));

  setUp(() {
    repo = MockAuthenticationRepository();
    cubit = AuthenticationCubit(repo);
    provideDummy<Option<AuthenticationInfo>>(none());
  });

  const testAuthInfo = AuthenticationInfo(
    email: 'a',
    token: 'b',
    encodedPasscode: 'c',
  );

  test('initial state is AuthenticationState.unknown', () {
    expect(cubit.state, const AuthenticationState.unknown());
  });

  group('appStarted', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'GIVEN no authentication info is stored '
      'WHEN appStarted is called '
      'THEN emit [AuthenticationState.unauthenticated()]',
      build: () => cubit,
      setUp: () =>
          when(repo.getAuthenticationInfo()).thenReturn(TaskOption.none()),
      act: (_) => cubit.appStarted(),
      expect: () => [const AuthenticationState.unauthenticated()],
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'GIVEN authentication info is stored '
      'WHEN appStarted is called '
      'THEN emit [AuthenticationState.authenticated]',
      build: () => cubit,
      setUp: () => when(repo.getAuthenticationInfo())
          .thenReturn(TaskOption.of(testAuthInfo)),
      act: (_) => cubit.appStarted(),
      expect: () => [const AuthenticationState.authenticated(testAuthInfo)],
    );
  });

  group('authenticated', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'GIVEN an authentication info '
      'WHEN authenticated is called '
      'THEN emit [AuthenticationState.authenticated] and save the info',
      build: () => cubit,
      setUp: () => when(repo.saveAuthenticationInfo(testAuthInfo))
          .thenReturn(Task.of(unit)),
      act: (_) => cubit.authenticated(testAuthInfo),
      expect: () => [const AuthenticationState.authenticated(testAuthInfo)],
      verify: (_) =>
          verify(repo.saveAuthenticationInfo(testAuthInfo)).called(1),
    );
  });

  group('unauthenticated', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [Unauthenticated] and clear the user from storage',
      build: () => cubit,
      setUp: () =>
          when(repo.clearAuthenticationInfo()).thenReturn(Task.of(unit)),
      act: (_) => cubit.unauthenticated(),
      expect: () => [const AuthenticationState.unauthenticated()],
      verify: (_) => verify(repo.clearAuthenticationInfo()).called(1),
    );
  });
}
