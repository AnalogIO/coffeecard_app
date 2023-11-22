import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/external/date_service.dart';
import 'package:coffeecard/features/authentication/domain/entities/authenticated_user.dart';
import 'package:coffeecard/features/authentication/domain/usecases/clear_authenticated_user.dart';
import 'package:coffeecard/features/authentication/domain/usecases/get_authenticated_user.dart';
import 'package:coffeecard/features/authentication/domain/usecases/save_authenticated_user.dart';
import 'package:coffeecard/features/authentication/presentation/cubits/authentication_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'authentication_cubit_test.mocks.dart';

@GenerateMocks(
  [
    GetAuthenticatedUser,
    ClearAuthenticatedUser,
    SaveAuthenticatedUser,
    DateService,
  ],
)
void main() {
  late AuthenticationCubit cubit;
  late MockGetAuthenticatedUser getAuthenticatedUser;
  late MockClearAuthenticatedUser clearAuthenticatedUser;
  late MockSaveAuthenticatedUser saveAuthenticatedUser;
  late MockDateService dateService;

  setUp(() {
    getAuthenticatedUser = MockGetAuthenticatedUser();
    clearAuthenticatedUser = MockClearAuthenticatedUser();
    saveAuthenticatedUser = MockSaveAuthenticatedUser();
    dateService = MockDateService();
    cubit = AuthenticationCubit(
      getAuthenticatedUser: getAuthenticatedUser,
      clearAuthenticatedUser: clearAuthenticatedUser,
      saveAuthenticatedUser: saveAuthenticatedUser,
      dateService: dateService,
    );
  });

  final testUser = AuthenticatedUser(
    email: 'email',
    token: 'token',
    encodedPasscode: 'encodedPasscode',
    lastLogin: DateTime.parse('2012-02-27'),
  );

  test('initial state is AuthenticationState.unknown', () {
    expect(cubit.state, const AuthenticationState.unknown());
  });

  group('appStarted', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [Unauthenticated] when no user is stored',
      build: () => cubit,
      setUp: () => when(getAuthenticatedUser()).thenAnswer((_) async => none()),
      act: (_) => cubit.appStarted(),
      expect: () => [const AuthenticationState.unauthenticated()],
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [Authenticated] when a user is stored',
      build: () => cubit,
      setUp: () =>
          when(getAuthenticatedUser()).thenAnswer((_) async => Some(testUser)),
      act: (_) => cubit.appStarted(),
      expect: () => [AuthenticationState.authenticated(testUser)],
    );
  });

  group('authenticated', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [Unauthenticated] when session has expired',
      build: () => cubit,
      setUp: () {
        when(dateService.currentDateTime)
            .thenReturn(DateTime.parse('2012-02-27'));

        final testUser = AuthenticatedUser(
          email: 'email',
          token: 'token',
          encodedPasscode: 'encodedPasscode',
          lastLogin: DateTime.parse('2012-02-20'),
          sessionTimeout: const Duration(hours: 2),
        );

        when(getAuthenticatedUser()).thenAnswer((_) async => Some(testUser));
      },
      act: (_) => cubit.appStarted(),
      expect: () => [const AuthenticationState.unauthenticated()],
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
      setUp: () => when(dateService.currentDateTime)
          .thenReturn(DateTime.parse('2012-02-27')),
      expect: () => [AuthenticationState.authenticated(testUser)],
      verify: (_) => verify(
        saveAuthenticatedUser(
          email: testUser.email,
          token: testUser.token,
          encodedPasscode: testUser.encodedPasscode,
          lastLogin: DateTime.parse('2012-02-27'),
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

  group('saveSessionTimeout', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should update sessionTimeout for user',
      build: () => cubit,
      act: (_) => cubit.saveSessionTimeout(const Duration(hours: 2)),
      setUp: () =>
          when(getAuthenticatedUser()).thenAnswer((_) async => Some(testUser)),
      verify: (_) => verify(
        saveAuthenticatedUser(
          email: testUser.email,
          token: testUser.token,
          encodedPasscode: testUser.encodedPasscode,
          lastLogin: testUser.lastLogin,
          sessionTimeout: const Duration(hours: 2),
        ),
      ),
    );
  });
}
