import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/blocs/login/login_bloc.dart';
import 'package:coffeecard/persistence/repositories/authentication_repository.dart';
import 'package:coffeecard/widgets/components/login/login_numpad.dart';
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
      expect(loginBloc.state, const LoginState("", "", OnPage.inputEmail));
    });

    group('LoginEmailSubmitted', () {
      blocTest<LoginBloc, LoginState>(
        "Empty email field submitted updates error",
        build: () => loginBloc,
        act: (bloc) {
          bloc..add(const LoginEmailChanged(''))..add(const LoginEmailSubmitted());
        },
        expect: const <LoginState>[
          LoginState("", "", OnPage.inputEmail),
          LoginStateError("", "", OnPage.inputEmail, "Enter an email")
        ],
      );

      blocTest<LoginBloc, LoginState>(
        "Malformed email field submitted updates error",
        build: () => loginBloc,
        act: (bloc) {
          bloc..add(const LoginEmailChanged('test'))
              ..add(const LoginEmailSubmitted());
        },
        expect: const <LoginState>[
          LoginState("test", "", OnPage.inputEmail),
          LoginStateError("test", "",  OnPage.inputEmail, "Enter a valid email",
          ),
        ],
      );

      blocTest<LoginBloc, LoginState>("Valid email submitted updates OnPage and email value in state",
          build: () => loginBloc,
          act: (bloc) {
            bloc..add(const LoginEmailChanged("test@test.dk"))
                ..add(const LoginEmailSubmitted());
          },
          expect: const <LoginState>[
            LoginState("test@test.dk", "", OnPage.inputEmail),
            LoginState("test@test.dk", "" , OnPage.inputPassword)
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
            ..add(const LoginNumpadPressed(NumpadActionAdd(keypress: '1')))
            ..add(const LoginNumpadPressed(NumpadActionAdd(keypress: '2')))
            ..add(const LoginNumpadPressed(NumpadActionAdd(keypress: '3')))
            ..add(const LoginNumpadPressed(NumpadActionAdd(keypress: '4')));
        },
        expect: const <LoginState>[
          LoginState(
            'test@test.dk',
            '',
            OnPage.inputEmail
          ),
          LoginState(
            'test@test.dk',
            '',
            OnPage.inputPassword,
          ),
          LoginState(
            'test@test.dk',
            '1',
            OnPage.inputPassword,
          ),
          LoginState(
            'test@test.dk',
            '12',
            OnPage.inputPassword,
          ),
          LoginState(
            'test@test.dk',
            '123',
            OnPage.inputPassword,
          ),
          LoginStateLoading(
            'test@test.dk',
            '1234',
            OnPage.inputPassword,
          ),
          LoginState(
            'test@test.dk',
            '',
            OnPage.inputPassword,
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
            ..add(const LoginNumpadPressed(NumpadActionAdd(keypress: '1')))
            ..add(const LoginNumpadPressed(NumpadActionAdd(keypress: '2')))
            ..add(const LoginNumpadPressed(NumpadActionAdd(keypress: '3')))
            ..add(const LoginNumpadPressed(NumpadActionAdd(keypress: '4')));
        },
        expect: const <LoginState>[
          LoginState(
              'test@test.dk',
              '',
              OnPage.inputEmail
          ),
          LoginState(
            'test@test.dk',
            '',
            OnPage.inputPassword,
          ),
          LoginState(
            'test@test.dk',
            '1',
            OnPage.inputPassword,
          ),
          LoginState(
            'test@test.dk',
            '12',
            OnPage.inputPassword,
          ),
          LoginState(
            'test@test.dk',
            '123',
            OnPage.inputPassword,
          ),
          LoginStateLoading(
            'test@test.dk',
            '1234',
            OnPage.inputPassword,
          ),
          LoginStateError('test@test.dk', '', OnPage.inputPassword, "Error from the API"),
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
            "test@test.dk",
            '',
            OnPage.inputEmail
          ),
          LoginState(
              "test@test.dk",
              '',
              OnPage.inputPassword),
          LoginState(
              "",
              "",
              OnPage.inputEmail)
        ],
      );
    });

    group('LoginNumpadPressed', () {
      blocTest<LoginBloc, LoginState>(
        "LoginNumpadPressed reset removes one digit from pin",
        build: () => loginBloc,
        act: (bloc) {
          bloc..add(const LoginNumpadPressed(NumpadActionAdd(keypress: '1')))
              ..add(const LoginNumpadPressed(NumpadActionAdd(keypress: '2')))
              ..add(const LoginNumpadPressed(NumpadActionReset()));
        },
        expect: const <LoginState>[
          LoginState(
            '',
            "1",
            OnPage.inputEmail
          ),
          LoginState(
              '',
              "12",
              OnPage.inputEmail
          ),
          LoginState(
              '',
              "1",
              OnPage.inputEmail
          ),
        ],
      );
    });
  });
}
