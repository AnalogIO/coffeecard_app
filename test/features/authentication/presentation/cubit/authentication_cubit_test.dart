import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/external/date_service.dart';
import 'package:coffeecard/features/authentication/domain/entities/authenticated_user.dart';
import 'package:coffeecard/features/authentication/domain/usecases/clear_authenticated_user.dart';
import 'package:coffeecard/features/authentication/domain/usecases/get_authenticated_user.dart';
import 'package:coffeecard/features/authentication/domain/usecases/save_authenticated_user.dart';
import 'package:coffeecard/features/authentication/presentation/cubits/authentication_cubit.dart';
import 'package:coffeecard/features/session/domain/entities/session_details.dart';
import 'package:coffeecard/features/session/domain/usecases/get_session_details.dart';
import 'package:coffeecard/features/session/domain/usecases/save_session_details.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'authentication_cubit_test.mocks.dart';

@GenerateNiceMocks(
  [
    MockSpec<GetAuthenticatedUser>(),
    MockSpec<ClearAuthenticatedUser>(),
    MockSpec<SaveAuthenticatedUser>(),
    MockSpec<GetSessionDetails>(),
    MockSpec<SaveSessionDetails>(),
    MockSpec<DateService>(),
  ],
)
void main() {
  late AuthenticationCubit cubit;
  late MockGetAuthenticatedUser getAuthenticatedUser;
  late MockClearAuthenticatedUser clearAuthenticatedUser;
  late MockSaveAuthenticatedUser saveAuthenticatedUser;
  late MockGetSessionDetails getSessionDetails;
  late MockSaveSessionDetails saveSessionDetails;
  late MockDateService dateService;

  setUp(() {
    getAuthenticatedUser = MockGetAuthenticatedUser();
    clearAuthenticatedUser = MockClearAuthenticatedUser();
    saveAuthenticatedUser = MockSaveAuthenticatedUser();
    getSessionDetails = MockGetSessionDetails();
    saveSessionDetails = MockSaveSessionDetails();
    dateService = MockDateService();
    cubit = AuthenticationCubit(
      getAuthenticatedUser: getAuthenticatedUser,
      clearAuthenticatedUser: clearAuthenticatedUser,
      saveAuthenticatedUser: saveAuthenticatedUser,
      getSessionDetails: getSessionDetails,
      saveSessionDetails: saveSessionDetails,
      dateService: dateService,
    );

    provideDummy<Option<SessionDetails>>(none());
    provideDummy<Option<AuthenticatedUser>>(none());
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
      setUp: () => when(getAuthenticatedUser()).thenAnswer((_) async => none()),
      act: (_) => cubit.appStarted(),
      expect: () => [const AuthenticationState.unauthenticated()],
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [Authenticated] when a user is stored',
      build: () => cubit,
      setUp: () => when(getAuthenticatedUser())
          .thenAnswer((_) async => const Some(testUser)),
      act: (_) => cubit.appStarted(),
      expect: () => [const AuthenticationState.authenticated(testUser)],
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [Unauthenticated] when a session is expired',
      build: () => cubit,
      setUp: () {
        final now = DateTime(2023);

        when(dateService.currentDateTime).thenAnswer((_) => now);

        when(getAuthenticatedUser())
            .thenAnswer((_) async => const Some(testUser));
        when(getSessionDetails()).thenAnswer(
          (_) async => some(
            SessionDetails(
              sessionTimeout: some(const Duration(seconds: 2)),
              lastLogin: some(now.subtract(const Duration(days: 2))),
            ),
          ),
        );
      },
      act: (_) => cubit.appStarted(),
      expect: () => [const AuthenticationState.unauthenticated()],
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should emit [Authenticated] when a session is still active',
      build: () => cubit,
      setUp: () {
        final now = DateTime(2023);

        when(dateService.currentDateTime).thenAnswer((_) => now);

        when(getAuthenticatedUser())
            .thenAnswer((_) async => const Some(testUser));
        when(getSessionDetails()).thenAnswer(
          (_) async => some(
            SessionDetails(
              sessionTimeout: some(const Duration(days: 2)),
              lastLogin: some(now),
            ),
          ),
        );
      },
      act: (_) => cubit.appStarted(),
      expect: () => [const AuthenticationState.authenticated(testUser)],
    );
  });

  group('authenticated', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should save the user to storage and emit [Authenticated]',
      build: () => cubit,
      act: (_) => cubit.authenticated(
        testUser.email,
        testUser.encodedPasscode,
        testUser.token,
      ),
      setUp: () => when(dateService.currentDateTime).thenReturn(DateTime(2023)),
      expect: () => [const AuthenticationState.authenticated(testUser)],
      verify: (_) => verify(
        saveAuthenticatedUser(
          email: testUser.email,
          token: testUser.token,
          encodedPasscode: testUser.encodedPasscode,
        ),
      ),
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should save session details when user has no previous session and emit [Authenticated]',
      build: () => cubit,
      act: (_) => cubit.authenticated(
        testUser.email,
        testUser.encodedPasscode,
        testUser.token,
      ),
      setUp: () {
        final now = DateTime(2023);

        when(dateService.currentDateTime).thenReturn(now);
        when(getSessionDetails()).thenAnswer((_) async => none());
      },
      expect: () => [const AuthenticationState.authenticated(testUser)],
      verify: (_) {
        verify(
          saveAuthenticatedUser(
            email: testUser.email,
            token: testUser.token,
            encodedPasscode: testUser.encodedPasscode,
          ),
        );
        verify(
          saveSessionDetails(
            lastLogin: anyNamed('lastLogin'),
            sessionTimeout: none(),
          ),
        );
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should save session details when user has previous session and emit [Authenticated]',
      build: () => cubit,
      act: (_) => cubit.authenticated(
        testUser.email,
        testUser.encodedPasscode,
        testUser.token,
      ),
      setUp: () {
        final now = DateTime(2023);

        when(dateService.currentDateTime).thenReturn(now);
        when(getSessionDetails()).thenAnswer(
          (_) async => some(
            SessionDetails(
              sessionTimeout: some(const Duration(days: 2)),
              lastLogin: none(),
            ),
          ),
        );
      },
      expect: () => [const AuthenticationState.authenticated(testUser)],
      verify: (_) {
        verify(
          saveAuthenticatedUser(
            email: testUser.email,
            token: testUser.token,
            encodedPasscode: testUser.encodedPasscode,
          ),
        );
        verify(
          saveSessionDetails(
            lastLogin: anyNamed('lastLogin'),
            sessionTimeout: some(const Duration(days: 2)),
          ),
        );
      },
    );
  });

  group('unauthenticated', () {
    blocTest<AuthenticationCubit, AuthenticationState>(
      'should clear the user from storage and emit [Unauthenticated]',
      build: () => cubit,
      act: (_) => cubit.unauthenticated(),
      expect: () => [const AuthenticationState.unauthenticated()],
      verify: (_) => verify(clearAuthenticatedUser()),
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should erase previous session if not exists and emit [Unauthenticated]',
      build: () => cubit,
      act: (_) => cubit.unauthenticated(),
      setUp: () {
        when(getSessionDetails()).thenAnswer((_) async => none());
      },
      expect: () => [const AuthenticationState.unauthenticated()],
      verify: (_) {
        verify(clearAuthenticatedUser());
        verify(
          saveSessionDetails(
            lastLogin: none(),
            sessionTimeout: none(),
          ),
        );
      },
    );

    blocTest<AuthenticationCubit, AuthenticationState>(
      'should erase previous session if exists and emit [Unauthenticated]',
      build: () => cubit,
      act: (_) => cubit.unauthenticated(),
      setUp: () {
        when(getSessionDetails()).thenAnswer(
          (_) async => some(
            SessionDetails(
              sessionTimeout: some(const Duration(days: 2)),
              lastLogin: none(),
            ),
          ),
        );
      },
      expect: () => [const AuthenticationState.unauthenticated()],
      verify: (_) {
        verify(clearAuthenticatedUser());
        verify(
          saveSessionDetails(
            lastLogin: none(),
            sessionTimeout: some(const Duration(days: 2)),
          ),
        );
      },
    );
  });
}
