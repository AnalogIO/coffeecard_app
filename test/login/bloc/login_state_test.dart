// ignore_for_file: prefer_const_constructors
import 'package:coffeecard/blocs/login/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const email = "test";
  const password = "1234";
  const onPage = OnPage.inputPassword;
  const error = "error";
  group('LoginState', () {
    test('supports value comparisons', () {
      expect(LoginState(), LoginState());
    });

    test('returns same object when no properties are passed', () {
      expect(LoginState().copyWith(), LoginState());
    });

    test('returns object with updated onPage when onPage is passed', () {
      expect(
        LoginState().copyWith(onPage: onPage),
        LoginState(onPage: onPage),
      );
    });

    test('returns object with updated email when email is passed', () {
      expect(
        LoginState().copyWith(email: email),
        LoginState(email: email),
      );
    });

    test('returns object with updated password when password is passed', () {
      expect(
        LoginState().copyWith(password: password),
        LoginState(password: password),
      );
    });

    test('returns object with updated error when error is passed', () {
      expect(
        LoginState().copyWith(error: error),
        LoginState(error: error),
      );
    });
  });
}
