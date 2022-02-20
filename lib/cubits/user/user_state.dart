part of 'user_cubit.dart';

class UserState extends Equatable {
  final User? user;
  bool get isLoaded => user != null;
  bool get isLoading => user == null;

  const UserState({
    this.user,
  });

  @override
  List<Object?> get props => [user];

  UserState copyWith({
    bool? isFetchingUser,
    User? user,
  }) {
    return UserState(
      user: user ?? this.user,
    );
  }
}
