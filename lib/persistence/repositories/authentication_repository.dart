import 'dart:async';

import 'package:coffeecard/persistence/repositories/account_repository.dart';
import 'package:meta/meta.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();
  final AccountRepository accountRepository;

  AuthenticationRepository(this.accountRepository);

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.unauthenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    @required String username,
    @required String password,
  }) async {
    assert(username != null);
    assert(password != null);

    await accountRepository.login(username, password); //If the login fails an exception will be propagated to the caller

    _controller.add(AuthenticationStatus.authenticated);
  }

  void logOut() {
    throw UnimplementedError; //TODO implement by deleting token in storage?
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
