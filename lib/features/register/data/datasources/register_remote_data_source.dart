import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:fpdart/fpdart.dart';

class RegisterRemoteDataSource {
  RegisterRemoteDataSource({
    required this.apiV2,
    required this.executor,
  });

  final CoffeecardApiV2 apiV2;
  final NetworkRequestExecutor executor;

  Future<Either<Failure, Unit>> register(
    String name,
    String email,
    String encodedPasscode,
    int occupationId,
  ) {
    return executor.executeAndDiscard(
      () => apiV2.apiV2AccountPost(
        body: RegisterAccountRequest(
          name: name,
          email: email,
          password: encodedPasscode,
          programmeId: occupationId,
        ),
      ),
    );
  }
}
