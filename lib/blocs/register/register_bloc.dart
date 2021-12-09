import 'package:coffeecard/model/account/register_user.dart';
import 'package:coffeecard/persistence/repositories/account_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AccountRepository repository;

  RegisterBloc({required this.repository}) : super(const RegisterState()) {
    on<ClearEmailError>((event, emit) async {
      emit(state.copyWith());
    });
    on<AttemptRegister>((event, emit) async {
      emit(state.copyWith(loading: true));
      final register = RegisterUser(event.name, event.email, event.passcode);
      try {
        await repository.register(register);
        // Do something on successful registration
        emit(state.copyWith(loading: false));
      } on UnauthorizedError catch (error) {
        emit(state.copyWith(emailError: error.message));
      }
    });
  }
}
