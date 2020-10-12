part of 'login_bloc.dart';

class LoginState extends Equatable {
  final String password;
  final String email;
  final OnPage onPage;
  final bool isLoading;

  const LoginState({this.email = "", this.password = "", this.onPage = OnPage.inputEmail, this.isLoading = false});

  LoginState copyWith({
    OnPage onPage,
    String email,
    String password,
    String error,
    bool isLoading,
  }) {
    return LoginState(
        onPage: onPage ?? this.onPage,
        email: email ?? this.email,
        password: password ?? this.password,
        isLoading: isLoading ?? this.isLoading);
  }

  @override
  List<Object> get props => [password, email, onPage, isLoading];

  @override
  String toString() {
    return 'LoginState{password: $password, email: $email, onPage: $onPage, isLoading: $isLoading}';
  }
}

enum OnPage {
  inputEmail,
  inputPassword,
}
