import 'package:coffeecard/data/repositories/v1/account_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.models.swagger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  AccountRepository repository;

  RegisterCubit({required this.repository}) : super(const RegisterState());

  void setEmail(String email) => emit(state.copyWith(email: email));
  void setPasscode(String passcode) => emit(state.copyWith(passcode: passcode));
  void setName(String name) => emit(state.copyWith(name: name));

  Future<void> register() async {
    final registerDto = RegisterDto(
      name: state.name,
      email: state.email,
      password: state.passcode,
    );
    await repository.register(registerDto);
  }
}
