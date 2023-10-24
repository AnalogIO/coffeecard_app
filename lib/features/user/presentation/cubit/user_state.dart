part of 'user_cubit.dart';

sealed class UserState extends Equatable {}

class UserError extends UserState {
  final String error;

  UserError(this.error);

  @override
  List<Object?> get props => [error];
}

class UserLoading extends UserState {
  @override
  List<Object?> get props => [];
}

sealed class UserWithData extends UserState {
  final User user;

  UserWithData({required this.user});

  @override
  List<Object?> get props => [user];
}

class UserUpdating extends UserWithData {
  UserUpdating({required super.user});
}

class UserUpdated extends UserWithData {
  UserUpdated({required super.user});
}

class UserLoaded extends UserWithData {
  UserLoaded({required super.user});
}

class UserInitiallyLoaded extends UserLoaded {
  UserInitiallyLoaded({required super.user});
}
