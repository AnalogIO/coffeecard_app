import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/blocs/authentication/authentication_bloc.dart';
import 'package:coffeecard/model/account/user.dart';
import 'package:coffeecard/persistence/repositories/account_repository.dart';
import 'package:coffeecard/persistence/repositories/authentication_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

/*
* Large parts of this file is taken from the flutter login example in https://github.com/felangel/bloc as of the d505e54 commit
* The code is used under the following license:
* MIT License

Copyright (c) 2018 Felix Angelov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
* */

class MockAuthenticationRepository extends Mock
    implements AuthenticationService {}

class MockAccountRepository extends Mock implements AccountRepository {}

void main() {
  final user = User(
      email: "test@test.dk",
      name: "",
      password: "",
      programmeId: 1,
      privacyActivated: false);
  AuthenticationService authenticationRepository;
  AccountRepository accountRepository;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    when(authenticationRepository.status)
        .thenAnswer((_) => const Stream.empty());
    accountRepository = MockAccountRepository();
  });

  group('AuthenticationBloc', () {
    test('initial state is AuthenticationState.unknown', () {
      final authenticationBloc =
          AuthBloc(authenticationRepository, accountRepository);
      expect(authenticationBloc.state, const AuthState.unknown());
      authenticationBloc.close();
    });

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when status is unauthenticated',
      build: () {
        when(authenticationRepository.status).thenAnswer(
          (_) => Stream.value(AuthenticationStatus.unauthenticated),
        );
        return AuthBloc(authenticationRepository, accountRepository);
      },
      expect: const <AuthState>[
        AuthState.unauthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [authenticated] when status is authenticated',
      build: () {
        when(authenticationRepository.status).thenAnswer(
          (_) => Stream.value(AuthenticationStatus.authenticated),
        );
        when(accountRepository.getUser()).thenAnswer((_) async => user);
        return AuthBloc(authenticationRepository, accountRepository);
      },
      expect: <AuthState>[AuthState.authenticated(user)],
    );
  });

  group('AuthenticationStatusChanged', () {
    blocTest<AuthBloc, AuthState>(
      'emits [authenticated] when status is authenticated',
      build: () {
        when(authenticationRepository.status).thenAnswer(
          (_) => Stream.value(AuthenticationStatus.authenticated),
        );
        when(accountRepository.getUser()).thenAnswer((_) async => user);
        return AuthBloc(authenticationRepository, accountRepository);
      },
      act: (bloc) => bloc.add(
        const AuthenticationStatusChanged(AuthenticationStatus.authenticated),
      ),
      expect: <AuthState>[AuthState.authenticated(user)],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when status is unauthenticated',
      build: () {
        when(authenticationRepository.status).thenAnswer(
          (_) => Stream.value(AuthenticationStatus.unauthenticated),
        );
        return AuthBloc(authenticationRepository, accountRepository);
      },
      act: (bloc) => bloc.add(
        const AuthenticationStatusChanged(AuthenticationStatus.unauthenticated),
      ),
      expect: const <AuthState>[AuthState.unauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when status is authenticated but getUser fails',
      build: () {
        when(accountRepository.getUser()).thenThrow(Exception('oops'));
        return AuthBloc(authenticationRepository, accountRepository);
      },
      act: (bloc) => bloc.add(
        const AuthenticationStatusChanged(AuthenticationStatus.authenticated),
      ),
      expect: const <AuthState>[AuthState.unauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when status is authenticated '
      'but getUser returns null',
      build: () {
        when(accountRepository.getUser()).thenAnswer((_) async => null);
        return AuthBloc(authenticationRepository, accountRepository);
      },
      act: (bloc) => bloc.add(
        const AuthenticationStatusChanged(AuthenticationStatus.authenticated),
      ),
      expect: const <AuthState>[AuthState.unauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [unknown] when status is unknown',
      build: () {
        when(authenticationRepository.status).thenAnswer(
          (_) => Stream.value(AuthenticationStatus.unknown),
        );
        return AuthBloc(authenticationRepository, accountRepository);
      },
      act: (bloc) => bloc.add(
        const AuthenticationStatusChanged(AuthenticationStatus.unknown),
      ),
      expect: const <AuthState>[
        AuthState.unknown(),
      ],
    );
  });

  group('AuthenticationLogoutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'calls logOut on authenticationRepository '
      'when AuthenticationLogoutRequested is added',
      build: () {
        return AuthBloc(authenticationRepository, accountRepository);
      },
      act: (bloc) => bloc.add(AuthenticationLogoutRequested()),
      verify: (_) {
        verify(authenticationRepository.logOut()).called(1);
      },
    );
  });
}
