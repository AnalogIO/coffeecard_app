import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:coffeecard/data/repositories/v1/account_repository.dart';
import 'package:coffeecard/data/storage/secure_storage.dart';

class ReactivationAuthenticator extends Authenticator {
  final SecureStorage secureStorage;
  //final AccountRepository _accountRepository;

  ReactivationAuthenticator(this.secureStorage);

  @override
  FutureOr<Request?> authenticate(Request request, Response response) async {
    if (response.statusCode == 401) {
      final email = await secureStorage.readEmail();
      final passcode = await secureStorage.readPasscode();

      if (email != null && passcode != null) {
        /*final either = await _accountRepository.login(email, passcode);

        if (either.isRight) {
          final Map<String, String> updatedHeaders =
              Map<String, String>.of(request.headers);

          final newToken = 'Bearer ${either.right.token}';
          updatedHeaders.update(
            'Authorization',
            (String _) => newToken,
            ifAbsent: () => newToken,
          );
          return request.copyWith(headers: updatedHeaders);
        } */
      }
    }
    return null;
  }
}
