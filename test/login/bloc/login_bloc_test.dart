import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/blocs/login/login_bloc.dart';
import 'package:coffeecard/persistence/repositories/authentication_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class FakeDioError extends Fake
    implements DioError {
  @override
  Response response = FakeResponse();
}

class FakeResponse extends Fake implements Response {
  @override
  final data = {"message": "Error from the API"};
}

void main() {
  LoginBloc loginBloc;
  MockAuthenticationRepository authenticationRepository;
  FakeDioError dioError;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    loginBloc = LoginBloc(authenticationRepository: authenticationRepository);
    dioError = FakeDioError();
  });

  group('LoginBloc', () {
    test('throws AssertionError when authenticationRepository is null', () {
      expect(() => LoginBloc(authenticationRepository: null),
          throwsAssertionError);
    });

    test('initial state is LoginState', () {
      expect(loginBloc.state, LoginState());
    });

    group('LoginEmailSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        "Empty email field submitted updates error",
        build: () =>
        loginBloc
        ,
        act: (bloc) {
          bloc
            ..add(const LoginEmailChanged(''))
            ..add(const LoginEmailSubmitted());
        },
        expect: const <LoginState>[
          LoginState(
          ),
          LoginState(
            error: "Enter an email",
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        "Malformed email field submitted updates error",
        build: () =>
        loginBloc
        ,
        act: (bloc) {
          bloc
            ..add(const LoginEmailChanged('test'))
            ..add(const LoginEmailSubmitted());
        },
        expect: const <LoginState>[
          LoginState( email: "test"
          ),
          LoginState(
            email: "test",
            error: "Enter a valid email",
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
          "Valid email submitted updates OnPage and email value in state",
          build: () =>
          loginBloc
          ,
          act: (bloc) {
            bloc
              ..add(const LoginEmailChanged("test@test.dk"))
              ..add(const LoginEmailSubmitted());
          },
          expect: const <LoginState>[
            LoginState(email: "test@test.dk"),
            LoginState(
                email: "test@test.dk",
                onPage: OnPage.inputPassword)
          ]);
    });

    group('LoginSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        "login method is called when pin is 4 digits",
        build: () {
          when(authenticationRepository.logIn(
            username: 'test@test.dk',
            password: '1234',
          )).thenAnswer((_) => Future.value('user'));
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
            email: ('test@test.dk'),
          ),
          LoginState(
            email: ('test@test.dk'),
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
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>(
        'updates error when logIn fails with error from api',
        build: () {
          when(authenticationRepository.logIn(
            username: 'test@test.dk',
            password: '1234',
          )).thenThrow(dioError);
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
            email: ('test@test.dk'),
          ),
          LoginState(
            email: ('test@test.dk'),
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
          ),
          LoginState(
            email: 'test@test.dk',
            onPage: OnPage.inputPassword,
            password: '',
            error: "Error from the API"
          ),
        ],
      );
    });

    group('LoginGoBack', () {
      blocTest<LoginBloc, LoginState>(
        "LoginGoBack returns to email input",
        build: () =>
        loginBloc
        ,
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
          LoginState(
            email: "test@test.dk",
            onPage: OnPage.inputPassword
          ),
          LoginState(
            email: "test@test.dk",
            onPage: OnPage.inputEmail
          )
        ],
      );
    });

    group('LoginNumpadPressed', () {
      blocTest<LoginBloc, LoginState>(
        "LoginNumpadPressed reset removes one digit from pin",
        build: () =>
        loginBloc
        ,
        act: (bloc) {
          bloc
            ..add(const LoginNumpadPressed('1'))
            ..add(const LoginNumpadPressed('2'))
            ..add(const LoginNumpadPressed('reset'));
        },
        expect: const <LoginState>[
          LoginState(
            password: "1",
          ),
          LoginState(
            password: "12"
          ),
          LoginState(
            password: "1"
          )
        ],
      );
    });
  });
}
