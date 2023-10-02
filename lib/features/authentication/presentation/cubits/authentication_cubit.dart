import 'package:coffeecard/core/external/date_service.dart';
import 'package:coffeecard/features/authentication/data/models/authenticated_user_model.dart';
import 'package:coffeecard/features/authentication/domain/entities/authenticated_user.dart';
import 'package:coffeecard/features/authentication/domain/usecases/clear_authenticated_user.dart';
import 'package:coffeecard/features/authentication/domain/usecases/get_authenticated_user.dart';
import 'package:coffeecard/features/authentication/domain/usecases/save_authenticated_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    final sessionExpired = isSessionExpired(authenticatedUser);

    if (authenticatedUser == null || sessionExpired) {
      emit(const AuthenticationState.unauthenticated());
    } else {
      emit(AuthenticationState.authenticated(authenticatedUser));
    }
  }

  bool isSessionExpired(AuthenticatedUser? user) {
    final lastLogin = user?.lastLogin;
    final timeout = user?.sessionTimeout;

    if (lastLogin == null || timeout == null) {
      return false;
    }

    final now = dateService.now();
    final tDifference = now.difference(lastLogin);
    return tDifference > timeout;
  }

  Future<void> authenticated(
    String email,
    String encodedPasscode,
    String token,
  ) async {
    final user = AuthenticatedUserModel(
      token: token,
      email: email,
      encodedPasscode: encodedPasscode,
      lastLogin: DateTime.now(),
    );

    await saveAuthenticatedUser(user);

    emit(
      AuthenticationState.authenticated(
        user,
      ),
    );
  }

  Future<void> unauthenticated() async {
    await clearAuthenticatedUser();
    emit(const AuthenticationState.unauthenticated());
  }

  Future<void> saveSessionTimeout(Duration? duration) async {
    final user = await getAuthenticatedUser();

    if (user == null) {
      return;
    }

    await saveAuthenticatedUser(
      AuthenticatedUserModel(
        email: user.email,
        token: user.token,
        encodedPasscode: user.encodedPasscode,
        lastLogin: user.lastLogin,
        sessionTimeout: duration,
      ),
    );
  }
}
