import 'dart:convert';

import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/occupation/data/models/occupation_model.dart';
import 'package:coffeecard/features/user/data/datasources/user_remote_data_source.dart';
import 'package:coffeecard/features/user/data/models/user_model.dart';
import 'package:coffeecard/features/user/domain/entities/role.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/account/update_user.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_remote_data_source_test.mocks.dart';

@GenerateMocks([CoffeecardApiV2, NetworkRequestExecutor])
void main() {
  late MockCoffeecardApiV2 apiV2;
  late MockNetworkRequestExecutor executor;
  late UserRemoteDataSource dataSource;

  setUp(() {
    apiV2 = MockCoffeecardApiV2();
    executor = MockNetworkRequestExecutor();
    dataSource = UserRemoteDataSource(
      apiV2: apiV2,
      executor: executor,
    );
  });

  const testUserModel = UserModel(
    id: 0,
    name: 'name',
    email: 'email',
    privacyActivated: false,
    occupation: OccupationModel(
      id: 0,
      shortName: 'shortName',
      fullName: 'fullName',
    ),
    rankMonth: 0,
    rankSemester: 0,
    rankTotal: 0,
    role: Role.customer,
  );

  group('getUser', () {
    test('should return [Left] if executor returns [Left]', () async {
      // arrange
      when(executor.call<UserResponse>(any)).thenAnswer(
        (_) async => const Left(ServerFailure('some error')),
      );

      // act
      final actual = await dataSource.getUser();

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });

    test('should return [Right<UserModel>] executor succeeds', () async {
      // arrange
      when(executor.call<UserResponse>(any)).thenAnswer(
        (_) async => Right(
          UserResponse(
            id: 0,
            email: 'email',
            name: 'name',
            privacyActivated: false,
            programme: json.decode(
              '{"id":0, "shortName": "shortName", "fullName": "fullName"}',
            ),
            rankAllTime: 0,
            rankMonth: 0,
            rankSemester: 0,
            role: 'Customer',
          ),
        ),
      );

      // act
      final actual = await dataSource.getUser();

      // assert
      expect(actual, const Right(testUserModel));
    });
  });

  group('updateUserDetails', () {
    test('should return [Left] if executor returns [Left]', () async {
      // arrange
      when(executor.call<UserResponse>(any)).thenAnswer(
        (_) async => const Left(ServerFailure('some error')),
      );

      // act
      final actual = await dataSource.updateUserDetails(const UpdateUser());

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });

    test('should return [UserModel] if api call succeeds', () async {
      // arrange
      when(executor.call<UserResponse>(any)).thenAnswer(
        (_) async => Right(
          UserResponse(
            id: 0,
            email: 'email',
            name: 'name',
            privacyActivated: false,
            programme: json.decode(
              '{"id":0, "shortName": "shortName", "fullName": "fullName"}',
            ),
            rankAllTime: 0,
            rankMonth: 0,
            rankSemester: 0,
            role: 'Customer',
          ),
        ),
      );

      // act
      final actual = await dataSource.updateUserDetails(const UpdateUser());

      // assert
      expect(actual, const Right(testUserModel));
    });
  });

  group('requestAccountDeletion', () {
    test('should return [Right<void>] if executor succeeds', () async {
      // arrange
      when(executor.call(any)).thenAnswer(
        (_) async => const Right(null),
      );

      // act
      final actual = await dataSource.requestAccountDeletion();

      // assert
      expect(actual, const Right(null));
    });

    test('should return [Left] if executor fails', () async {
      // arrange
      when(executor.call(any)).thenAnswer(
        (_) async => const Left(ServerFailure('some error')),
      );

      // act
      final actual = await dataSource.requestAccountDeletion();

      // assert
      expect(actual, const Left(ServerFailure('some error')));
    });
  });
}
