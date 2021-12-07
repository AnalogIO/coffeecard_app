import 'package:coffeecard/model/account/user_auth.dart';
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
      final userAuth = await _storage.getUserAuth();
      if (userAuth != null) {
        add(Authenticated(userAuth));
      } else {
        add(Unauthenticated());
      }
    });

    on<Authenticated>((event, emit) async {
      await _storage.saveUserAuth(
        event.userAuth.email,
        event.userAuth.token,
      );
      emit(AuthState.authenticated(event.userAuth));
    });

    on<Unauthenticated>((event, emit) async {
      await _storage.clearUserAuth();
      emit(const AuthState.unauthenticated());
    });

    on<AuthEvent>((event, emit) {
      print('AuthBloc: ${event.runtimeType}');
    });
  }
}
