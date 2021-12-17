part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final String? email;
  final String? passcode;
  final String? name;

  final String? emailError;
  final bool loading;

  const RegisterState({
    this.email,
    this.passcode,
    this.name,
    this.emailError,
    this.loading = false,
  });

  RegisterState copyWith({
    String? email,
    String? passcode,
    String? name,
    String? emailError,
    bool? loading,
  }) {
    return RegisterState(
      email: email ?? this.email,
      passcode: passcode ?? this.passcode,
      name: name ?? this.name,
      emailError: emailError,
      loading: loading ?? false,
    );
  }

  @override
  List<Object> get props => [loading, emailError ?? false];
}
