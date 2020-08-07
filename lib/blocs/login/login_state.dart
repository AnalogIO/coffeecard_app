part of 'login_bloc.dart';

class LoginState extends Equatable {
  final String password;
  final String username;
  final String error;
  final OnPage onPage;

  const LoginState({this.username, this.password, this.onPage, this.error});
  String get currentPasswordInput => password;
  String get usernameInput => username;

  LoginState copyWith({
    OnPage onPage,
    String username,
    String password,
    String error,
  }) {
    return LoginState(
      onPage: onPage ?? this.onPage,
      username: username ?? this.username,
      password: password ?? this.password,
      error: error ?? this.error
    );
  }

  @override
  List<Object> get props => [password, username, error, onPage];
}

enum OnPage {
  inputEmail,
  inputPassword,
}