import 'package:coffeecard/features/occupation/domain/entities/occupation.dart';
import 'package:coffeecard/features/user/domain/entities/role.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final bool privacyActivated;
  final Occupation occupation;
  final int rankMonth;
  final int rankSemester;
  final int rankTotal;
  final Role role;
  final int? icon;
  final int? background;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.privacyActivated,
    required this.occupation,
    required this.rankMonth,
    required this.rankSemester,
    required this.rankTotal,
    required this.role,
    required this.icon,
    required this.background,
  });

  bool get hasBaristaPerks {
    switch (role) {
      case Role.barista:
      case Role.manager:
      case Role.board:
        return true;
      case Role.customer:
        return false;
    }
  }

  User copyWith(
      {int? id,
      String? name,
      String? email,
      bool? privacyActivated,
      Occupation? occupation,
      int? rankMonth,
      int? rankSemester,
      int? rankTotal,
      Role? role,
      int? icon,
      int? background}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      privacyActivated: privacyActivated ?? this.privacyActivated,
      occupation: occupation ?? this.occupation,
      rankMonth: rankMonth ?? this.rankMonth,
      rankSemester: rankSemester ?? this.rankSemester,
      rankTotal: rankTotal ?? this.rankTotal,
      role: role ?? this.role,
      icon: icon ?? this.icon,
      background: background ?? this.background,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      email,
      role,
      privacyActivated,
      occupation,
      rankMonth,
      rankSemester,
      rankTotal,
      icon,
      background,
    ];
  }
}
