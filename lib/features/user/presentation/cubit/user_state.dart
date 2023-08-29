part of 'user_cubit.dart';

sealed class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserError extends UserState {
  final String error;

  UserError(this.error);
}

class UserLoading extends UserState {}

sealed class UserWithData extends UserState {
  final User user;

  UserWithData({required this.user});
}

class UserInitiallyLoaded extends UserLoaded {
  UserInitiallyLoaded(UserWithData u) : super(user: u.user);
}

class UserUpdating extends UserWithData {
  UserUpdating({required super.user});
}

class UserUpdated extends UserWithData {
  UserUpdated({required super.user});
}

class UserLoaded extends UserWithData {
  UserLoaded({required super.user});

  UserLoaded copyWith({
    User? user,
  }) {
    return UserLoaded(
      user: user ?? this.user,
    );
  }
}
