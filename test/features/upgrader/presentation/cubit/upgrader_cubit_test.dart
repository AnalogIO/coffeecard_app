import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/features/upgrader/domain/usecases/can_upgrade.dart';
import 'package:coffeecard/features/upgrader/presentation/cubit/upgrader_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'upgrader_cubit_test.mocks.dart';

@GenerateMocks([CanUpgrade])
void main() {
  late UpgraderCubit cubit;
  late MockCanUpgrade canUpgrade;

  setUp(() {
    canUpgrade = MockCanUpgrade();
    cubit = UpgraderCubit(canUpgrade: canUpgrade);

    provideDummy<Option<bool>>(none());
  });

  group('load', () {
    test('initial state should be [Loading]', () {
      expect(cubit.state, const UpgraderLoading());
    });

    blocTest(
      'should emit [Loaded<false>] when use case fails',
      build: () => cubit,
      setUp: () => when(canUpgrade()).thenAnswer((_) async => none()),
      act: (_) => cubit.load(),
      expect: () => [const UpgraderLoaded(canUpgrade: false)],
    );

    blocTest(
      'should emit [Loaded] when use case succeeds',
      build: () => cubit,
      setUp: () => when(canUpgrade()).thenAnswer((_) async => some(true)),
      act: (_) => cubit.load(),
      expect: () => [const UpgraderLoaded(canUpgrade: true)],
    );
  });
}
