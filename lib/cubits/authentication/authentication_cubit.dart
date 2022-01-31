import 'package:coffeecard/data/storage/secure_storage.dart';
import 'package:coffeecard/models/account/authenticated_user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_state.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final SecureStorage _storage;

  AuthenticationCubit(this._storage) : super(const AuthenticationState._()) {
    appStarted();
  }

  Future<void> appStarted() async {
    final authenticatedUser = await _storage.getAuthenticatedUser();
    if (authenticatedUser != null) {
      emit(AuthenticationState.authenticated(authenticatedUser));
    } else {
      emit(const AuthenticationState.unauthenticated());
    }
  }

  Future<void> authenticated(String email, String token) async {
    await _storage.saveAuthenticatedUser(
      email,
      token,
    );
    emit(
      AuthenticationState.authenticated(AuthenticatedUser(token: token, email: email)),
    );
  }

  Future<void> unauthenticated() async {
    await _storage.clearAuthenticatedUser();
    emit(const AuthenticationState.unauthenticated());
  }
}
