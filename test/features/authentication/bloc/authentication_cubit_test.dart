import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/features/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'authentication_cubit_test.mocks.dart';

@GenerateMocks([AuthenticationRepository])
void main() {
  late AuthenticationCubit cubit;
  late MockAuthenticationRepository repo;

  provideDummy<TaskOption<AuthenticationInfo>>(TaskOption.none());
  provideDummy<Task<Unit>>(Task.of(unit));

  setUp(() {
    repo = MockAuthenticationRepository();
    cubit = AuthenticationCubit(repo);
    provideDummy<Option<AuthenticationInfo>>(none());
  });

  const testAuthenticationInfo = AuthenticationInfo(
    email: 'email',
    token: 'token',
    encodedPasscode: 'encodedPasscode',
  );

  test('initial state is AuthenticationState.unknown', () {
    expect(cubit.state, const AuthenticationState.unknown());
  });

  group('appStarted', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [Unauthenticated] when no user is stored',
      build: () => cubit,
      setUp: () => when(repo.getAuthenticationInfo())
          .thenAnswer((_) => TaskOption.none()),
      act: (_) => cubit.appStarted(),
      expect: () => [const AuthenticationState.unauthenticated()],
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [Authenticated] when a user is stored',
      build: () => cubit,
      setUp: () => when(repo.getAuthenticationInfo())
          .thenAnswer((_) => TaskOption.some(testAuthenticationInfo)),
      act: (_) => cubit.appStarted(),
      expect: () => [
        const AuthenticationState.authenticated(testAuthenticationInfo),
      ],
    );
  });

  group('authenticated', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [Authenticated] and save the user to storage',
      build: () => cubit,
      setUp: () => when(repo.saveAuthenticationInfo(testAuthenticationInfo))
          .thenAnswer((_) => Task.of(unit)),
      act: (_) => cubit.authenticated(testAuthenticationInfo),
      expect: () =>
          [const AuthenticationState.authenticated(testAuthenticationInfo)],
      verify: (_) => verify(
        repo.saveAuthenticationInfo(testAuthenticationInfo),
      ),
    );
  });

  group('unauthenticated', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [Unauthenticated] and clear the user from storage',
      build: () => cubit,
      setUp: () =>
          when(repo.clearAuthenticationInfo()).thenAnswer((_) => Task.of(unit)),
      act: (_) => cubit.unauthenticated(),
      expect: () => [const AuthenticationState.unauthenticated()],
      verify: (_) => verify(repo.clearAuthenticationInfo()),
    );
  });
}
