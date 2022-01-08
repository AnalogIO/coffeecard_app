part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class UserLoading extends SettingsState {}

class UserLoaded extends SettingsState {
  final User user;

  const UserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class UserChanged extends SettingsState {
  final User user;

  const UserChanged(this.user);

  @override
  List<Object?> get props => [user];
}

class InvalidEmail extends SettingsState {
  final String error;

  const InvalidEmail(this.error);

  @override
  List<Object?> get props => [error];
}

class InvalidName extends SettingsState {
  final String error;

  const InvalidName(this.error);

  @override
  List<Object?> get props => [error];
}
