part of 'biometric_cubit.dart';

sealed class BiometricState extends Equatable {
  const BiometricState();

  @override
  List<Object> get props => [];
}

final class BiometricLoaded extends BiometricState {
  final bool hasEnabledBiometrics;

  const BiometricLoaded({required this.hasEnabledBiometrics});

  @override
  List<Object> get props => [hasEnabledBiometrics];
}

final class BiometricLoading extends BiometricState {
  const BiometricLoading();
}
