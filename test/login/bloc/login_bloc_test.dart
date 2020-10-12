import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/blocs/login/login_bloc.dart';
import 'package:coffeecard/persistence/repositories/authentication_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

class FakeResponse extends Fake implements Response {
  @override
  final Map<String, String> data = {"message": "Error from the API"};
}

void main() {
  LoginBloc loginBloc;
  MockAuthenticationRepository authenticationRepository;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    loginBloc = LoginBloc(authenticationRepository: authenticationRepository);
  });

  group('LoginBloc', () {
    test('throws AssertionError when authenticationRepository is null', () {
      expect(() => LoginBloc(authenticationRepository: null), throwsAssertionError);
    });

    test('initial state is LoginState', () {
      expect(loginBloc.state, const LoginState());
    });

    group('LoginEmailSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        "Empty email field submitted updates error",
        build: () => loginBloc,
        act: (bloc) {
          bloc..add(const LoginEmailChanged(''))..add(const LoginEmailSubmitted());
        },
        expect: const <LoginState>[
          LoginState(),
          LoginState(
            error: "Enter an email",
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        "Malformed email field submitted updates error",
        build: () => loginBloc,
        act: (bloc) {
          bloc..add(const LoginEmailChanged('test'))..add(const LoginEmailSubmitted());
        },
        expect: const <LoginState>[
          LoginState(email: "test"),
          LoginState(
            email: "test",
            error: "Enter a valid email",
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>("Valid email submitted updates OnPage and email value in state",
          build: () => loginBloc,
          act: (bloc) {
            bloc..add(const LoginEmailChanged("test@test.dk"))..add(const LoginEmailSubmitted());
          },
          expect: const <LoginState>[
            LoginState(email: "test@test.dk"),
            LoginState(email: "test@test.dk", onPage: OnPage.inputPassword)
          ]);
    });

    group('LoginSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        "login method is called when pin is 4 digits",
        build: () {
          when(authenticationRepository.logIn(
            'test@test.dk', '1234',
            // ignore: void_checks
          )).thenAnswer((_) => Future(() => SuccessfulLogin()));
          return loginBloc;
        },
        act: (bloc) {
          bloc
            ..add(const LoginEmailChanged('test@test.dk'))
            ..add(const LoginEmailSubmitted())
            ..add(const LoginNumpadPressed('1'))
            ..add(const LoginNumpadPressed('2'))
            ..add(const LoginNumpadPressed('3'))
            ..add(const LoginNumpadPressed('4'));
        },
        expect: const <LoginState>[
          LoginState(
            email: 'test@test.dk',
          ),
          LoginState(
            email: 'test@test.dk',
            onPage: OnPage.inputPassword,
          ),
          LoginState(
            email: 'test@test.dk',
            onPage: OnPage.inputPassword,
            password: '1',
          ),
          LoginState(
            email: 'test@test.dk',
            onPage: OnPage.inputPassword,
            password: '12',
          ),
          LoginState(
            email: 'test@test.dk',
            onPage: OnPage.inputPassword,
            password: '123',
          ),
          LoginState(
            email: 'test@test.dk',
            onPage: OnPage.inputPassword,
            password: '1234',
            isLoading: true,
          ),
          LoginState(
            email: 'test@test.dk',
            onPage: OnPage.inputPassword,
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'updates error when logIn fails with error from api',
        build: () {
          when(authenticationRepository.logIn('test@test.dk', '1234'))
              .thenAnswer((_) => Future(() => FailedLogin("Error from the API")));
          return loginBloc;
        },
        act: (bloc) {
          bloc
            ..add(const LoginEmailChanged('test@test.dk'))
            ..add(const LoginEmailSubmitted())
            ..add(const LoginNumpadPressed('1'))
            ..add(const LoginNumpadPressed('2'))
            ..add(const LoginNumpadPressed('3'))
            ..add(const LoginNumpadPressed('4'));
        },
        expect: const <LoginState>[
          LoginState(
            email: 'test@test.dk',
          ),
          LoginState(
            email: 'test@test.dk',
            onPage: OnPage.inputPassword,
          ),
          LoginState(
            email: 'test@test.dk',
            onPage: OnPage.inputPassword,
            password: '1',
          ),
          LoginState(
            email: 'test@test.dk',
            onPage: OnPage.inputPassword,
            password: '12',
          ),
          LoginState(
            email: 'test@test.dk',
            onPage: OnPage.inputPassword,
            password: '123',
          ),
          LoginState(
            email: 'test@test.dk',
            onPage: OnPage.inputPassword,
            isLoading: true,
            password: '1234',
          ),
          LoginState(email: 'test@test.dk', onPage: OnPage.inputPassword, error: "Error from the API"),
        ],
      );
    });

    group('LoginGoBack', () {
      blocTest<LoginBloc, LoginState>(
        "LoginGoBack returns to email input",
        build: () => loginBloc,
        act: (bloc) {
          bloc
            ..add(const LoginEmailChanged('test@test.dk'))
            ..add(const LoginEmailSubmitted())
            ..add(const LoginGoBack());
        },
        expect: const <LoginState>[
          LoginState(
            email: "test@test.dk",
          ),
          LoginState(email: "test@test.dk", onPage: OnPage.inputPassword),
          LoginState()
        ],
      );
    });

    group('LoginNumpadPressed', () {
      blocTest<LoginBloc, LoginState>(
        "LoginNumpadPressed reset removes one digit from pin",
        build: () => loginBloc,
        act: (bloc) {
          bloc..add(const LoginNumpadPressed('1'))..add(const LoginNumpadPressed('2'))..add(
              const LoginNumpadPressed('reset'));
        },
        expect: const <LoginState>[
          LoginState(
            password: "1",
          ),
          LoginState(password: "12"),
          LoginState(password: "1")
        ],
      );
    });
  });
}
