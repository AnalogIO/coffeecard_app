part of 'login_cubit.dart';

enum LoginRoute { email, passcode, biometric }

class LoginState extends Equatable {
  final String email;
  final bool emailValidated;
  final String passcode;
  final bool loading;
  final String? error;

  const LoginState({
    this.email = '',
    this.emailValidated = false,
    this.passcode = '',
    this.loading = false,
    this.error,
  });

  bool get hasError => error != null;

  LoginState copyWith({
    String? email,
    bool? emailValidated,
    String? passcode,
    bool? loading,
    String? error,
  }) {
    return LoginState(
      email: email ?? this.email,
      emailValidated: emailValidated ?? this.emailValidated,
      passcode: passcode ?? this.passcode,
      loading: loading ?? false,
      error: error,
    );
  }

  @override
  List<Object> get props => [
        error ?? false,
        loading,
        passcode,
        emailValidated,
        email,
      ];

  @override
  String toString() =>
      'email: $email, passcode: $passcode, error: ${error ?? 'none'}';
}
