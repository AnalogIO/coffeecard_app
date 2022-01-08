part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class ChangeEmail extends SettingsEvent {
  final String email;

  const ChangeEmail(this.email);

  @override
  List<Object> get props => [email];
}

class ChangeName extends SettingsEvent {
  final String name;

  const ChangeName(this.name);

  @override
  List<Object> get props => [name];
}

class LoadUser extends SettingsEvent {}
