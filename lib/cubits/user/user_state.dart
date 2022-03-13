part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserError extends UserState {
  final String error;

  UserError(this.error);
}

class UserLoading extends UserState {}

class UserUpdating extends UserState {}

class UserLoaded extends UserState {
  final User user;

  UserLoaded(this.user);
}
