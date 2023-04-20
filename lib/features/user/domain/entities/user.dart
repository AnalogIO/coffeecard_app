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
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    bool? privacyActivated,
    Occupation? occupation,
    int? rankMonth,
    int? rankSemester,
    int? rankTotal,
    Role? role,
  }) {
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
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      email,
      privacyActivated,
      occupation,
      rankMonth,
      rankSemester,
      rankTotal,
    ];
  }
}
