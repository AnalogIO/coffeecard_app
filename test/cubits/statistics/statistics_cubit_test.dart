import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/cubits/statistics/statistics_cubit.dart';
import 'package:coffeecard/data/repositories/v1/leaderboard_repository.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'statistics_cubit_test.mocks.dart';

@GenerateMocks([LeaderboardRepository])
void main() {
  group('statistics cubit tests', () {
    late StatisticsCubit statisticsCubit;
    final _leaderboardRepository = MockLeaderboardRepository();

    setUp(() {
      statisticsCubit = StatisticsCubit(_leaderboardRepository);
    });

    blocTest<StatisticsCubit, StatisticsState>(
      'fetchLeaderboards emits correct states',
      build: () {
        when(_leaderboardRepository.getLeaderboard(any))
            .thenAnswer((_) => Future.value(const Right([])));
        return statisticsCubit;
      },
      act: (cubit) => cubit.fetchLeaderboards(),
      expect: () => [
        const StatisticsLoading(filterBy: StatisticsFilterCategory.month),
        const StatisticsLoaded(
          filterBy: StatisticsFilterCategory.month,
          leaderboard: [],
        )
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'refreshLeaderboards emits correct states',
      build: () {
        when(_leaderboardRepository.getLeaderboard(any))
            .thenAnswer((_) => Future.value(const Right([])));
        return statisticsCubit..fetchLeaderboards();
      },
      act: (cubit) => cubit.refreshLeaderboards(),
      expect: () => [
        const StatisticsLoaded(
          filterBy: StatisticsFilterCategory.month,
          leaderboard: [],
        )
      ],
    );

    blocTest<StatisticsCubit, StatisticsState>(
      'refreshLeaderboards fails assertion if fetchLeaderboards has not been called before',
      build: () {
        when(_leaderboardRepository.getLeaderboard(any))
            .thenAnswer((_) => Future.value(const Right([])));
        return statisticsCubit;
      },
      act: (cubit) => cubit.refreshLeaderboards(),
      errors: () => [isA<AssertionError>()],
    );

    tearDown(() {
      statisticsCubit.close();
    });
  });
}
