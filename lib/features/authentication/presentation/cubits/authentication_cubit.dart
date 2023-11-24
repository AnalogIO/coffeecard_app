import 'package:coffeecard/core/external/date_service.dart';
import 'package:coffeecard/features/authentication/domain/entities/authenticated_user.dart';
import 'package:coffeecard/features/authentication/domain/usecases/clear_authenticated_user.dart';
import 'package:coffeecard/features/authentication/domain/usecases/get_authenticated_user.dart';
import 'package:coffeecard/features/authentication/domain/usecases/save_authenticated_user.dart';
import 'package:coffeecard/features/session/domain/usecases/get_session_details.dart';
import 'package:coffeecard/features/session/domain/usecases/save_session_details.dart';
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
  final GetSessionDetails getSessionDetails;
  final SaveSessionDetails saveSessionDetails;
  final DateService dateService;

  AuthenticationCubit({
    required this.clearAuthenticatedUser,
    required this.saveAuthenticatedUser,
    required this.getAuthenticatedUser,
    required this.getSessionDetails,
    required this.saveSessionDetails,
    required this.dateService,
  }) : super(const AuthenticationState._());

  Future<void> appStarted() async {
    final authenticatedUser = await getAuthenticatedUser();

    authenticatedUser.match(
      () => emit(const AuthenticationState.unauthenticated()),
      (authenticatedUser) async {
        final sessionDetails = await getSessionDetails();

        sessionDetails.map(
          (sessionDetails) async {
            final sessionExpired = _isSessionExpired(
              sessionDetails.lastLogin,
              sessionDetails.sessionTimeout,
            );

            if (sessionExpired) {
              await unauthenticated();
              return;
            }
          },
        );

        emit(AuthenticationState.authenticated(authenticatedUser));
      },
    );
  }

  bool _isSessionExpired(
    Option<DateTime> lastLogin,
    Option<Duration?> sessionTimeout,
  ) {
    return lastLogin.match(
      () => false,
      (lastLogin) => sessionTimeout.match(
        () => false,
        (sessionTimeout) {
          if (sessionTimeout == null) {
            return false;
          }

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
    await saveAuthenticatedUser(
      email: email,
      token: token,
      encodedPasscode: encodedPasscode,
    );

    final sessionDetails = await getSessionDetails();

    final now = some(dateService.currentDateTime);
    sessionDetails.match(
      () async => await saveSessionDetails(
        lastLogin: now,
        sessionTimeout: none(),
      ),
      (sessionDetails) async => await saveSessionDetails(
        lastLogin: now,
        sessionTimeout: sessionDetails.sessionTimeout,
      ),
    );

    emit(
      AuthenticationState.authenticated(
        AuthenticatedUser(
          token: token,
          email: email,
          encodedPasscode: encodedPasscode,
        ),
      ),
    );
  }

  Future<void> unauthenticated() async {
    await clearAuthenticatedUser();

    final sessionDetails = await getSessionDetails();

    sessionDetails.match(
      () async => await saveSessionDetails(
        lastLogin: none(),
        sessionTimeout: none(),
      ),
      (sessionDetails) async => await saveSessionDetails(
        lastLogin: none(),
        sessionTimeout: sessionDetails.sessionTimeout,
      ),
    );

    emit(const AuthenticationState.unauthenticated());
  }
}
