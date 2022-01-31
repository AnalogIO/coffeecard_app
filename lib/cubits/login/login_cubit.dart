import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/data/repositories/v1/account_repository.dart';
import 'package:coffeecard/models/api/unauthorized_error.dart';
import 'package:coffeecard/utils/email_utils.dart';
import 'package:coffeecard/utils/http_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationCubit authenticationCubit;
  final AccountRepository accountRepository;

  LoginCubit({
    required this.authenticationCubit,
    required this.accountRepository,
  }) : super(const LoginState());

  void updateEmail(String email) {
    emit(state.copyWith(email: email, emailValidated: false));
  }

  void validateEmail() {
    final email = state.email.trim();
    if (email.isEmpty) {
      emit(state.copyWith(error: 'Please enter an email'));
    } else if (!emailIsValid(email)) {
      emit(state.copyWith(error: 'Please enter a valid email'));
    } else {
      emit(state.copyWith(emailValidated: true));
    }
  }

  void addPasscodeInput(String input) {
    final String newPasscode = state.passcode + input;
    final bool fullPasscode = newPasscode.length == 4;
    emit(state.copyWith(passcode: newPasscode, loading: fullPasscode));
    if (fullPasscode) {
      loginRequested();
    }
  }

  void clearPasscode() {
    emit(state.copyWith(passcode: ''));
  }

  void clearError() {
    emit(state.copyWith());
  }

  void loginAsAnotherUser() {
    updateEmail('');
    clearPasscode();
    // Log out; Remove any saved data from a previous login.
    authenticationCubit.unauthenticated();
  }

  Future<void> loginRequested() async {
    try {
      final authenticatedUser =
          await accountRepository.login(state.email, state.passcode);
      authenticationCubit.authenticated(
        authenticatedUser.email,
        authenticatedUser.token,
      );
    } on UnauthorizedError catch (error) {
      emit(state.copyWith(passcode: '', error: formatErrorMessage(error.message)));
    }
  }
}
