import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/leaderboard/data/datasources/leaderboard_remote_data_source.dart';
import 'package:coffeecard/features/leaderboard/data/models/leaderboard_user_model.dart';
import 'package:coffeecard/features/leaderboard/presentation/cubit/leaderboard_cubit.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'leaderboard_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CoffeecardApiV2>(),
  MockSpec<NetworkRequestExecutor>(),
])
void main() {
  late MockCoffeecardApiV2 apiV2;
  late MockNetworkRequestExecutor executor;
  late LeaderboardRemoteDataSource dataSource;

  setUp(() {
    apiV2 = MockCoffeecardApiV2();
    executor = MockNetworkRequestExecutor();
    dataSource = LeaderboardRemoteDataSource(apiV2: apiV2, executor: executor);

    provideDummy<Either<Failure, List<LeaderboardEntry>>>(
      const Left(ConnectionFailure()),
    );
    provideDummy<Either<Failure, LeaderboardEntry>>(
      const Left(ConnectionFailure()),
    );
  });

  const testErrorMessage = 'some error';

  group('getLeaderboard', () {
    test('should return [Right] when executor succeeds', () async {
      // arrange
      when(executor.execute<List<LeaderboardEntry>>(any)).thenAnswer(
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
      when(executor.execute<List<LeaderboardEntry>>(any)).thenAnswer(
        (_) async => const Left(ServerFailure(testErrorMessage, 500)),
      );

      // act
      final actual = await dataSource.getLeaderboard(
        LeaderboardFilter.total,
        10,
      );

      // assert
      expect(actual, const Left(ServerFailure(testErrorMessage, 500)));
    });
  });

  group('getLeaderboardUser', () {
    test('should return [Right] when executor succeeds', () async {
      // arrange
      when(executor.execute<LeaderboardEntry>(any)).thenAnswer(
        (_) async => const Right(
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
      when(executor.execute<LeaderboardEntry>(any)).thenAnswer(
        (_) async => const Left(ServerFailure(testErrorMessage, 500)),
      );

      // act
      final actual =
          await dataSource.getLeaderboardUser(LeaderboardFilter.total);

      // assert
      expect(actual, const Left(ServerFailure(testErrorMessage, 500)));
    });
  });
}
