import 'package:coffeecard/features/authentication.dart';

class SaveAuthenticatedUser {
  final AuthenticationLocalDataSource dataSource;

  SaveAuthenticatedUser({required this.dataSource});

  Future<void> call({
    required String email,
    required String token,
    required String encodedPasscode,
  }) async {
    return dataSource.saveAuthenticatedUser(
      AuthenticatedUserModel(
        email: email,
        token: token,
        encodedPasscode: encodedPasscode,
      ),
    );
  }
}
