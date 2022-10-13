import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:equatable/equatable.dart';

class LeaderboardUser extends Equatable {
  final String name;
  final int score;

  const LeaderboardUser({
    required this.name,
    required this.score,
  });

  LeaderboardUser.fromDTO(LeaderboardEntry dto)
      : name = dto.name!,
        score = dto.score!;

  @override
  List<Object?> get props {
    return [name, score];
  }
}
