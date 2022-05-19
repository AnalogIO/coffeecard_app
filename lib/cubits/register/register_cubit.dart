import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  AccountRepository repository;

  RegisterCubit({required this.repository}) : super(const RegisterState());

  void setEmail(String email) => emit(state.copyWith(email: email.trim()));
  void setPasscode(String passcode) => emit(state.copyWith(passcode: passcode));
  void setName(String name) => emit(state.copyWith(name: name));

  Future<void> register() async {
    final either =
        await repository.register(state.name!, state.email!, state.passcode!);

    // TODO: Handle error by emitting new state instead of throwing?
    if (either.isLeft) {
      throw Exception(either.left.message);
    }
  }
}
