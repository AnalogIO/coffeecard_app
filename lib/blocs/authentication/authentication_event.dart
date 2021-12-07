part of 'authentication_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class Authenticated extends AuthEvent {
  final AuthenticatedUser authenticatedUser;
  const Authenticated(this.authenticatedUser);

  @override
  List<Object> get props => [authenticatedUser];
}

class Unauthenticated extends AuthEvent {}
