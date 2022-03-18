part of 'environment_cubit.dart';

abstract class EnvironmentState {}

class EnvironmentInitial extends EnvironmentState {}

class EnvironmentLoaded extends EnvironmentState {
  EnvironmentLoaded({required this.isTestEnvironment});

  final bool isTestEnvironment;
}

class EnvironmentError extends EnvironmentState {}
