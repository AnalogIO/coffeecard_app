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

abstract class UserWithData extends UserState {
  final User user;
  final List<Occupation> occupations;

  UserWithData({required this.user, required this.occupations});
}

class UserInitiallyLoaded extends UserWithData {
  UserInitiallyLoaded(UserWithData u)
      : super(user: u.user, occupations: u.occupations);
}

class UserUpdating extends UserWithData {
  UserUpdating({required super.user, required super.occupations});
}

class UserUpdated extends UserWithData {
  UserUpdated({required super.user, required super.occupations});
}

class UserLoaded extends UserWithData {
  UserLoaded({required super.user, required super.occupations});

  UserLoaded copyWith({
    User? user,
    List<Occupation>? occupations,
  }) {
    return UserLoaded(
      user: user ?? this.user,
      occupations: occupations ?? this.occupations,
    );
  }
}
