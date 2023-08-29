import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/contributor/domain/entities/contributor.dart';
import 'package:coffeecard/features/contributor/domain/usecases/fetch_contributors.dart';
import 'package:coffeecard/features/contributor/presentation/cubit/contributor_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'contributor_cubit_test.mocks.dart';

@GenerateMocks([FetchContributors])
void main() {
  late ContributorCubit cubit;
  late MockFetchContributors fetchContributors;

  setUp(() {
    fetchContributors = MockFetchContributors();
    cubit = ContributorCubit(fetchContributors: fetchContributors);

    provideDummy<Either<Failure, List<Contributor>>>(
      const Left(ConnectionFailure()),
    );
  });

  test('initial state is ContributorInitial', () {
    expect(cubit.state, const ContributorInitial());
  });

  group(
    'getContributors',
    () {
      const testContributors = [
        Contributor(
          name: 'name',
          avatarUrl: 'avatarUrl',
          githubUrl: 'githubUrl',
        ),
      ];
      blocTest(
        'should emit [Loaded] with data when use case succeeds',
        build: () => cubit,
        setUp: () => when(fetchContributors(any))
            .thenAnswer((_) async => const Right(testContributors)),
        act: (_) => cubit.getContributors(),
        expect: () => [
          const ContributorLoaded(testContributors),
        ],
      );

      blocTest(
        'should emit [Loaded] with empty list when use case fails',
        build: () => cubit,
        setUp: () => when(fetchContributors(any))
            .thenAnswer((_) async => const Left(ServerFailure('some error'))),
        act: (_) => cubit.getContributors(),
        expect: () => [
          const ContributorLoaded([]),
        ],
      );
    },
  );
}
