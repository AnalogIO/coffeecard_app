import 'package:fpdart/fpdart.dart';

extension EitherExtensionsAsync<L, R> on Future<Either<L, R>> {
  Future<Either<L, R2>> bindFuture<R2>(R2 Function(R) f) async {
    return (await this).bimap(
      (l) => l,
      (r) => f(r),
    );
  }
}
