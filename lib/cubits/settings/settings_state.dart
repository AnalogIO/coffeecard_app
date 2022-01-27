part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  final User? user;

  const SettingsState({
    this.user,
  });

  SettingsState copyWith({required User user}) {
    return SettingsState(user: user);
  }

  bool get isLoaded => user != null;
  bool get isLoading => user == null;

  @override
  String toString() => 'SettingsState(user: $user)';

  @override
  List<Object?> get props => [user];
}
