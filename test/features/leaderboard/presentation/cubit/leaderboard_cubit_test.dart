import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/leaderboard/data/models/leaderboard_user_model.dart';
import 'package:coffeecard/features/leaderboard/domain/usecases/get_leaderboard.dart';
import 'package:coffeecard/features/leaderboard/presentation/cubit/leaderboard_cubit.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'leaderboard_cubit_test.mocks.dart';

@GenerateMocks([GetLeaderboard])
void main() {
  late MockGetLeaderboard getLeaderboard;
  late LeaderboardCubit cubit;

  setUp(() {
    getLeaderboard = MockGetLeaderboard();
    cubit = LeaderboardCubit(getLeaderboard: getLeaderboard);
  });

  const tLeaderboard = [
    LeaderboardUserModel(
      id: 0,
      name: 'name',
      score: 0,
      rank: 0,
      highlight: true,
    ),
  ];

  group('setFilter', () {
    blocTest(
      'should emit [LeaderboardLoading, LeaderboardLoaded] with correct filter',
      setUp: () => when(getLeaderboard(any))
          .thenAnswer((_) async => const Right(tLeaderboard)),
      build: () => cubit,
      act: (_) => cubit.setFilter(LeaderboardFilter.semester),
      expect: () => [
        const LeaderboardLoading(filter: LeaderboardFilter.semester),
        const LeaderboardLoaded(
          tLeaderboard,
          filter: LeaderboardFilter.semester,
        ),
      ],
    );

    blocTest(
      'should emit [LeaderboardLoading, LeaderboardError] with correct filter',
      setUp: () => when(getLeaderboard(any)).thenAnswer(
        (_) async => const Left(ServerFailure('some error')),
      ),
      build: () => cubit,
      act: (_) => cubit.setFilter(LeaderboardFilter.total),
      expect: () => [
        const LeaderboardLoading(filter: LeaderboardFilter.total),
        const LeaderboardError('some error', filter: LeaderboardFilter.total),
      ],
    );
  });

  group('loadLeaderboard', () {
    blocTest(
      'should emit [LeaderboardLoaded] when usecase succeeds',
      setUp: () => when(getLeaderboard(any))
          .thenAnswer((_) async => const Right(tLeaderboard)),
      build: () => cubit,
      act: (_) => cubit.loadLeaderboard(),
      expect: () => [
        const LeaderboardLoaded(
          tLeaderboard,
          filter: LeaderboardFilter.month,
        ),
      ],
    );

    blocTest<LeaderboardCubit, LeaderboardState>(
      'should emit [LeaderboardError] when usecase fails',
      setUp: () => when(getLeaderboard(any)).thenAnswer(
        (_) async => const Left(ServerFailure('some error')),
      ),
      build: () => cubit,
      act: (_) => cubit.loadLeaderboard(),
      expect: () => [
        const LeaderboardError('some error', filter: LeaderboardFilter.month),
      ],
    );
  });
}
