import 'package:json_annotation/json_annotation.dart';

part 'email.g.dart';

@JsonSerializable()
class Email {
  String email;

  Email(this.email);

  factory Email.fromJson(Map<String, dynamic> json) => _$EmailFromJson(json);

  Map<String, dynamic> toJson() => _$EmailToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Email &&
          runtimeType == other.runtimeType &&
          email == other.email;

  @override
  int get hashCode => email.hashCode;
}
