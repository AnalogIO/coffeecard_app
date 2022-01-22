import 'package:coffeecard/data/repositories/account_repository.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.models.swagger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  AccountRepository repository;

  RegisterCubit({required this.repository}) : super(const RegisterState());

  void addEmail(String email) => emit(state.copyWith(email: email));
  void addPasscode(String passcode) => emit(state.copyWith(passcode: passcode));
  void addName(String name) => emit(state.copyWith(name: name));

  void removeEmail() => emit(const RegisterState());
  void removePasscode() => emit(RegisterState(email: state.email));
  void removeName() => emit(
        RegisterState(
          email: state.email,
          passcode: state.passcode,
        ),
      );

  Future<void> acceptTerms() async {
    final registerDto = RegisterDto(
      name: state.name,
      email: state.email,
      password: state.passcode,
    );
    await repository.register(registerDto);
  }
}
