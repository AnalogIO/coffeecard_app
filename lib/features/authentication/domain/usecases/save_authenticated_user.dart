import 'package:coffeecard/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:coffeecard/features/authentication/data/models/authenticated_user_model.dart';

class SaveAuthenticatedUser {
  final AuthenticationLocalDataSource dataSource;

  SaveAuthenticatedUser({required this.dataSource});

  Future<void> call({
    required String email,
    required String token,
    required String encodedPasscode,
  }) {
    return dataSource.saveAuthenticatedUser(
      AuthenticatedUserModel(
        email: email,
        token: token,
        encodedPasscode: encodedPasscode,
      ),
    );
  }
}
