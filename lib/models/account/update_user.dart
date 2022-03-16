import 'package:equatable/equatable.dart';

class UpdateUser extends Equatable {
  final String? name;
  final String? email;
  final String? password;
  final bool? privacyActivated;
  final int? programmeId;

  const UpdateUser({
    this.name,
    this.email,
    this.password,
    this.privacyActivated,
    this.programmeId,
  });

  @override
  List<Object?> get props {
    return [
      name,
      email,
      password,
      privacyActivated,
      programmeId,
    ];
  }
}
