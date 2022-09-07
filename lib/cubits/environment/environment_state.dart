part of 'environment_cubit.dart';

abstract class EnvironmentState extends Equatable {
  const EnvironmentState();
}

class EnvironmentInitial extends EnvironmentState {
  const EnvironmentInitial();

  @override
  List<Object?> get props => [];
}

class EnvironmentLoaded extends EnvironmentState {
  const EnvironmentLoaded({required this.env});
  final Environment env;

  @override
  List<Object?> get props => [env];
}

class EnvironmentError extends EnvironmentState {
  const EnvironmentError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
