part of 'login_bloc.dart';

class LoginState extends Equatable {
  final String password;
  final String email;
  final OnPage onPage;

  const LoginState(this.email, this.password, this.onPage);

  LoginState copyWith({
    String email,
    String password,
    OnPage onPage
  }) {
    return LoginState(
        email ?? this.email,
        password ?? this.password,
        onPage ?? this.onPage
    );
  }
  
  LoginStateError copyToErrorState({String email, String password, String error,}){
    return LoginStateError(email ?? this.email, password ?? this.password, onPage, error);
  }

  @override
  List<Object> get props => [password, email, onPage];

  @override
  String toString() {
    return 'LoginState{password: $password, email: $email, onPage: $onPage}';
  }
}

class LoginStateLoading extends LoginState {
  const LoginStateLoading(String email, String password, OnPage onPage) : super(email, password, onPage);
}

class LoginStateError extends LoginState {
  final String error;
  
  const LoginStateError(String email, String password, OnPage onPage, this.error ) : super(email, password, onPage);

  @override
  List<Object> get props => [error, password, email, onPage];

  @override
  String toString() {
    return 'LoginStateError{error: $error, email: $email, password: $password, onPage: $onPage}';
  }
}

enum OnPage {
  inputEmail,
  inputPassword,
}
