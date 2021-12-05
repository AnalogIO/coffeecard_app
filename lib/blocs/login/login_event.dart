part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

// TODO Could write email input/clear logic in the Numpad widget.
class UpdateEmail extends LoginEvent {
  final String email;
  const UpdateEmail(this.email);

  @override
  List<Object> get props => [email];
}

class ValidateEmail extends LoginEvent {
  const ValidateEmail();
}

// TODO Could write passcode input/clear logic in the Numpad widget.
class PasscodeInput extends LoginEvent {
  final String input;
  const PasscodeInput(this.input);

  @override
  List<Object> get props => [input];
}

class ClearPasscode extends LoginEvent {
  const ClearPasscode();
}

class ClearError extends LoginEvent {
  const ClearError();
}

class LoginAsAnotherUser extends LoginEvent {
  const LoginAsAnotherUser();
}

class LoginRequested extends LoginEvent {
  const LoginRequested();
}
