import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String name;
  String email;
  bool privacyActivated;
  int? programmeId;
  int level;
  int requiredExp;
  int rankAllTime;
  int rankSemester;
  int rankMonth;

  User(
      {required this.name,
      required this.email,
      required this.privacyActivated,
      this.programmeId,
      required this.level,
      required this.requiredExp,
      required this.rankAllTime,
      required this.rankMonth,
      required this.rankSemester});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email &&
          privacyActivated == other.privacyActivated &&
          programmeId == other.programmeId &&
          level == other.level &&
          requiredExp == other.requiredExp &&
          rankAllTime == other.rankAllTime &&
          rankSemester == other.rankSemester &&
          rankMonth == other.rankMonth;

  @override
  int get hashCode =>
      name.hashCode ^
      email.hashCode ^
      privacyActivated.hashCode ^
      programmeId.hashCode ^
      level.hashCode ^
      requiredExp.hashCode ^
      rankAllTime.hashCode ^
      rankSemester.hashCode ^
      rankMonth.hashCode;
}
