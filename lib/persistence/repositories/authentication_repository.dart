import 'dart:async';

import 'package:coffeecard/persistence/repositories/account_repository.dart';
import 'package:coffeecard/utils/exception_extractor.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

// TODO Consider how to differentiate between a repository communicating with the restClient/persisting vs a "state" repository
class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  final AccountRepository accountRepository;

  AuthenticationRepository(this.accountRepository);

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<LoginStatus> logIn(String username, String password) async {
    try {
      await accountRepository.login(username, password);

      _controller.add(AuthenticationStatus.authenticated);

      return SuccessfulLogin();
    } on DioError catch (error) {
      final errorMessage = getDIOError(error);
      return FailedLogin(errorMessage);
    }
  }

  void logOut() {
    throw UnimplementedError;
    //TODO implement by deleting token in storage?
    //_controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}

abstract class LoginStatus extends Equatable {}

class SuccessfulLogin extends LoginStatus {
  @override
  List<Object> get props => [];
}

class FailedLogin extends LoginStatus {
  final String error;

  FailedLogin(this.error);

  @override
  List<Object> get props => [error];
}
