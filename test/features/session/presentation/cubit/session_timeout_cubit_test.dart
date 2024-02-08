import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/features/session/domain/entities/session_details.dart';
import 'package:coffeecard/features/session/domain/usecases/get_session_details.dart';
import 'package:coffeecard/features/session/domain/usecases/save_session_details.dart';
import 'package:coffeecard/features/session/presentation/cubit/session_timeout_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'session_timeout_cubit_test.mocks.dart';

@GenerateMocks([GetSessionDetails, SaveSessionDetails])
void main() {
  late SessionTimeoutCubit cubit;
  late MockGetSessionDetails getSessionDetails;
  late MockSaveSessionDetails saveSessionDetails;

  setUp(() {
    getSessionDetails = MockGetSessionDetails();
    saveSessionDetails = MockSaveSessionDetails();
    cubit = SessionTimeoutCubit(
      saveSessionDetails: saveSessionDetails,
      getSessionDetails: getSessionDetails,
      entries: [],
    );

    provideDummy<Option<SessionDetails>>(none());
  });

  SessionTimeoutCubit cubitWithData(List<SessionTimeout> entries) {
    // ignore: join_return_with_assignment
    cubit = SessionTimeoutCubit(
      saveSessionDetails: saveSessionDetails,
      getSessionDetails: getSessionDetails,
      entries: entries,
    );
    return cubit;
  }

  const SessionTimeout defaultTimeout = ('default', null);

  group('selected', () {
    test(
      'should return selected value if state is [Loaded]',
      () {
        // arrange
        const selected = ('selected', Duration(days: 2));
        final entries = [selected];

        cubit.emit(SessionTimeoutLoaded(entries: entries, selected: selected));

        // act
        final actual = cubit.selected();

        // assert
        expect(actual, selected);
      },
    );

    test('should return default value if state is [Loading]', () {
      // arrange
      final entries = [defaultTimeout];

      cubit = cubitWithData(entries);

      // act
      final actual = cubit.selected();

      // assert
      expect(actual, defaultTimeout);
    });
  });

  group('load', () {
    blocTest(
      'should emit [Loaded] with default value if user has no session details',
      build: () => cubitWithData([defaultTimeout]),
      setUp: () => when(getSessionDetails()).thenAnswer((_) async => none()),
      act: (_) => cubit.load(),
      expect: () => [
        const SessionTimeoutLoaded(
          entries: [defaultTimeout],
          selected: defaultTimeout,
        ),
      ],
    );

    blocTest(
      'should emit [Loaded] with users selected value',
      build: () => cubitWithData([('selected', const Duration(days: 2))]),
      setUp: () => when(getSessionDetails()).thenAnswer(
        (_) async => some(
          SessionDetails(
            sessionTimeout: some(const Duration(days: 2)),
            lastLogin: none(),
          ),
        ),
      ),
      act: (_) => cubit.load(),
      expect: () => [
        const SessionTimeoutLoaded(
          entries: [('selected', Duration(days: 2))],
          selected: ('selected', Duration(days: 2)),
        ),
      ],
    );
  });

  group('setSelected', () {
    blocTest(
      'should emit [Loading, Loaded] with selected timeout',
      build: () => cubitWithData([defaultTimeout]),
      setUp: () => when(getSessionDetails()).thenAnswer((_) async => none()),
      act: (_) => cubit.setSelected(defaultTimeout),
      expect: () => [
        const SessionTimeoutLoading(entries: [defaultTimeout]),
        const SessionTimeoutLoaded(
          entries: [defaultTimeout],
          selected: defaultTimeout,
        ),
      ],
    );

    test('should save selected timeout', () async {
      // arrange
      const selected = ('2 Days', Duration(days: 2));

      cubit = cubitWithData([defaultTimeout, selected]);

      final sessionTimeout = some(selected.$2);
      final lastLogin = some(DateTime(2023));

      when(getSessionDetails()).thenAnswer(
        (_) async => some(
          SessionDetails(
            sessionTimeout: sessionTimeout,
            lastLogin: lastLogin,
          ),
        ),
      );
      when(
        saveSessionDetails(
          lastLogin: anyNamed('lastLogin'),
          sessionTimeout: anyNamed('sessionTimeout'),
        ),
      );

      // act
      await cubit.setSelected(selected);

      // assert
      verify(
        saveSessionDetails(
          lastLogin: lastLogin,
          sessionTimeout: sessionTimeout,
        ),
      );
    });
  });
}
