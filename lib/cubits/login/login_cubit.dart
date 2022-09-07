import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/encode_passcode.dart';
import 'package:coffeecard/utils/firebase_analytics_event_logging.dart';
import 'package:coffeecard/utils/http_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required this.email,
    required this.authenticationCubit,
    required this.accountRepository,
  }) : super(const LoginTypingPasscode(''));

  final String email;
  final AuthenticationCubit authenticationCubit;
  final AccountRepository accountRepository;

  void addPasscodeInput(String input) {
    // used for type promotion
    final st = state;

    final String newPasscode;
    if (st is LoginTypingPasscode) {
      newPasscode = st.passcode + input;
    } else {
      newPasscode = input;
    }

    emit(LoginTypingPasscode(newPasscode));

    if (newPasscode.length == 4) _loginRequested();
  }

  void clearPasscode() {
    emit(const LoginTypingPasscode(''));
  }

  Future<void> _loginRequested() async {
    final passcode = (state as LoginTypingPasscode).passcode;
    final encodedPasscode = encodePasscode(passcode);

    emit(const LoginLoading());

    final either = await accountRepository.login(email, encodedPasscode);

    either.fold(
      (error) => emit(LoginError(formatErrorMessage(error.message))),
      (user) {
        sl<FirebaseAnalyticsEventLogging>().loginEvent();

        authenticationCubit.authenticated(
          user.email,
          encodedPasscode,
          user.token,
        );
      },
    );
  }
}
