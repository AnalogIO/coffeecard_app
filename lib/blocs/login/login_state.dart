part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  final String password;
  final String username;
  final OnPage onPage;

  const LoginState(this.username, this.password, this.onPage);
  @override
  List<Object> get props => [password];

  String get currentPasswordInput => password;
  String get usernameInput => username;
}

class LoginInitial extends LoginState {
  const LoginInitial() : super("", "", OnPage.inputEmail);
}

class LoginInProgress extends LoginState {
  const LoginInProgress(String username, String password) : super(username, password, OnPage.inputPassword);
}

class LoginPasswordBeingFilled extends LoginState {
  const LoginPasswordBeingFilled(String username, String password) : super(username, password, OnPage.inputPassword);
}

class LoginFailure extends LoginState {
  final String error;

  const LoginFailure(String username, OnPage onPage, {this.error}) : super(username, "", onPage);

  @override
  List<Object> get props => [error];

  @override
  String toString() => 'LoginFailure { error: $error }';
}

class LoginSuccess extends LoginState {
  const LoginSuccess() : super("", "", OnPage.inputEmail);
}

enum OnPage {
  inputEmail,
  inputPassword,
}