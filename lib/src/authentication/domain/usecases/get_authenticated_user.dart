import 'package:coffeecard/features/authentication.dart';
import 'package:fpdart/fpdart.dart';

class GetAuthenticatedUser {
  final AuthenticationLocalDataSource dataSource;

  GetAuthenticatedUser({required this.dataSource});

  Future<Option<AuthenticatedUser>> call() async {
    return dataSource.getAuthenticatedUser();
  }
}
