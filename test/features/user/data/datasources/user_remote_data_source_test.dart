import 'dart:convert';

import 'package:coffeecard/core/errors/exceptions.dart';
import 'package:coffeecard/features/occupation/data/models/occupation_model.dart';
import 'package:coffeecard/features/user/data/datasources/user_remote_data_source.dart';
import 'package:coffeecard/features/user/data/models/user_model.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart';
import 'package:coffeecard/models/account/update_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../response.dart';
import 'user_remote_data_source_test.mocks.dart';

@GenerateMocks([CoffeecardApi, CoffeecardApiV2])
void main() {
  late MockCoffeecardApi apiV1;
  late MockCoffeecardApiV2 apiV2;
  late UserRemoteDataSource dataSource;

  setUp(() {
    apiV1 = MockCoffeecardApi();
    apiV2 = MockCoffeecardApiV2();
    dataSource = UserRemoteDataSourceImpl(apiV1: apiV1, apiV2: apiV2);
  });

  const tUserModel = UserModel(
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
  );

  group('getUser', () {
    test('should throw [ServerException] if api call fails', () async {
      // arrange
      when(apiV2.apiV2AccountGet()).thenAnswer(
        (_) async => Response.fromStatusCode(500),
      );

      // act
      final call = dataSource.getUser;

      // assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });

    test('should return [UserModel] if api call succeeds', () async {
      // arrange
      when(apiV2.apiV2AccountGet()).thenAnswer(
        (_) async => Response.fromStatusCode(
          200,
          body: UserResponse(
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
          ),
        ),
      );

      // act
      final actual = await dataSource.getUser();

      // assert
      expect(actual, tUserModel);
    });
  });

  group('updateUserDetails', () {
    test('should throw [ServerException] if api call fails', () async {
      // arrange
      when(apiV2.apiV2AccountPut(body: anyNamed('body'))).thenAnswer(
        (_) async => Response.fromStatusCode(500),
      );

      // act
      final call = dataSource.updateUserDetails;

      // assert
      expect(
        () => call(const UpdateUser()),
        throwsA(const TypeMatcher<ServerException>()),
      );
    });

    test('should return [UserModel] if api call succeeds', () async {
      // arrange
      when(apiV2.apiV2AccountPut(body: anyNamed('body'))).thenAnswer(
        (_) async => Response.fromStatusCode(
          200,
          body: UserResponse(
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
          ),
        ),
      );

      // act
      final actual = await dataSource.updateUserDetails(const UpdateUser());

      // assert
      expect(actual, tUserModel);
    });
  });

  group('requestAccountDeletion', () {
    test('should throw [ServerException] if api call fails', () async {
      // arrange
      when(apiV2.apiV2AccountDelete()).thenAnswer(
        (_) async => Response.fromStatusCode(500),
      );

      // act
      final call = dataSource.requestAccountDeletion;

      // assert
      expect(
        () => call(),
        throwsA(const TypeMatcher<ServerException>()),
      );
    });
  });
}
