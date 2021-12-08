import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(const RegisterState()) {
    on<VerifyForm>((event, emit) {
      final email = state.email.trim();
      final passcode = state.passcode;
      String? emailError;
      String? passcodeError;

      if (email.isEmpty) {
        emailError = 'Enter an email';
      } else if (!_isValidEmail(email)) {
        emailError = 'Enter a valid email';
      }
      if (passcode.length > 4) {
        passcodeError = 'Passcode must be four digits';
      } else if (passcode != event.repeatPasscodeValue) {
        passcodeError = 'The passcodes do not match';
      }

      emit(
        state.withError(emailError: emailError, passcodeError: passcodeError),
      );
    });
  }

  // FIXME code duplication
  bool _isValidEmail(String email) =>
      RegExp(r'^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+').hasMatch(email);
}
