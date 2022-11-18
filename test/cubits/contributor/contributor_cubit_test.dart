import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/cubits/contributor/contributor_cubit.dart';
import 'package:coffeecard/data/repositories/external/contributor_repository.dart';
import 'package:coffeecard/data/repositories/utils/request_types.dart';
import 'package:coffeecard/models/contributor.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'contributor_cubit_test.mocks.dart';

const dummyContributors = [
  Contributor(
    name: 'name',
    avatarUrl: 'avatarUrl',
    githubUrl: 'githubUrl',
  ),
];

@GenerateMocks([ContributorRepository])
void main() {
  group('contributor cubit tests', () {
    late ContributorCubit contributorCubit;
    final repo = MockContributorRepository();

    setUp(() {
      contributorCubit = ContributorCubit(repo);
    });

    test('initial state is ContributorLoading', () {
      expect(contributorCubit.state, const ContributorLoading());
    });

    blocTest<ContributorCubit, ContributorState>(
      'getContributors emits Loading, Loaded when the repo returns a list of contributors',
      build: () {
        when(repo.getContributors())
            .thenAnswer((_) async => const Right(dummyContributors));
        return contributorCubit;
      },
      act: (cubit) => cubit.getContributors(),
      expect: () => [
        const ContributorLoading(),
        const ContributorLoaded(dummyContributors),
      ],
    );

    blocTest<ContributorCubit, ContributorState>(
      'getContributors emits Loading, Error when the repo returns an error',
      build: () {
        when(repo.getContributors()).thenAnswer(
          (_) async => Left(RequestHttpFailure('ERROR_MESSAGE', 0)),
        );
        return contributorCubit;
      },
      act: (cubit) => cubit.getContributors(),
      expect: () => [
        const ContributorLoading(),
        const ContributorError('ERROR_MESSAGE'),
      ],
    );

    tearDown(() {
      contributorCubit.close();
    });
  });
}
