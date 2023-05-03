import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/leaderboard/data/datasources/leaderboard_remote_data_source.dart';
import 'package:coffeecard/features/leaderboard/data/models/leaderboard_user_model.dart';
import 'package:coffeecard/features/leaderboard/presentation/cubit/leaderboard_cubit.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'leaderboard_remote_data_source_test.mocks.dart';

@GenerateMocks([CoffeecardApiV2, NetworkRequestExecutor])
void main() {
  late MockCoffeecardApiV2 apiV2;
  late MockNetworkRequestExecutor executor;
  late LeaderboardRemoteDataSource dataSource;

  setUp(() {
    apiV2 = MockCoffeecardApiV2();
    executor = MockNetworkRequestExecutor();
    dataSource = LeaderboardRemoteDataSource(apiV2: apiV2, executor: executor);
  });

  group('getLeaderboard', () {
    test('should return [Right] when executor succeeds', () async {
      // arrange
      when(executor.call<List<LeaderboardEntry>>(any)).thenAnswer(
        (_) async => const Right([]),
      );

      // act
      final actual = await dataSource.getLeaderboard(
        LeaderboardFilter.total,
        10,
      );

      // assert
      expect(actual.isRight(), true);
      actual.map(
        (response) => expect(response, []),
      );
    });

    test('should return [Left] when executor fails', () async {
      // arrange

      when(executor.call<List<LeaderboardEntry>>(any)).thenAnswer(
        (_) async => const Left(ServerFailure('some error')),
      );

      // act
      final actual = await dataSource.getLeaderboard(
        LeaderboardFilter.total,
        10,
      );

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });
  });

  group('getLeaderboardUser', () {
    test('should return [Right] when executor succeeds', () async {
      // arrange
      when(executor.call<LeaderboardEntry>(any)).thenAnswer(
        (_) async => Right(
          LeaderboardEntry(
            id: 0,
            rank: 0,
            score: 0,
            name: 'name',
          ),
        ),
      );

      // act
      final actual =
          await dataSource.getLeaderboardUser(LeaderboardFilter.total);

      // assert
      expect(actual.isRight(), true);
      actual.map(
        (response) => expect(
          response,
          const LeaderboardUserModel(
            id: 0,
            rank: 0,
            score: 0,
            name: 'name',
            highlight: false,
          ),
        ),
      );
    });

    test('should return [Left] when executor fails', () async {
      // arrange

      when(executor.call<LeaderboardEntry>(any)).thenAnswer(
        (_) async => const Left(ServerFailure('some error')),
      );

      // act
      final actual =
          await dataSource.getLeaderboardUser(LeaderboardFilter.total);

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });
  });
}
