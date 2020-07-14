import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable()
class Login {
  String email;
  String password;
  String version;

  Login(this.email, this.password, this.version);

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);

  Map<String, dynamic> toJson() => _$LoginToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Login &&
          runtimeType == other.runtimeType &&
          email == other.email &&
          password == other.password &&
          version == other.version;

  @override
  int get hashCode => email.hashCode ^ password.hashCode ^ version.hashCode;
}
