import 'package:coffeecard/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:coffeecard/features/authentication/domain/entities/authenticated_user.dart';

class GetAuthenticatedUser {
  final AuthenticationLocalDataSource dataSource;

  GetAuthenticatedUser({required this.dataSource});

  Future<AuthenticatedUser?> call() async {
    return dataSource.getAuthenticatedUser();
  }
}
