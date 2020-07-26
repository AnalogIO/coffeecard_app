part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginEmailEntered extends LoginEvent {
  final String email;

  const LoginEmailEntered(this.email);

  String get typedEmail => email;

  @override
  List<Object> get props => [email];

  @override
  String toString() =>
      'LoginEmailEntered { email: $email }';
}

class LoginNumpadPressed extends LoginEvent {
  final String keyPress;

  const LoginNumpadPressed({
    this.keyPress,
  });

  String get pressedKey => keyPress;

  @override
  List<Object> get props => [keyPress];

  @override
  String toString() =>
      'NumpadPressed { keyPress: $keyPress }';
}