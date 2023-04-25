import 'contributor_cubit_test.mocks.dart';

@GenerateMocks([FetchContributors])
void main() {
  late ContributorCubit cubit;
  late MockFetchContributors fetchContributors;

  setUp(() {
    fetchContributors = MockFetchContributors();
    contributorCubit = ContributorCubit(fetchContributors: fetchContributors);
  });

  test('initial state is ContributorLoaded', () {
    expect(contributorCubit.state, const ContributorLoaded([]));
  });

  group(
    'getContributors',
    () {
      const tContributors = [
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
            .thenAnswer((_) async => Right(tContributors)),
        act: (_) => cubit.getContributors(),
        expect: () => [
          const ContributorLoaded(tContributors),
        ],
      );

      blocTest(
        'should emit [Loaded] with empty list when use case fails',
        build: () => cubit,
        setUp: () => when(fetchContributors(any))
            .thenAnswer((_) async => Left(ServerFailure('some error'))),
        act: (_) => cubit.getContributors(),
        expect: () => [
          const ContributorLoaded([]),
        ],
      );
    },
  );
}
