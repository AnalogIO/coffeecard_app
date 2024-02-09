part of 'environment_cubit.dart';

sealed class EnvironmentState extends Equatable {
  const EnvironmentState();

  /// Whether the app is running in a testing environment.
  bool get isTestingEnvironment {
    return switch (this) {
      EnvironmentLoaded(env: Environment.testing) => true,
      _ => false,
    };
  }
}

class EnvironmentLoading extends EnvironmentState {
  const EnvironmentLoading();

  @override
  List<Object?> get props => [];
}

class EnvironmentLoaded extends EnvironmentState {
  const EnvironmentLoaded(this.env);
  final Environment env;

  @override
  List<Object?> get props => [env];
}

class EnvironmentLoadError extends EnvironmentState {
  const EnvironmentLoadError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
