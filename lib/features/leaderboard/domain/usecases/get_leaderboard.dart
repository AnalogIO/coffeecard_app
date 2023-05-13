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
    final userleaderboard = await remoteDataSource.getLeaderboardUser(filter);

    return userleaderboard.fold(
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
    var userInLeaderboard = false;
    final List<LeaderboardUser> users = leaderboard.map((leaderboardUser) {
      final isCurrentUser = leaderboardUser.id == user.id;

      // set the 'found' flag if this is the current user
      if (!userInLeaderboard && isCurrentUser) {
        userInLeaderboard = true;
      }

      return LeaderboardUser(
        id: leaderboardUser.id,
        name: leaderboardUser.name,
        score: leaderboardUser.score,
        highlight: isCurrentUser,
        rank: leaderboardUser.rank,
      );
    }).toList();

    if (!userInLeaderboard) {
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