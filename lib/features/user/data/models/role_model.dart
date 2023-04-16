import 'package:coffeecard/features/user/domain/entities/role.dart';
import 'package:coffeecard/features/user/domain/entities/roles.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.enums.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.models.swagger.dart';

class RoleModel extends Role {
  const RoleModel(super.role);

  factory RoleModel.fromJson(dynamic json) {
    final role = userRoleFromJson(json);

    switch (role) {
      case UserRole.customer:
        return const RoleModel(Roles.customer);
      case UserRole.barista:
        return const RoleModel(Roles.barista);
      case UserRole.manager:
        return const RoleModel(Roles.manager);
      case UserRole.board:
        return const RoleModel(Roles.board);
      case UserRole.swaggerGeneratedUnknown:
        break;
    }

    throw Exception(message: 'unknown role $role');
  }
}
