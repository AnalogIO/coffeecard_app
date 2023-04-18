import 'package:bloc_test/bloc_test.dart';
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/occupation/domain/entities/occupation.dart';
import 'package:coffeecard/features/user/domain/entities/role.dart';
import 'package:coffeecard/features/user/domain/entities/user.dart';
import 'package:coffeecard/features/user/domain/usecases/get_user.dart';
import 'package:coffeecard/features/user/domain/usecases/request_account_deletion.dart';
import 'package:coffeecard/features/user/domain/usecases/update_user_details.dart';
import 'package:coffeecard/features/user/presentation/cubit/user_cubit.dart';
import 'package:coffeecard/models/account/update_user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
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
  });

  const tUser = User(
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
      setUp: () => when(getUser(any)).thenAnswer(
        (_) async => const Left(
          ServerFailure('some error'),
        ),
      ),
      act: (_) => cubit.fetchUserDetails(),
      expect: () => [
        UserLoading(),
        UserError('some error'),
      ],
    );

    blocTest(
      'should emit [Loading, Loaded] when use case succeeds',
      build: () => cubit,
      setUp: () => when(getUser(any)).thenAnswer(
        (_) async => const Right(tUser),
      ),
      act: (_) => cubit.fetchUserDetails(),
      expect: () => [
        UserLoading(),
        UserLoaded(user: tUser),
      ],
    );
  });

  group('updateUser', () {
    blocTest<UserCubit, UserState>(
      'should not update state if state is [Loading]',
      build: () => cubit,
      act: (_) => cubit.updateUser(const UpdateUser()),
      seed: () => UserLoading(),
      expect: () => [],
    );

    blocTest<UserCubit, UserState>(
      'should not update state if state is [Error]',
      build: () => cubit,
      act: (_) => cubit.updateUser(const UpdateUser()),
      seed: () => UserError('some error'),
      expect: () => [],
    );

    blocTest<UserCubit, UserState>(
      'should not update state if state is [Updating]',
      build: () => cubit,
      act: (_) => cubit.updateUser(const UpdateUser()),
      seed: () => UserUpdating(user: tUser),
      expect: () => [],
    );

    blocTest<UserCubit, UserState>(
      'should emit [Updating, Error] if use case fails',
      build: () => cubit,
      setUp: () => when(updateUserDetails(any)).thenAnswer(
        (_) async => const Left(
          ServerFailure('some error'),
        ),
      ),
      act: (_) => cubit.updateUser(const UpdateUser()),
      seed: () => UserLoaded(user: tUser),
      expect: () => [
        UserUpdating(user: tUser),
        UserError('some error'),
      ],
    );

    blocTest<UserCubit, UserState>(
      'should emit [Updating, Loaded] if use case succeeds',
      build: () => cubit,
      setUp: () => when(updateUserDetails(any)).thenAnswer(
        (_) async => const Right(tUser),
      ),
      act: (_) => cubit.updateUser(const UpdateUser()),
      seed: () => UserLoaded(user: tUser),
      expect: () => [
        UserUpdating(user: tUser),
        UserLoaded(user: tUser),
      ],
    );
  });

  group('requestUserAccountDeletion', () {
    test('shoul call use case', () {
      // arrange
      when(requestAccountDeletion(any)).thenAnswer(
        (_) async => const Right(null),
      );

      // act
      cubit.requestUserAccountDeletion();

      // assert
      verify(requestAccountDeletion(any));
    });
  });
}
