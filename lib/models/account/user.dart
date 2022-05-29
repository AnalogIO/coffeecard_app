import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final bool privacyActivated;
  final int programmeId;
  final ProgrammeInfo programme;
  final int rankMonth;
  final int rankSemester;
  final int rankTotal;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.privacyActivated,
    required this.programmeId,
    this.programme = const ProgrammeInfo('None', 'None'),
    required this.rankMonth,
    required this.rankSemester,
    required this.rankTotal,
  });

  User.fromDTO(UserDto dto)
      : id = dto.id,
        name = dto.name,
        email = dto.email,
        privacyActivated = dto.privacyActivated,
        programmeId = dto.programmeId,
        programme = const ProgrammeInfo('None', 'None'),
        rankMonth = dto.rankMonth,
        rankSemester = dto.rankSemester,
        rankTotal = dto.rankAllTime;

  User copyWith({
    int? id,
    String? name,
    String? email,
    bool? privacyActivated,
    int? programmeId,
    ProgrammeInfo? programme,
    int? rankMonth,
    int? rankSemester,
    int? rankTotal,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      privacyActivated: privacyActivated ?? this.privacyActivated,
      programmeId: programmeId ?? this.programmeId,
      programme: programme ?? this.programme,
      rankMonth: rankMonth ?? this.rankMonth,
      rankSemester: rankSemester ?? this.rankSemester,
      rankTotal: rankTotal ?? this.rankTotal,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      email,
      privacyActivated,
      programmeId,
      rankMonth,
      rankSemester,
      rankTotal,
    ];
  }
}

class ProgrammeInfo {
  final String shortName;
  final String fullName;

  const ProgrammeInfo(this.shortName, this.fullName);
}
