part of 'upgrader_cubit.dart';

sealed class UpgraderState extends Equatable {
  const UpgraderState();

  @override
  List<Object> get props => [];
}

final class UpgraderLoading extends UpgraderState {}

final class UpgraderLoaded extends UpgraderState {
  final bool canUpgrade;

  const UpgraderLoaded({required this.canUpgrade});

  @override
  List<Object> get props => [canUpgrade];
}
