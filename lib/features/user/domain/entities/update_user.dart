import 'package:equatable/equatable.dart';

class UpdateUser extends Equatable {
  final String? name;
  final String? email;
  final String? encodedPasscode;
  final bool? privacyActivated;
  final int? occupationId;
  final int? profileIconId;
  final int? profileBackgroundColorId;

  const UpdateUser({
    this.name,
    this.email,
    this.encodedPasscode,
    this.privacyActivated,
    this.occupationId,
    this.profileIconId,
    this.profileBackgroundColorId,
  });

  @override
  List<Object?> get props {
    return [
      name,
      email,
      encodedPasscode,
      privacyActivated,
      occupationId,
      profileIconId,
      profileBackgroundColorId,
    ];
  }
}
