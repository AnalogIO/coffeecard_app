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

  AuthenticationCubit({
    required this.clearAuthenticatedUser,
    required this.saveAuthenticatedUser,
    required this.getAuthenticatedUser,
  }) : super(const AuthenticationState._());

  Future<void> appStarted() async {
    final authenticatedUser = await getAuthenticatedUser();

    if (authenticatedUser == null) {
      emit(const AuthenticationState.unauthenticated());
      return;
    }

    emit(AuthenticationState.authenticated(authenticatedUser));
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
    emit(const AuthenticationState.unauthenticated());
  }
}
