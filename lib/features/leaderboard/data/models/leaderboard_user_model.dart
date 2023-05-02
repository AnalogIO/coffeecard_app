import 'package:coffeecard/features/leaderboard/domain/entities/leaderboard_user.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.models.swagger.dart';

class LeaderboardUserModel extends LeaderboardUser {
  const LeaderboardUserModel({
    required super.id,
    required super.rank,
    required super.score,
    required super.name,
    required super.highlight,
  });

  factory LeaderboardUserModel.fromDTO(LeaderboardEntry dto) {
    return LeaderboardUserModel(
      id: dto.id!,
      rank: dto.rank!,
      score: dto.score!,
      name: dto.name!,
      highlight: false,
    );
  }
}
