import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:coffeecard/features/user/domain/repositories/user_repository.dart';
import 'package:coffeecard/models/account/update_user.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UpdateUserDetails implements UseCase<User, Params> {
  final UserRepository repository;

  UpdateUserDetails({required this.repository});

  @override
  Future<Either<Failure, User>> call(Params params) async {
    return repository.updateUserDetails(
      UpdateUser(
        name: params.name,
        email: params.email,
        encodedPasscode: params.encodedPasscode,
        privacyActivated: params.privacyActivated,
        occupationId: params.occupationId,
      ),
    );
  }
}

class Params extends Equatable {
  final String? name;
  final String? email;
  final String? encodedPasscode;
  final bool? privacyActivated;
  final int? occupationId;

  const Params({
    required this.name,
    required this.email,
    required this.encodedPasscode,
    required this.privacyActivated,
    required this.occupationId,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        encodedPasscode,
        privacyActivated,
        occupationId,
      ];
}
