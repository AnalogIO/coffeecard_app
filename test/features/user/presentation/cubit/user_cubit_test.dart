import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/occupation/domain/entities/occupation.dart';
import 'package:coffeecard/features/user/domain/entities/role.dart';
import 'package:coffeecard/features/user/domain/entities/update_user.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:coffeecard/features/user/domain/usecases/get_user.dart';
import 'package:coffeecard/features/user/domain/usecases/request_account_deletion.dart';
import 'package:coffeecard/features/user/domain/usecases/update_user_details.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_cubit_test.mocks.dart';

@GenerateMocks([GetUser, UpdateUserDetails, RequestAccountDeletion])
void main() {
  late MockGetUser getUser;
  late MockUpdateUserDetails updateUserDetails;
  late MockRequestAccountDeletion requestAccountDeletion;
  late UserCubit cubit;

  setUp(() {
    getUser = MockGetUser();
    updateUserDetails = MockUpdateUserDetails();
    requestAccountDeletion = MockRequestAccountDeletion();
    cubit = UserCubit(
      getUser: getUser,
      updateUserDetails: updateUserDetails,
      requestAccountDeletion: requestAccountDeletion,
    );

    provideDummy<Either<Failure, User>>(
      const Left(ConnectionFailure()),
    );
    provideDummy<Either<Failure, Unit>>(
      const Left(ConnectionFailure()),
    );
  });

  const testUser = User(
    id: 0,
    name: 'name',
    email: 'email',
    privacyActivated: false,
    occupation: Occupation.empty(),
    rankMonth: 0,
    rankSemester: 0,
    rankTotal: 0,
    role: Role.customer,
  );

  group('fetchUserDetails', () {
    blocTest(
      'should emit [Loading, Error] when use case fails',
      build: () => cubit,
      setUp: () => when(getUser()).thenAnswer(
        (_) async => const Left(
          ServerFailure('some error', 500),
        ),
      ),
      act: (_) => cubit.fetchUserDetails(),
      expect: () => const [
        UserLoading(),
        UserError('some error'),
      ],
    );

    blocTest(
      'should emit [Loading, Loaded] when use case succeeds',
      build: () => cubit,
      setUp: () => when(getUser()).thenAnswer(
        (_) async => const Right(testUser),
      ),
      act: (_) => cubit.fetchUserDetails(),
      expect: () => const [
        UserLoading(),
        UserLoaded(testUser),
      ],
    );
  });

  group('initialize', () {
    blocTest(
      'should emit [Loading, InitiallyLoaded] when use case succeeds',
      build: () => cubit,
      setUp: () => when(getUser()).thenAnswer(
        (_) async => const Right(testUser),
      ),
      act: (_) => cubit.initialize(),
      expect: () => const [
        UserLoading(),
        UserInitiallyLoaded(testUser),
      ],
    );
  });

  group('updateUser', () {
    blocTest<UserCubit, UserState>(
      'should not update state if state is [Loading]',
      build: () => cubit,
      act: (_) => cubit.updateUser(const UpdateUser()),
      seed: () => const UserLoading(),
      expect: () => [],
    );

    blocTest<UserCubit, UserState>(
      'should not update state if state is [Error]',
      build: () => cubit,
      act: (_) => cubit.updateUser(const UpdateUser()),
      seed: () => const UserError('some error'),
      expect: () => [],
    );

    blocTest<UserCubit, UserState>(
      'should not update state if state is [Updating]',
      build: () => cubit,
      act: (_) => cubit.updateUser(const UpdateUser()),
      seed: () => const UserUpdating(testUser),
      expect: () => [],
    );

    blocTest<UserCubit, UserState>(
      'should emit [Updating, Error] if use case fails',
      build: () => cubit,
      setUp: () => when(
        updateUserDetails(
          email: anyNamed('email'),
          encodedPasscode: anyNamed('encodedPasscode'),
          name: anyNamed('name'),
          occupationId: anyNamed('occupationId'),
          privacyActivated: anyNamed('privacyActivated'),
        ),
      ).thenAnswer(
        (_) async => const Left(
          ServerFailure('some error', 500),
        ),
      ),
      act: (_) => cubit.updateUser(const UpdateUser()),
      seed: () => const UserLoaded(testUser),
      expect: () => const [
        UserUpdating(testUser),
        UserError('some error'),
      ],
    );

    blocTest<UserCubit, UserState>(
      'should emit [Updating, Loaded] if use case succeeds',
      build: () => cubit,
      setUp: () => when(
        updateUserDetails(
          email: anyNamed('email'),
          encodedPasscode: anyNamed('encodedPasscode'),
          name: anyNamed('name'),
          occupationId: anyNamed('occupationId'),
          privacyActivated: anyNamed('privacyActivated'),
        ),
      ).thenAnswer(
        (_) async => const Right(testUser),
      ),
      act: (_) => cubit.updateUser(const UpdateUser()),
      seed: () => const UserLoaded(testUser),
      expect: () => const [
        UserUpdating(testUser),
        UserLoaded(testUser),
      ],
    );
  });

  group('requestUserAccountDeletion', () {
    test('should call use case', () {
      // arrange
      when(requestAccountDeletion()).thenAnswer(
        (_) async => const Right(unit),
      );

      // act
      cubit.requestUserAccountDeletion();

      // assert
      verify(requestAccountDeletion());
    });
  });
}
