import 'package:coffeecard/data/storage/secure_storage.dart';
import 'package:coffeecard/features/authentication/domain/entities/authenticated_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_state.dart';

// We might consider changing this back to a bloc if we want different events to
// trigger a logout (for instance, when the user requests logs out themselves
// vs the user's token expires and fails to renew).
class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit(this._storage) : super(const AuthenticationState._());

  final SecureStorage _storage;

  Future<void> appStarted() async {
    final authenticatedUser = await _storage.getAuthenticatedUser();
    if (authenticatedUser != null) {
      emit(AuthenticationState.authenticated(authenticatedUser));
    } else {
      emit(const AuthenticationState.unauthenticated());
    }
  }

  Future<void> authenticated(
    String email,
    String encodedPasscode,
    String token,
  ) async {
    await _storage.saveAuthenticatedUser(
      email,
      encodedPasscode,
      token,
    );
    emit(
      AuthenticationState.authenticated(
        AuthenticatedUser(token: token, email: email),
      ),
    );
  }

  Future<void> unauthenticated() async {
    await _storage.clearAuthenticatedUser();
    emit(const AuthenticationState.unauthenticated());
  }
}
