import 'package:coffeecard/features/occupation/data/models/occupation_model.dart';
import 'package:coffeecard/features/user/domain/entities/role.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
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

  factory UserModel.fromResponse(UserResponse response) {
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
      role: RoleExtension.fromJson(response.role),
    );
  }
}
