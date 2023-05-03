import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/leaderboard/data/datasources/leaderboard_remote_data_source.dart';
import 'package:coffeecard/features/leaderboard/domain/entities/leaderboard_user.dart';
import 'package:coffeecard/features/leaderboard/domain/usecases/get_leaderboard.dart';
import 'package:coffeecard/features/leaderboard/presentation/cubit/leaderboard_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_leaderboard_test.mocks.dart';

@GenerateMocks([LeaderboardRemoteDataSource])
void main() {
  late MockLeaderboardRemoteDataSource remoteDataSource;
  late GetLeaderboard usecase;

  setUp(() {
    remoteDataSource = MockLeaderboardRemoteDataSource();
    usecase = GetLeaderboard(remoteDataSource: remoteDataSource);
  });

  group('call', () {
    const tUserLeaderboard = LeaderboardUser(
      id: 0,
      rank: 0,
      score: 0,
      name: 'name',
      highlight: true,
    );

    test('should return [Left] if getLeaderboardUser fails', () async {
      // arrange
      when(remoteDataSource.getLeaderboardUser(any))
          .thenAnswer((_) async => const Left(ServerFailure('some error')));

      // act
      final actual = await usecase(LeaderboardFilter.total);

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });
    test('should return [Left] if getLeaderboard fails', () async {
      // arrange
      when(remoteDataSource.getLeaderboardUser(any)).thenAnswer(
        (_) async => const Right(
          tUserLeaderboard,
        ),
      );
      when(remoteDataSource.getLeaderboard(any, any))
          .thenAnswer((_) async => const Left(ServerFailure('some error')));

      // act
      final actual = await usecase(LeaderboardFilter.total);

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });
    test('should return [Right] if api calls succeed', () async {
      // arrange
      when(remoteDataSource.getLeaderboardUser(any)).thenAnswer(
        (_) async => const Right(tUserLeaderboard),
      );
      when(remoteDataSource.getLeaderboard(any, any))
          .thenAnswer((_) async => const Right([]));

      // act
      final actual = await usecase(LeaderboardFilter.total);

      // assert
      expect(actual.isRight(), true);
      actual.map(
        (response) => expect(
          response,
          [tUserLeaderboard],
        ),
      );
    });
  });

  group('buildLeaderboard', () {
    test('should highlight user if present in leaderboard', () {
      // arrange
      const tUser = LeaderboardUser(
        id: 0,
        rank: 0,
        score: 0,
        name: 'name',
        highlight: false,
      );

      final tLeaderboard = [tUser];

      // act
      final actual = usecase.buildLeaderboard(tLeaderboard, tUser);

      // assert
      expect(actual, [
        const LeaderboardUser(
          id: 0,
          rank: 0,
          score: 0,
          name: 'name',
          highlight: true,
        ),
      ]);
    });

    test('should append user if not present in leaderboard', () {
      // arrange
      const tUser = LeaderboardUser(
        id: 0,
        rank: 0,
        score: 0,
        name: 'name',
        highlight: false,
      );

      final List<LeaderboardUser> tLeaderboard = [];

      // act
      final actual = usecase.buildLeaderboard(tLeaderboard, tUser);

      // assert
      expect(actual, [
        const LeaderboardUser(
          id: 0,
          rank: 0,
          score: 0,
          name: 'name',
          highlight: true,
        ),
      ]);
    });
  });
}
