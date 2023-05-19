import 'package:coffeecard/core/errors/failures.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

final class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
