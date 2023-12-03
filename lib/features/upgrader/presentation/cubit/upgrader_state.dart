part of 'upgrader_cubit.dart';

sealed class UpgraderState extends Equatable {
  const UpgraderState();

  @override
  List<Object> get props => [];
}

final class UpgraderLoading extends UpgraderState {}

final class UpgraderLoaded extends UpgraderState {
  final String version;

  const UpgraderLoaded({required this.version});

  @override
  List<Object> get props => [version];
}

final class UpgraderError extends UpgraderState {
  final String error;

  const UpgraderError({required this.error});

  @override
  List<Object> get props => [error];
}
