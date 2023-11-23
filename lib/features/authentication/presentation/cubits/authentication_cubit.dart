import 'package:coffeecard/core/external/date_service.dart';
import 'package:coffeecard/features/authentication/domain/entities/authenticated_user.dart';
import 'package:coffeecard/features/authentication/domain/usecases/clear_authenticated_user.dart';
import 'package:coffeecard/features/authentication/domain/usecases/get_authenticated_user.dart';
import 'package:coffeecard/features/authentication/domain/usecases/save_authenticated_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

part 'authentication_state.dart';

// We might consider changing this back to a bloc if we want different events to
// trigger a logout (for instance, when the user requests logs out themselves
// vs the user's token expires and fails to renew).
class AuthenticationCubit extends Cubit<AuthenticationState> {
  final ClearAuthenticatedUser clearAuthenticatedUser;
  final SaveAuthenticatedUser saveAuthenticatedUser;
  final GetAuthenticatedUser getAuthenticatedUser;
  final DateService dateService;

  AuthenticationCubit({
    required this.clearAuthenticatedUser,
    required this.saveAuthenticatedUser,
    required this.getAuthenticatedUser,
    required this.dateService,
  }) : super(const AuthenticationState._());

  Future<void> appStarted() async {
    final authenticatedUser = await getAuthenticatedUser();

    authenticatedUser.match(
      () => emit(const AuthenticationState.unauthenticated()),
      (authenticatedUser) {
        final sessionExpired = _isSessionExpired(
          authenticatedUser.lastLogin,
          authenticatedUser.sessionTimeout,
        );

        if (sessionExpired) {
          emit(AuthenticationState.reauthenticated(authenticatedUser));
          return;
        }

        emit(AuthenticationState.authenticated(authenticatedUser));
      },
    );
  }

  bool _isSessionExpired(
    Option<DateTime> lastLogin,
    Option<Duration> sessionTimeout,
  ) {
    return lastLogin.match(
      () => false,
      (lastLogin) => sessionTimeout.match(
        () => false,
        (sessionTimeout) {
          final now = dateService.currentDateTime;
          final difference = now.difference(lastLogin);
          return difference > sessionTimeout;
        },
      ),
    );
  }

  Future<void> authenticated(
    String email,
    String encodedPasscode,
    String token,
  ) async {
    final now = dateService.currentDateTime;

    await saveAuthenticatedUser(
      email: email,
      token: token,
      encodedPasscode: encodedPasscode,
      lastLogin: some(now),
      sessionTimeout: none(),
    );

    emit(
      AuthenticationState.authenticated(
        AuthenticatedUser(
          token: token,
          email: email,
          encodedPasscode: encodedPasscode,
          lastLogin: some(now),
          sessionTimeout: none(),
        ),
      ),
    );
  }

  Future<void> unauthenticated() async {
    await clearAuthenticatedUser();
    emit(const AuthenticationState.unauthenticated());
  }

  Future<void> saveSessionTimeout(Duration? duration) async {
    final user = await getAuthenticatedUser();

    user.match(
      () => null,
      (user) async {
        await saveAuthenticatedUser(
          email: user.email,
          token: user.token,
          encodedPasscode: user.encodedPasscode,
          lastLogin: user.lastLogin,
          sessionTimeout: optionOf(duration),
        );
      },
    );
  }
}
