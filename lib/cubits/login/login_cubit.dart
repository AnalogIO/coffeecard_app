import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/service_locator.dart';
import 'package:coffeecard/utils/encode_passcode.dart';
import 'package:coffeecard/utils/http_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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
    // _state is used for type promotion
    final _state = state;

    final String newPasscode;
    if (_state is LoginTypingPasscode) {
      newPasscode = _state.passcode + input;
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
    // _state is used for type promotion
    final _state = state;

    if (_state is! LoginTypingPasscode) {
      throw Exception(
        '_loginRequested called while state type is not LoginTypingPasscode',
      );
    }

    emit(LoginLoading());

    final encodedPasscode = encodePasscode(_state.passcode);
    final either = await accountRepository.login(email, encodedPasscode);
    sl<FirebaseAnalytics>().logLogin(loginMethod: 'UsernamePassword');

    if (either.isRight) {
      final authenticatedUser = either.right;

      authenticationCubit.authenticated(
        authenticatedUser.email,
        encodedPasscode,
        authenticatedUser.token,
      );
    } else {
      emit(LoginError(formatErrorMessage(either.left.message)));
    }
  }
}
