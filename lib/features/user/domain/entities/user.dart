import 'package:coffeecard/features/occupation/domain/entities/occupation.dart';
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

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.privacyActivated,
    required this.occupation,
    required this.rankMonth,
    required this.rankSemester,
    required this.rankTotal,
  });

  User copyWith({
    int? id,
    String? name,
    String? email,
    bool? privacyActivated,
    int? occupationId,
    Occupation? occupation,
    int? rankMonth,
    int? rankSemester,
    int? rankTotal,
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
