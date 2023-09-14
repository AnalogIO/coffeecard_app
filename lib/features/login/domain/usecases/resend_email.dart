import 'package:coffeecard/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

class ResendEmail {
  Future<Either<ServerFailure, void>> call(String email) async {
    //TODO: implement
    return const Left(ServerFailure('fail!', 500));
  }
}
