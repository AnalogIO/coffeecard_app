import 'package:json_annotation/json_annotation.dart';

part 'Login.g.dart';

@JsonSerializable()
class Login {
  String email;
  String password;
  String version;

  Login(this.email, this.password, this.version);

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);

  Map<String, dynamic> toJson() => _$LoginToJson(this);
}
