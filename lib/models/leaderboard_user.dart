import 'package:coffeecard/generated/api/coffeecard_api.swagger.swagger.dart';
import 'package:equatable/equatable.dart';

class LeaderboardUser extends Equatable {
  final String name;
  final int rank;

  const LeaderboardUser({
    required this.name,
    required this.rank,
  });

  LeaderboardUser.fromDTO(LeaderboardDto dto)
      : name = dto.name!,
        rank = dto.score!;

  @override
  List<Object?> get props {
    return [name, rank];
  }
}
