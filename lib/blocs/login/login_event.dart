part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String email;

  const LoginEmailChanged(this.email);

  String get typedEmail => email;

  @override
  List<Object> get props => [email];

  @override
  String toString() =>
      'LoginEmailEntered { email: $email }';
}

class LoginNumpadPressed extends LoginEvent {
  final NumpadAction numpadAction;

  const LoginNumpadPressed(this.numpadAction);
  
  @override
  List<Object> get props => [numpadAction];

  @override
  String toString() =>
      'NumpadPressed { keyPress: $numpadAction }';
}

class LoginEmailSubmitted extends LoginEvent {
  const LoginEmailSubmitted();
}

class LoginGoBack extends LoginEvent {
  const LoginGoBack();
}