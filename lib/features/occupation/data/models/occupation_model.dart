import 'package:coffeecard/features/occupation/domain/entities/occupation.dart';
import 'package:coffeecard/generated/api/coffeecard_api.models.swagger.dart';

class OccupationModel extends Occupation {
  const OccupationModel({
    required super.id,
    required super.shortName,
    required super.fullName,
  });

  factory OccupationModel.fromDTO(ProgrammeDto dto) {
    return OccupationModel(
      id: dto.id,
      shortName: dto.shortName,
      fullName: dto.fullName,
    );
  }
}
