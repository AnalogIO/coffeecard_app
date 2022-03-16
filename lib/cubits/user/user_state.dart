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

class UserUpdating extends UserLoaded {
  UserUpdating({required User user, required List<ProgrammeDto> programmes})
      : super(user: user, programmes: programmes);
}

class UserLoaded extends UserState {
  final User user;
  final List<ProgrammeDto> programmes;

  UserLoaded({required this.user, required this.programmes});

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
