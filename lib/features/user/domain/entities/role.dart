import 'package:coffeecard/features/user/domain/entities/roles.dart';
import 'package:equatable/equatable.dart';

class Role extends Equatable {
  final Roles role;

  const Role(this.role);

  bool get isBarista => role == Roles.barista;
  bool get isManager => role == Roles.manager;
  bool get isBoard => role == Roles.board;
  bool get isCustomer => role == Roles.customer;

  @override
  List<Object?> get props => [role];
}
