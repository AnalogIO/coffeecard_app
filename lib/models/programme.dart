import 'package:coffeecard/generated/api/coffeecard_api.models.swagger.dart';
import 'package:equatable/equatable.dart';

class Programme extends Equatable {
  const Programme({
    required this.id,
    required this.shortName,
    required this.fullName,
  });

  final int id;
  final String shortName;
  final String fullName;

  Programme.fromDTO(ProgrammeDto dto)
      : id = dto.id,
        shortName = dto.shortName,
        fullName = dto.fullName;

  @override
  List<Object> get props => [id, shortName, fullName];
}
