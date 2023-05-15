part of 'login_cubit.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginTypingPasscode extends LoginState {
  const LoginTypingPasscode(this.passcode);
  final String passcode;

  @override
  List<Object?> get props => [passcode];
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginError extends LoginState {
  const LoginError(this.errorMessage);
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
