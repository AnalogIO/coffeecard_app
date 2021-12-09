import 'package:coffeecard/model/account/register_user.dart';
import 'package:coffeecard/persistence/repositories/account_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_event.dart';
// part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, String?> {
  final AccountRepository repository;

  RegisterBloc({required this.repository}) : super(null) {
    on<AttemptRegister>((event, emit) async {
      final register = RegisterUser('name', event.email, event.passcode);
      try {
        await repository.register(register);
      } on UnauthorizedError catch (error) {
        emit(error.message);
      }
    });
    // on<VerifyPasscode>((event, emit) {});
  }
}
