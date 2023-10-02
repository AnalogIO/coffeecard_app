import 'package:coffeecard/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:coffeecard/features/authentication/data/models/authenticated_user_model.dart';
import 'package:coffeecard/features/authentication/domain/entities/authenticated_user.dart';

class SaveAuthenticatedUser {
  final AuthenticationLocalDataSource dataSource;

  SaveAuthenticatedUser({required this.dataSource});

  Future<void> call(AuthenticatedUser user) async {
    return dataSource.saveAuthenticatedUser(
      AuthenticatedUserModel(
        email: user.email,
        token: user.token,
        encodedPasscode: user.encodedPasscode,
        lastLogin: user.lastLogin,
        sessionTimeout: user.sessionTimeout,
      ),
    );
  }
}
