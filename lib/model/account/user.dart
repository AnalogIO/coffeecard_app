import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String name;
  String email;
  bool privacyActivated;
  int programmeId;
  String password;

  User({required this.name, required this.email, required this.password, required this.programmeId, required this.privacyActivated});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User &&
              runtimeType == other.runtimeType &&
              email == other.email &&
              password == other.password &&
              name == other.name &&
              privacyActivated == other.privacyActivated &&
              programmeId == other.programmeId;

  @override
  int get hashCode => email.hashCode ^ password.hashCode ^ name.hashCode ^ programmeId.hashCode ^ privacyActivated.hashCode;
}
