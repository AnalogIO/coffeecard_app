part of 'login_bloc.dart';

enum LoginRoute { email, passcode, biometric }

class LoginState extends Equatable {
  final String email;
  final String passcode;
  final String? error;
  final bool loading;
  final LoginRoute route;
  final bool loginSuccess;

  const LoginState({
    this.email = '',
    this.passcode = '',
    this.error,
    this.loading = false,
    this.route = LoginRoute.email,
    this.loginSuccess = false,
  });

  bool get hasError => error != null;

  LoginState copyWith({
    String? email,
    String? passcode,
    String? error,
    bool loading = false,
    LoginRoute? route,
    bool? loginSuccess,
  }) {
    return LoginState(
      email: email ?? this.email,
      passcode: passcode ?? this.passcode,
      error: error,
      loading: loading,
      route: route ?? this.route,
      loginSuccess: loginSuccess ?? this.loginSuccess,
    );
  }

  @override
  List<Object> get props => [route, loading, error ?? false, passcode, email];

  @override
  String toString() =>
      'route: $route, loading: $loading, error: ${error ?? false}, passcode: $passcode, email: $email';
}
