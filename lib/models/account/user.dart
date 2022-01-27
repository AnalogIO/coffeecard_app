import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final bool privacyActivated;
  final int? programmeId;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.privacyActivated,
    this.programmeId,
  });

  User.fromDTO(UserDto dto)
      : id = dto.id!,
        name = dto.name!,
        email = dto.email!,
        privacyActivated = dto.privacyActivated!,
        programmeId = dto.programmeId;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      email,
      privacyActivated,
      programmeId,
    ];
  }
}
