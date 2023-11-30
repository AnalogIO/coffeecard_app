part of 'biometrics_cubit.dart';

sealed class BiometricsState extends Equatable {
  const BiometricsState();

  @override
  List<Object> get props => [];
}

final class BiometricsLoaded extends BiometricsState {
  final bool hasEnabledBiometrics;

  const BiometricsLoaded({required this.hasEnabledBiometrics});

  @override
  List<Object> get props => [hasEnabledBiometrics];
}

final class BiometricsLoading extends BiometricsState {
  const BiometricsLoading();
}
