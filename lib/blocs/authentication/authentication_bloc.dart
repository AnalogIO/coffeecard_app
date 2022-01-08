import 'package:coffeecard/models/account/authenticated_user.dart';
import 'package:coffeecard/persistence/storage/secure_storage.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SecureStorage _storage;

  AuthBloc(this._storage) : super(const AuthState.unknown()) {
    on<AppStarted>((event, emit) async {
      final authenticatedUser = await _storage.getAuthenticatedUser();
      if (authenticatedUser != null) {
        emit(AuthState.authenticated(authenticatedUser));
      } else {
        emit(const AuthState.unauthenticated());
      }
    });

    on<Authenticated>((event, emit) async {
      await _storage.saveAuthenticatedUser(
        event.authenticatedUser.email,
        event.authenticatedUser.token,
      );
      emit(AuthState.authenticated(event.authenticatedUser));
    });

    on<Unauthenticated>((event, emit) async {
      await _storage.clearAuthenticatedUser();
      emit(const AuthState.unauthenticated());
    });
  }
}
