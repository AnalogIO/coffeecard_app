part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  const UserState();
}

class UserError extends UserState {
  final String error;

  const UserError(this.error);

  @override
  List<Object?> get props => [error];
}

class UserLoading extends UserState {
  const UserLoading();

  @override
  List<Object?> get props => [];
}

sealed class UserWithData extends UserState {
  final User user;

  const UserWithData(this.user);

  @override
  List<Object?> get props => [user];
}

class UserUpdating extends UserWithData {
  const UserUpdating(super.user);
}

class UserLoaded extends UserWithData {
  const UserLoaded(super.user);
}

class UserInitiallyLoaded extends UserLoaded {
  const UserInitiallyLoaded(super.user);
}
