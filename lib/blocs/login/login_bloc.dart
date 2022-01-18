import 'package:coffeecard/blocs/authentication/authentication_bloc.dart';
import 'package:coffeecard/data/repositories/v1/account_repository.dart';
import 'package:coffeecard/models/account/unauthorized_error.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthBloc authBloc;
  final AccountRepository repository;

  LoginBloc({
    required this.authBloc,
    required this.repository,
  }) : super(const LoginState()) {
    on<UpdateEmail>((event, emit) {
      emit(state.copyWith(email: event.email, emailValidated: false));
    });

    on<ValidateEmail>((event, emit) {
      final email = state.email.trim();
      if (email.isEmpty) {
        emit(state.copyWith(error: 'Please enter an email'));
      } else if (!_isValidEmail(email)) {
        emit(state.copyWith(error: 'Please enter a valid email'));
      } else {
        emit(state.copyWith(emailValidated: true));
      }
    });

    on<PasscodeInput>((event, emit) {
      final String newPasscode = state.passcode + event.input;
      final bool fullPasscode = newPasscode.length == 4;
      emit(state.copyWith(passcode: newPasscode, loading: fullPasscode));
      if (fullPasscode) add(const LoginRequested());
    });

    on<ClearPasscode>((event, emit) => emit(state.copyWith(passcode: '')));

    on<ClearError>((event, emit) => emit(state.copyWith()));

    on<LoginAsAnotherUser>((event, emit) {
      add(const UpdateEmail(''));
      add(const ClearPasscode());
      // Log out; Remove any saved data from a previous login.
      authBloc.add(Unauthenticated());
    });

    on<LoginRequested>((event, emit) async {
      try {
        final authenticatedUser =
            await repository.login(state.email, state.passcode);
        authBloc.add(Authenticated(authenticatedUser));
      } on UnauthorizedError catch (error) {
        emit(state.copyWith(passcode: '', error: error.message));
      }
    });
  }

  bool _isValidEmail(String email) =>
      RegExp(r'^[^@ \t\r\n]+@[^@ \t\r\n]+\.[^@ \t\r\n]+').hasMatch(email);
}
