import 'package:coffeecard/generated/api/coffeecard_api_v2.enums.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.models.swagger.dart';

enum Role { customer, barista, manager, board }

extension RoleExtension on Role {
  // json is a dynamic object by its very nature
  // ignore: avoid-dynamic
  static Role fromJson(dynamic json) {
    final role = userRoleFromJson(json);
    return switch (role) {
      UserRole.customer => Role.customer,
      UserRole.barista => Role.barista,
      UserRole.manager => Role.manager,
      UserRole.board => Role.board,
      UserRole.swaggerGeneratedUnknown => throw ArgumentError.value(role),
    };
  }
}
