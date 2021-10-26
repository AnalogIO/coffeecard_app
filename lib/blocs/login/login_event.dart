part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

// Email events

class LoginEmailSubmit extends LoginEvent {
  const LoginEmailSubmit();
}

class LoginEmailChange extends LoginEvent {
  final String email;

  const LoginEmailChange(this.email);

  @override
  List<Object> get props => [email];
}

// Passcode events

class LoginPasscodeSubmit extends LoginEvent {}

class LoginPasscodeInput extends LoginEvent {
  final String input;

  const LoginPasscodeInput(this.input);

  // TODO test if this prevents the input "22.."
  @override
  List<Object> get props => [input];
}

class LoginAsAnotherUser extends LoginEvent {
  /// Request to clear state and navigate to mail page.
  /// Should have same behavior as logging out.
  const LoginAsAnotherUser();
}

class LoginClearPasscode extends LoginEvent {
  const LoginClearPasscode();
}

// TODO Maybe add a "changeTo" field.
class LoginChangeAuthentication extends LoginEvent {
  /// A change between passcode and biometric authentication.
  const LoginChangeAuthentication();
}

class LoginForgotPasscode extends LoginEvent {
  const LoginForgotPasscode();
}
