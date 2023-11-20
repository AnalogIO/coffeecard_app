import 'package:coffeecard/features/authentication/data/datasources/authentication_local_data_source.dart';

class ClearAuthenticatedUser {
  final AuthenticationLocalDataSource dataSource;

  ClearAuthenticatedUser({required this.dataSource});

  Future<void> call() async {
    await dataSource.clearAuthenticatedUser();
  }
}
