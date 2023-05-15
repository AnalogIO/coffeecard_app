import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/usecases/usecase.dart';
import 'package:coffeecard/features/leaderboard/data/datasources/leaderboard_remote_data_source.dart';
import 'package:coffeecard/features/leaderboard/domain/entities/leaderboard_user.dart';
import 'package:coffeecard/features/leaderboard/presentation/cubit/leaderboard_cubit.dart';
import 'package:dartz/dartz.dart';

class GetLeaderboard
    implements UseCase<List<LeaderboardUser>, LeaderboardFilter> {
  final LeaderboardRemoteDataSource remoteDataSource;

  GetLeaderboard({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<LeaderboardUser>>> call(
    LeaderboardFilter filter,
  ) async {
    final leaderboardUser = await remoteDataSource.getLeaderboardUser(filter);

    return leaderboardUser.fold(
      (error) => Left(error),
      (user) async {
        final leaderboardEither =
            await remoteDataSource.getLeaderboard(filter, 10);

        return leaderboardEither.fold(
          (error) => Left(error),
          (leaderboard) => Right(buildLeaderboard(leaderboard, user)),
        );
      },
    );
  }

  List<LeaderboardUser> buildLeaderboard(
    List<LeaderboardUser> leaderboard,
    LeaderboardUser user,
  ) {
    final users = leaderboard
        .map(
          (leaderboardUser) => LeaderboardUser(
            id: leaderboardUser.id,
            name: leaderboardUser.name,
            score: leaderboardUser.score,
            highlight: leaderboardUser.id == user.id, // is current user
            rank: leaderboardUser.rank,
          ),
        )
        .toList();

    // user is not in the leaderboard, highlight them at the bottom
    if (!users.contains(user)) {
      users.add(
        LeaderboardUser(
          id: user.id,
          name: user.name,
          highlight: true,
          score: user.score,
          rank: user.rank,
        ),
      );
    }

    return users;
  }
}
