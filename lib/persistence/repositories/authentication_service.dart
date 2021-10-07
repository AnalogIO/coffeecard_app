import 'dart:async';

import 'package:coffeecard/model/account/user.dart';
import 'package:coffeecard/persistence/repositories/account_repository.dart';
import 'package:coffeecard/utils/exception_extractor.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationService {
  final _controller = StreamController<AuthenticationStatus>();
  final AccountRepository accountRepository;

  AuthenticationService(this.accountRepository);

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

  Future<User> getUser() async {
    return accountRepository.getUser();
  }

  void dispose() => _controller.close();
}

abstract class LoginStatus extends Equatable {
  @override
  List<Object> get props => [];
}

class SuccessfulLogin extends LoginStatus {}

class FailedLogin extends LoginStatus {
  final String errorMessage;

  FailedLogin(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
