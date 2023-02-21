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
  final Occupation occupation;

  UserWithData({
    required this.user,
    required this.occupation,
  });
}

class UserUpdating extends UserWithData {
  UserUpdating({
    required super.user,
    required super.occupation,
  });
}

class UserUpdated extends UserWithData {
  UserUpdated({
    required super.user,
    required super.occupation,
  });
}

class UserLoaded extends UserWithData {
  UserLoaded({
    required super.user,
    required super.occupation,
  });

  UserLoaded copyWith({
    User? user,
    Occupation? occupation,
  }) {
    return UserLoaded(
      user: user ?? this.user,
      occupation: occupation ?? this.occupation,
    );
  }
}
