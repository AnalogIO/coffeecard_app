import 'package:bloc/bloc.dart';
import 'package:coffeecard/features/biometric/domain/usecases/get_registered_user.dart';
import 'package:coffeecard/features/biometric/domain/usecases/register_biometrics.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

part 'biometric_state.dart';

class BiometricCubit extends Cubit<BiometricState> {
  final RegisterBiometric registerBiometric;
  final GetRegisteredUser getRegisteredUser;

  BiometricCubit({
    required this.registerBiometric,
    required this.getRegisteredUser,
  }) : super(const BiometricLoading());

  Future<void> loadUser() async {
    final registeredUser = await getRegisteredUser();

    final enabledBiometrics = registeredUser != none();

    emit(BiometricLoaded(hasEnabledBiometrics: enabledBiometrics));
  }

  Future<void> register() async {
    await registerBiometric();
  }
}
