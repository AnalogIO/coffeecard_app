import 'package:bloc/bloc.dart';
import 'package:coffeecard/features/biometric/domain/usecases/clear_biometrics.dart';
import 'package:coffeecard/features/biometric/domain/usecases/get_registered_user.dart';
import 'package:coffeecard/features/biometric/domain/usecases/register_biometrics.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

part 'biometrics_state.dart';

class BiometricsCubit extends Cubit<BiometricsState> {
  final RegisterBiometric registerBiometric;
  final GetRegisteredUser getRegisteredUser;
  final ClearBiometrics clearBiometrics;

  BiometricsCubit({
    required this.registerBiometric,
    required this.getRegisteredUser,
    required this.clearBiometrics,
  }) : super(const BiometricsLoading());

  Future<void> loadBiometrics() async {
    final registeredUser = await getRegisteredUser();

    final enabledBiometrics = registeredUser != none();

    emit(BiometricsLoaded(hasEnabledBiometrics: enabledBiometrics));
  }

  Future<void> register() async {
    emit(const BiometricsLoading());

    final result = await registerBiometric();

    result.fold(
      (error) => null, //TODO: handle error
      (_) => emit(const BiometricsLoaded(hasEnabledBiometrics: true)),
    );
  }

  Future<void> clear() async {
    await clearBiometrics();

    emit(const BiometricsLoaded(hasEnabledBiometrics: false));
  }
}
