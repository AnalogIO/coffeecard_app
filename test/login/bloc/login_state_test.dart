// ignore_for_file: prefer_const_constructors
import 'package:coffeecard/blocs/login/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const email = "test";
  const password = "1234";
  const onInputPasswordPage = OnPage.inputPassword;
  group('LoginState', () {
    test('supports value comparisons', () {
      expect(LoginState('', '', OnPage.inputEmail), LoginState('', '', OnPage.inputEmail));
    });

    test('returns same object when no properties are passed', () {
      expect(LoginState('', '', OnPage.inputEmail).copyWith(), LoginState('', '', OnPage.inputEmail));
    });

    test('returns object with updated onPage when onPage is passed', () {
      expect(
        LoginState('', '', OnPage.inputEmail).copyWith(onPage: onInputPasswordPage),
        LoginState('', '', onInputPasswordPage),
      );
    });

    test('returns object with updated email when email is passed', () {
      expect(
        LoginState('', '', OnPage.inputEmail).copyWith(email: email),
        LoginState(email, '', OnPage.inputEmail),
      );
    });

    test('returns object with updated password when password is passed', () {
      expect(
        LoginState('', '', OnPage.inputEmail).copyWith(password: password),
        LoginState('', password, OnPage.inputEmail),
      );
    });
  });
}
