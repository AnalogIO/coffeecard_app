import 'package:coffeecard/generated/api/coffeecard_api_v2.models.swagger.dart';
import 'package:equatable/equatable.dart';

class LeaderboardUser extends Equatable {
  final int id;
  final int rank;
  final int score;
  final String name;
  final bool highlight;

  const LeaderboardUser({
    required this.id,
    required this.rank,
    required this.score,
    required this.name,
    required this.highlight,
  });

  LeaderboardUser.fromDTO(LeaderboardEntry dto)
      : id = dto.id!,
        name = dto.name!,
        rank = dto.rank!,
        score = dto.score!,
        highlight = false;

  @override
  List<Object?> get props {
    return [id, rank, score, name, highlight];
  }
}
