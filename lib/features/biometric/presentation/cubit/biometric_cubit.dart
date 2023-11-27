import 'package:bloc/bloc.dart';
import 'package:coffeecard/features/biometric/domain/usecases/register_biometrics.dart';
import 'package:equatable/equatable.dart';

part 'biometric_state.dart';

class BiometricCubit extends Cubit<BiometricState> {
  final RegisterBiometric registerBiometric;

  BiometricCubit({required this.registerBiometric}) : super(BiometricInitial());

  Future<void> register(String email) async {
    await registerBiometric(email);
  }
}
