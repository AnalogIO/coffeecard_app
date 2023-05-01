import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/data/storage/secure_storage.dart';
import 'package:coffeecard/models/account/authenticated_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'authentication_cubit_test.mocks.dart';

@GenerateMocks([SecureStorage])
void main() {
  const dummyUser = AuthenticatedUser(email: 'email', token: 'token');

  group('authentication cubit tests', () {
    late AuthenticationCubit authenticationCubit;
    final secureStorage = MockSecureStorage();

    setUp(() {
      authenticationCubit = AuthenticationCubit(secureStorage);
    });

    test('initial state is AuthenticationState.unknown', () {
      expect(authenticationCubit.state, const AuthenticationState.unknown());
    });

    blocTest<AuthenticationCubit, AuthenticationState>(
      'appStarted emits unauthenticated when no user is stored',
      build: () {
        when(secureStorage.getAuthenticatedUser())
            .thenAnswer((_) async => null);
        return authenticationCubit;
      },
      act: (cubit) => cubit.appStarted(),
      expect: () => [const AuthenticationState.unauthenticated()],
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'appStarted emits authenticated when a user is stored',
      build: () {
        when(secureStorage.getAuthenticatedUser())
            .thenAnswer((_) async => dummyUser);
        return authenticationCubit;
      },
      act: (cubit) => cubit.appStarted(),
      expect: () => [const AuthenticationState.authenticated(dummyUser)],
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'authenticated emits authenticated and saves the user to storage',
      build: () => authenticationCubit,
      act: (cubit) => cubit.authenticated('email', 'encodedPasscode', 'token'),
      expect: () => [const AuthenticationState.authenticated(dummyUser)],
      verify: (cubit) => verify(
        secureStorage.saveAuthenticatedUser(
          'email',
          'encodedPasscode',
          'token',
        ),
      ),
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'unauthenticated emits unauthenticated and clears the user from storage',
      build: () => authenticationCubit,
      act: (cubit) => cubit.unauthenticated(),
      expect: () => [const AuthenticationState.unauthenticated()],
      verify: (cubit) => verify(secureStorage.clearAuthenticatedUser()),
    );

    tearDown(() {
      authenticationCubit.close();
    });
  });
}
