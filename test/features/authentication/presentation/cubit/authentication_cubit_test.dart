import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/features/authentication/domain/entities/authenticated_user.dart';
import 'package:coffeecard/features/authentication/domain/usecases/clear_authenticated_user.dart';
import 'package:coffeecard/features/authentication/domain/usecases/get_authenticated_user.dart';
import 'package:coffeecard/features/authentication/domain/usecases/save_authenticated_user.dart';
import 'package:coffeecard/features/authentication/presentation/cubits/authentication_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'authentication_cubit_test.mocks.dart';

@GenerateMocks(
  [GetAuthenticatedUser, ClearAuthenticatedUser, SaveAuthenticatedUser],
)
void main() {
  const dummyUser = AuthenticatedUser(
    email: 'email',
    token: 'token',
    encodedPasscode: 'encodedPasscode',
  );

  group('authentication cubit tests', () {
    late AuthenticationCubit authenticationCubit;
    late MockGetAuthenticatedUser getAuthenticatedUser;
    late MockClearAuthenticatedUser clearAuthenticatedUser;
    late MockSaveAuthenticatedUser saveAuthenticatedUser;

    setUp(() {
      getAuthenticatedUser = MockGetAuthenticatedUser();
      clearAuthenticatedUser = MockClearAuthenticatedUser();
      saveAuthenticatedUser = MockSaveAuthenticatedUser();
      authenticationCubit = AuthenticationCubit(
        getAuthenticatedUser: getAuthenticatedUser,
        clearAuthenticatedUser: clearAuthenticatedUser,
        saveAuthenticatedUser: saveAuthenticatedUser,
      );
    });

    test('initial state is AuthenticationState.unknown', () {
      expect(authenticationCubit.state, const AuthenticationState.unknown());
    });

    group('appStarted', () {
      blocTest<AuthenticationCubit, AuthenticationState>(
        'emits unauthenticated when no user is stored',
        build: () {
          when(getAuthenticatedUser()).thenAnswer((_) async => null);
          return authenticationCubit;
        },
        act: (cubit) => cubit.appStarted(),
        expect: () => [const AuthenticationState.unauthenticated()],
      );

      blocTest<AuthenticationCubit, AuthenticationState>(
        'emits authenticated when a user is stored',
        build: () {
          when(getAuthenticatedUser()).thenAnswer((_) async => dummyUser);
          return authenticationCubit;
        },
        act: (cubit) => cubit.appStarted(),
        expect: () => [const AuthenticationState.authenticated(dummyUser)],
      );
    });

    group('saveAuthenticatedUser', () {
      blocTest<AuthenticationCubit, AuthenticationState>(
        'emits authenticated and saves the user to storage',
        build: () => authenticationCubit,
        act: (cubit) =>
            cubit.authenticated('email', 'encodedPasscode', 'token'),
        expect: () => [const AuthenticationState.authenticated(dummyUser)],
        verify: (cubit) => verify(
          saveAuthenticatedUser(
            const AuthenticatedUser(
              email: 'email',
              token: 'token',
              encodedPasscode: 'encodedPasscode',
            ),
          ),
        ),
      );
    });

    group('unauthenticated', () {
      blocTest<AuthenticationCubit, AuthenticationState>(
        'emits unauthenticated and clears the user from storage',
        build: () => authenticationCubit,
        act: (cubit) => cubit.unauthenticated(),
        expect: () => [const AuthenticationState.unauthenticated()],
        verify: (cubit) => verify(clearAuthenticatedUser()),
      );
    });
  });
}
