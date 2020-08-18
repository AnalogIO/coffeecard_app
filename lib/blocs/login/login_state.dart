part of 'login_bloc.dart';

class LoginState extends Equatable {
  final String password;
  final String email;
  final String error;
  final OnPage onPage;

  const LoginState({this.email = "", this.password = "", this.onPage = OnPage.inputEmail, this.error = ""});


  LoginState copyWith({
    OnPage onPage,
    String email,
    String password,
    String error,
  }) {
    return LoginState(
      onPage: onPage ?? this.onPage,
      email: email ?? this.email,
      password: password ?? this.password,
      error: error ?? this.error
    );
  }

  @override
  List<Object> get props => [password, email, error, onPage];

  @override
  String toString() {
    return 'LoginState{password: $password, email: $email, error: $error, onPage: $onPage}';
  }
}

enum OnPage {
  inputEmail,
  inputPassword,
}