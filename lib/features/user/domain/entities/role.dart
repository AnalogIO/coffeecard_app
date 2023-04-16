import 'package:coffeecard/features/user/domain/entities/roles.dart';
import 'package:equatable/equatable.dart';

class Role extends Equatable {
  final Roles userGroup;

  const Role(this.userGroup);

  @override
  List<Object?> get props => [userGroup];
}
