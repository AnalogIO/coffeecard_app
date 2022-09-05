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
  final List<ProgrammeDto> programmes;

  UserWithData({required this.user, required this.programmes});
}

class UserUpdating extends UserWithData {
  UserUpdating({required super.user, required super.programmes});
}

class UserUpdated extends UserWithData {
  UserUpdated({required super.user, required super.programmes});
}

class UserLoaded extends UserWithData {
  UserLoaded({required super.user, required super.programmes});

  UserLoaded copyWith({
    User? user,
    List<ProgrammeDto>? programmes,
  }) {
    return UserLoaded(
      user: user ?? this.user,
      programmes: programmes ?? this.programmes,
    );
  }
}
