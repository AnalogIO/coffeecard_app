part of 'environment_cubit.dart';

abstract class EnvironmentState {}

class EnvironmentInitial extends EnvironmentState {}

class EnvironmentLoaded extends EnvironmentState {
  EnvironmentLoaded({required this.env});
  final Environment env;
}

class EnvironmentError extends EnvironmentState {}
