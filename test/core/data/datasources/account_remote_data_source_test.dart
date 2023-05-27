import 'package:coffeecard/core/data/datasources/account_remote_data_source.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/occupation/data/models/occupation_model.dart';
import 'package:coffeecard/features/user/data/models/user_model.dart';
import 'package:coffeecard/features/user/domain/entities/role.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart' as v1;
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart' as v2;
import 'package:coffeecard/models/account/authenticated_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'account_remote_data_source_test.mocks.dart';

@GenerateMocks([v1.CoffeecardApi, v2.CoffeecardApiV2, NetworkRequestExecutor])
void main() {
  late MockCoffeecardApi apiV1;
  late MockCoffeecardApiV2 apiV2;
  late MockNetworkRequestExecutor executor;
  late AccountRemoteDataSource repository;

  setUp(() {
    apiV1 = MockCoffeecardApi();
    apiV2 = MockCoffeecardApiV2();

    executor = MockNetworkRequestExecutor();
    repository = AccountRemoteDataSource(
      apiV1: apiV1,
      apiV2: apiV2,
      executor: executor,
    );
  });

  group('register', () {
    test('should call executor', () async {
      // arrange
      when(executor.call<v2.MessageResponseDto>(any)).thenAnswer(
        (_) async => Right(v2.MessageResponseDto()),
      );

      // act
      await repository.register(
        'name',
        'email',
        'passcode',
        0,
      );

      // assert
      verify(executor.call(any));
    });
  });

  group('login', () {
    test('should call executor', () async {
      // arrange
      when(executor.call<v1.TokenDto>(any)).thenAnswer(
        (_) async => Right(v1.TokenDto(token: 'token')),
      );

      // act
      final actual = await repository.login('email', 'encodedPasscode');

      // assert
      expect(
        actual,
        const Right(AuthenticatedUser(email: 'email', token: 'token')),
      );
    });
  });

  group('getUser', () {
    test('should call executor', () async {
      // arrange
      when(executor.call<v2.UserResponse>(any)).thenAnswer(
        (_) async => Right(
          v2.UserResponse(
            email: 'email',
            id: 0,
            name: 'name',
            privacyActivated: true,
            programme: {
              'id': 0,
              'shortName': 'shortName',
              'fullName': 'fullName',
            },
            rankAllTime: 0,
            rankMonth: 0,
            rankSemester: 0,
            role: 'Barista',
          ),
        ),
      );

      // act
      final actual = await repository.getUser();

      // assert
      expect(
        actual,
        const Right(
          UserModel(
            id: 0,
            name: 'name',
            email: 'email',
            privacyActivated: true,
            occupation: OccupationModel(
              id: 0,
              shortName: 'shortName',
              fullName: 'fullName',
            ),
            rankMonth: 0,
            rankSemester: 0,
            rankTotal: 0,
            role: Role.barista,
          ),
        ),
      );
    });
  });

  group('requestPasscodeReset', () {
    test('should call executor', () async {
      // arrange
      when(executor.call<v1.MessageResponseDto>(any)).thenAnswer(
        (_) async => Right(v1.MessageResponseDto()),
      );

      // act
      final actual = await repository.requestPasscodeReset('name');

      // assert
      expect(actual, const Right(null));
    });
  });

  group('emailExists', () {
    test('should call executor', () async {
      // arrange
      when(executor.call<v2.EmailExistsResponse>(any)).thenAnswer(
        (_) async => Right(v2.EmailExistsResponse(emailExists: true)),
      );

      // act
      final actual = await repository.emailExists('name');

      // assert
      expect(actual, const Right(true));
    });
  });
}
