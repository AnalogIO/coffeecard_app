import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/core/network/network_request_executor.dart';
import 'package:coffeecard/features/authentication/domain/entities/authenticated_user.dart';
import 'package:coffeecard/features/login/data/datasources/account_remote_data_source.dart';
import 'package:coffeecard/features/occupation/data/models/occupation_model.dart';
import 'package:coffeecard/features/user/data/models/user_model.dart';
import 'package:coffeecard/features/user/domain/entities/role.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart' as v1;
import 'package:coffeecard/generated/api/coffeecard_api_v2.swagger.dart' as v2;
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'account_remote_data_source_test.mocks.dart';

@GenerateMocks([
  v1.CoffeecardApi,
  v2.CoffeecardApiV2,
  NetworkRequestExecutor,
])
void main() {
  late MockCoffeecardApi apiV1;
  late MockCoffeecardApiV2 apiV2;
  late MockNetworkRequestExecutor executor;
  late AccountRemoteDataSource dataSource;

  setUp(() {
    apiV1 = MockCoffeecardApi();
    apiV2 = MockCoffeecardApiV2();

    executor = MockNetworkRequestExecutor();
    dataSource = AccountRemoteDataSource(
      apiV1: apiV1,
      apiV2: apiV2,
      executor: executor,
    );

    provideDummy<Either<NetworkFailure, v1.TokenDto>>(
      const Left(ConnectionFailure()),
    );
    provideDummy<Either<NetworkFailure, v2.UserResponse>>(
      const Left(ConnectionFailure()),
    );
    provideDummy<Either<NetworkFailure, Unit>>(
      const Left(ConnectionFailure()),
    );
    provideDummy<Either<NetworkFailure, v2.EmailExistsResponse>>(
      const Left(ConnectionFailure()),
    );
  });

  const testError = 'some error';

  group('login', () {
    test(
      'should return [Right<AuthenticatedUser>] when executor returns token',
      () async {
        // arrange
        when(executor.execute<v1.TokenDto>(any)).thenAnswer(
          (_) async => Right(v1.TokenDto(token: 'token')),
        );

        // act
        final actual = await dataSource.login('email', 'encodedPasscode');

        // assert
        expect(
          actual,
          const Right(AuthenticatedUser(email: 'email', token: 'token')),
        );
      },
    );
  });

  group('getUser', () {
    test('should return [Left] if executor fails', () async {
      // arrange
      when(executor.execute<v2.UserResponse>(any))
          .thenAnswer((_) async => const Left(ServerFailure(testError, 500)));

      // act
      final actual = await dataSource.getUser();

      // assert
      expect(actual, const Left(ServerFailure(testError, 500)));
    });

    test(
      'should return [Right<UserModel>] when executor returns user response',
      () async {
        // arrange
        when(executor.execute<v2.UserResponse>(any)).thenAnswer(
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
        final actual = await dataSource.getUser();

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
      },
    );
  });

  group('requestPasscodeReset', () {
    test('should return [Right] when executor succeeds', () async {
      // arrange
      when(executor.executeAndDiscard(any)).thenAnswer(
        (_) async => const Right(unit),
      );

      // act
      final actual = await dataSource.requestPasscodeReset('name');

      // assert
      expect(actual.isRight(), true);
    });
  });

  group('emailExists', () {
    test('should return [Right<bool>] if executor succeeds', () async {
      // arrange
      when(executor.execute<v2.EmailExistsResponse>(any)).thenAnswer(
        (_) async => Right(v2.EmailExistsResponse(emailExists: true)),
      );

      // act
      final actual = await dataSource.emailExists('name');

      // assert
      expect(actual, const Right(true));
    });
  });
}
