import 'package:coffeecard/features/occupation/domain/entities/occupation.dart';
import 'package:coffeecard/generated/api/coffeecard_api.models.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.models.swagger.dart';

class OccupationModel extends Occupation {
  const OccupationModel({
    required super.id,
    required super.shortName,
    required super.fullName,
  });

  factory OccupationModel.fromDTOV1(ProgrammeDto dto) {
    return OccupationModel(
      id: dto.id,
      shortName: dto.shortName,
      fullName: dto.fullName,
    );
  }

  factory OccupationModel.fromDTOV2(ProgrammeResponse dto) {
    return OccupationModel(
      id: dto.id,
      shortName: dto.shortName,
      fullName: dto.fullName,
    );
  }
}
