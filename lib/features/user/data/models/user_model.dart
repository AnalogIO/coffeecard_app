import 'package:coffeecard/features/occupation/data/models/occupation_model.dart';
import 'package:coffeecard/features/occupation/domain/entities/occupation.dart';
import 'package:coffeecard/features/user/data/models/role_model.dart';
import 'package:coffeecard/features/user/domain/entities/role.dart';
import 'package:coffeecard/features/user/domain/entities/roles.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.privacyActivated,
    required super.occupation,
    required super.rankMonth,
    required super.rankSemester,
    required super.rankTotal,
    required super.role,
  });

  factory UserModel.fromResponseV2(UserResponse response) {
    final programmeDto =
        ProgrammeResponse.fromJson(response.programme as Map<String, dynamic>);

    return UserModel(
      id: response.id,
      name: response.name,
      email: response.email,
      privacyActivated: response.privacyActivated,
      occupation: OccupationModel.fromDTOV2(programmeDto),
      rankMonth: response.rankMonth,
      rankSemester: response.rankSemester,
      rankTotal: response.rankAllTime,
      role: RoleModel.fromJson(response.role),
    );
  }

  factory UserModel.fromDtoV1(UserDto dto) {
    return UserModel(
      id: dto.id,
      name: dto.name,
      email: dto.email,
      privacyActivated: dto.privacyActivated,
      occupation: const Occupation.empty(),
      rankMonth: dto.rankMonth,
      rankSemester: dto.rankSemester,
      rankTotal: dto.rankAllTime,
      role: const Role(Roles.customer),
    );
  }
}
