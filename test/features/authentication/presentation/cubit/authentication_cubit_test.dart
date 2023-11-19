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
  [
    GetAuthenticatedUser,
    ClearAuthenticatedUser,
    SaveAuthenticatedUser,
  ],
)
void main() {
  late AuthenticationCubit cubit;
  late MockGetAuthenticatedUser getAuthenticatedUser;
  late MockClearAuthenticatedUser clearAuthenticatedUser;
  late MockSaveAuthenticatedUser saveAuthenticatedUser;

  setUp(() {
    getAuthenticatedUser = MockGetAuthenticatedUser();
    clearAuthenticatedUser = MockClearAuthenticatedUser();
    saveAuthenticatedUser = MockSaveAuthenticatedUser();
    cubit = AuthenticationCubit(
      getAuthenticatedUser: getAuthenticatedUser,
      clearAuthenticatedUser: clearAuthenticatedUser,
      saveAuthenticatedUser: saveAuthenticatedUser,
    );
  });

  const testUser = AuthenticatedUser(
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
      setUp: () => when(getAuthenticatedUser()).thenAnswer((_) async => null),
      act: (_) => cubit.appStarted(),
      expect: () => [const AuthenticationState.unauthenticated()],
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [Authenticated] when a user is stored',
      build: () => cubit,
      setUp: () =>
          when(getAuthenticatedUser()).thenAnswer((_) async => testUser),
      act: (_) => cubit.appStarted(),
      expect: () => [const AuthenticationState.authenticated(testUser)],
    );
  });

  group('authenticated', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [Authenticated] and save the user to storage',
      build: () => cubit,
      act: (_) => cubit.authenticated(
        testUser.email,
        testUser.encodedPasscode,
        testUser.token,
      ),
      expect: () => [const AuthenticationState.authenticated(testUser)],
      verify: (_) => verify(
        saveAuthenticatedUser(
          email: testUser.email,
          token: testUser.token,
          encodedPasscode: testUser.encodedPasscode,
        ),
      ),
    );
  });

  group('unauthenticated', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [Unauthenticated] and clear the user from storage',
      build: () => cubit,
      act: (_) => cubit.unauthenticated(),
      expect: () => [const AuthenticationState.unauthenticated()],
      verify: (_) => verify(clearAuthenticatedUser()),
    );
  });
}
