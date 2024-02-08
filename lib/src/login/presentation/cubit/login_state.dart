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

class LoginEmailNotVerified extends LoginError {
  const LoginEmailNotVerified(super.errorMessage);
}

class LoginError extends LoginState {
  final String errorMessage;

  const LoginError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
