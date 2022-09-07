import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/data/repositories/v1/leaderboard_repository.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'statistics_cubit_test.mocks.dart';

@GenerateMocks([LeaderboardRepository])
void main() {
  group('statistics cubit tests', () {
    late StatisticsCubit statisticsCubit;
    final leaderboardRepository = MockLeaderboardRepository();

    setUp(() {
      statisticsCubit = StatisticsCubit(leaderboardRepository);
    });

    blocTest<StatisticsCubit, StatisticsState>(
      'fetch emits StatisticsLoaded after successful fetch',
      build: () {
        when(leaderboardRepository.getLeaderboard(any))
            .thenAnswer((_) async => const Right([]));
        return statisticsCubit;
      },
      act: (cubit) => cubit.fetch(),
      expect: () => [
        const StatisticsLoaded([], filter: LeaderboardFilter.month),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'fetch emits StatisticsError after failed fetch',
      build: () {
        when(leaderboardRepository.getLeaderboard(any))
            .thenAnswer((_) async => const Left(ApiError('ERROR_MESSAGE')));
        return statisticsCubit;
      },
      act: (cubit) => cubit.fetch(),
      expect: () => [
        const StatisticsError('ERROR_MESSAGE', filter: LeaderboardFilter.month),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'setFilter emits StatisticsLoading with correct filter and then emits StatisticsLoaded after successful fetch',
      build: () {
        when(leaderboardRepository.getLeaderboard(any))
            .thenAnswer((_) async => const Right([]));
        return statisticsCubit;
      },
      act: (cubit) => cubit.setFilter(LeaderboardFilter.semester),
      expect: () => [
        const StatisticsLoading(filter: LeaderboardFilter.semester),
        const StatisticsLoaded([], filter: LeaderboardFilter.semester),
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'setFilter emits StatisticsLoading with correct filter and then emits StatisticsError after failed fetch',
      build: () {
        when(leaderboardRepository.getLeaderboard(any))
            .thenAnswer((_) async => const Left(ApiError('ERROR_MESSAGE')));
        return statisticsCubit;
      },
      act: (cubit) => cubit.setFilter(LeaderboardFilter.total),
      expect: () => [
        const StatisticsLoading(filter: LeaderboardFilter.total),
        const StatisticsError('ERROR_MESSAGE', filter: LeaderboardFilter.total),
      ],
    );

    tearDown(() {
      statisticsCubit.close();
    });
  });
}
