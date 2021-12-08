part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final String email;
  final String passcode;
  final String? emailError;
  final String? passcodeError;

  const RegisterState({
    this.email = '',
    this.passcode = '',
    this.emailError,
    this.passcodeError,
  });

  RegisterState copyWith({String? email, String? passcode}) {
    return RegisterState(
      email: email ?? this.email,
      passcode: passcode ?? this.passcode,
    );
  }

  RegisterState withError({String? emailError, String? passcodeError}) {
    return RegisterState(
      email: email,
      passcode: passcode,
      emailError: emailError,
      passcodeError: passcodeError,
    );
  }

  @override
  List<Object> get props => [];
}
