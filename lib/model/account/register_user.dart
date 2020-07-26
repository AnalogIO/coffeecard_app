import 'package:json_annotation/json_annotation.dart';

part 'register_user.g.dart';

@JsonSerializable()
class RegisterUser {
  String name;
  String email;
  String password;

  RegisterUser(this.name, this.email, this.password);

  factory RegisterUser.fromJson(Map<String, dynamic> json) => _$RegisterUserFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterUserToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegisterUser &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password &&
          name == other.name;

  @override
  int get hashCode => email.hashCode ^ password.hashCode ^ name.hashCode;
}
