part of 'authentication_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends AuthEvent {}

class Authenticated extends AuthEvent {
  final UserAuth userAuth;
  const Authenticated(this.userAuth);

  @override
  List<Object> get props => [userAuth];
}

class Unauthenticated extends AuthEvent {}
