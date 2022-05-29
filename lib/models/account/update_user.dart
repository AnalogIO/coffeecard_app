import 'package:equatable/equatable.dart';

class UpdateUser extends Equatable {
  final String? name;
  final String? email;
  final String? encodedPasscode;
  final bool? privacyActivated;
  final int? programmeId;

  const UpdateUser({
    this.name,
    this.email,
    this.encodedPasscode,
    this.privacyActivated,
    this.programmeId,
  });

  @override
  List<Object?> get props {
    return [
      name,
      email,
      encodedPasscode,
      privacyActivated,
      programmeId,
    ];
  }
}
