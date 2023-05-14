import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/data/repositories/v2/leaderboard_repository.dart';
import 'package:coffeecard/models/leaderboard/leaderboard_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'statistics_cubit_test.mocks.dart';

@GenerateMocks([LeaderboardRepository])
void main() {
  const dummyLeaderboardUser = LeaderboardUser(
    id: 0,
    name: 'name',
    score: 0,
    rank: 0,
    highlight: true,
  );
  group('statistics cubit tests', () {
    late LeaderboardCubit statisticsCubit;
    final leaderboardRepository = MockLeaderboardRepository();

    setUp(() {
      statisticsCubit = LeaderboardCubit(leaderboardRepository);
    });

    blocTest<LeaderboardCubit, StatisticsState>(
      'fetch emits StatisticsLoaded after successful fetch',
      build: () {
        when(leaderboardRepository.getLeaderboard(any))
            .thenAnswer((_) async => const Right([]));
        when(leaderboardRepository.getLeaderboardUser(any))
            .thenAnswer((_) async => const Right(dummyLeaderboardUser));
        return statisticsCubit;
      },
      act: (cubit) => cubit.fetch(),
      expect: () => [
        const StatisticsLoaded(
          [dummyLeaderboardUser],
          filter: LeaderboardFilter.month,
        ),
      ],
    );

    blocTest<LeaderboardCubit, StatisticsState>(
      'fetch emits StatisticsError after failed fetch',
      build: () {
        when(leaderboardRepository.getLeaderboard(any)).thenAnswer(
          (_) async => const Left(ServerFailure('some error')),
        );
        return statisticsCubit;
      },
      act: (cubit) => cubit.fetch(),
      expect: () => [
        const StatisticsError('some error', filter: LeaderboardFilter.month),
      ],
    );

    blocTest<LeaderboardCubit, StatisticsState>(
      'setFilter emits StatisticsLoading with correct filter and then emits StatisticsLoaded after successful fetch',
      build: () {
        when(leaderboardRepository.getLeaderboard(any))
            .thenAnswer((_) async => const Right([]));
        when(leaderboardRepository.getLeaderboardUser(any))
            .thenAnswer((_) async => const Right(dummyLeaderboardUser));
        return statisticsCubit;
      },
      act: (cubit) => cubit.setFilter(LeaderboardFilter.semester),
      expect: () => [
        const StatisticsLoading(filter: LeaderboardFilter.semester),
        const StatisticsLoaded(
          [dummyLeaderboardUser],
          filter: LeaderboardFilter.semester,
        ),
      ],
    );

    blocTest<LeaderboardCubit, StatisticsState>(
      'setFilter emits StatisticsLoading with correct filter and then emits StatisticsError after failed fetch',
      build: () {
        when(leaderboardRepository.getLeaderboard(any)).thenAnswer(
          (_) async => const Left(ServerFailure('some error')),
        );
        return statisticsCubit;
      },
      act: (cubit) => cubit.setFilter(LeaderboardFilter.total),
      expect: () => [
        const StatisticsLoading(filter: LeaderboardFilter.total),
        const StatisticsError('some error', filter: LeaderboardFilter.total),
      ],
    );

    tearDown(() {
      statisticsCubit.close();
    });
  });
}
