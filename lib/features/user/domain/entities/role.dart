import 'package:coffeecard/generated/api/coffeecard_api_v2.enums.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.models.swagger.dart';

enum Role {
  customer,
  barista,
  manager,
  board,
}

extension RoleExtension on Role {
  // json is a dynamic object by its very nature
  //ignore: avoid-dynamic
  static Role fromJson(dynamic json) {
    final role = userRoleFromJson(json);

    switch (role) {
      case UserRole.customer:
        return Role.customer;
      case UserRole.barista:
        return Role.barista;
      case UserRole.manager:
        return Role.manager;
      case UserRole.board:
        return Role.board;
      case UserRole.swaggerGeneratedUnknown:
        break;
    }

    throw Exception(message: 'unknown role $role');
  }
}
