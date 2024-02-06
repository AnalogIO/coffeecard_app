import 'dart:convert';

import 'package:coffeecard/core/store/store.dart';
import 'package:coffeecard/features/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Crate<String>>(),
  MockSpec<Logger>(),
])
void main() {
  late AuthenticationRepository repo;
  late MockCrate crate;
  late MockLogger logger;

  setUp(() {
    crate = MockCrate();
    logger = MockLogger();
    repo = AuthenticationRepository(crate: crate, logger: logger);
  });

  const testAuthInfo = AuthenticationInfo(
    email: 'email',
    token: 'token',
    encodedPasscode: 'encodedPasscode',
  );
  provideDummy<Task<Unit>>(Task.of(unit));
  provideDummy<TaskOption<AuthenticationInfo>>(TaskOption.none());

  group('saveAuthenticationInfo', () {
    test(
      'GIVEN a valid authentication info '
      'WHEN saveAuthenticationInfo is called '
      'THEN the authentication info is stored and a log message is written',
      () async {
        // act
        await repo.saveAuthenticationInfo(testAuthInfo).run();

        // assert
        verifyInOrder([
          crate.put(any, json.encode(testAuthInfo.toJson())),
          logger.d(any),
        ]);
      },
    );
  });

  group('getAuthenticationInfo', () {
    test(
      'GIVEN a stored authentication info '
      'WHEN getAuthenticationInfo is called '
      'THEN the authentication info is returned',
      () {
        // arrange
        when(crate.get(any))
            .thenReturn(TaskOption.of(json.encode(testAuthInfo.toJson())));

        // act
        final actual = repo.getAuthenticationInfo().run();

        // assert
        expect(
          actual,
          completion(
            isA<Some<AuthenticationInfo>>().having(
              (some) => some.value,
              'AuthenticationInfo',
              testAuthInfo,
            ),
          ),
        );
      },
    );
    test(
      'GIVEN no stored authentication info '
      'WHEN getAuthenticationInfo is called '
      'THEN none is returned',
      () {
        // arrange
        when(crate.get(any)).thenReturn(TaskOption.none());

        // act
        final actual = repo.getAuthenticationInfo().run();

        // assert
        expect(actual, completion(isA<None>()));
      },
    );
  });

  group('getAuthenticationToken', () {
    test(
      'GIVEN a stored authentication info '
      'WHEN getAuthenticationToken is called '
      'THEN the authentication token is returned',
      () {
        // arrange
        when(crate.get(any))
            .thenReturn(TaskOption.of(json.encode(testAuthInfo.toJson())));

        // act
        final actual = repo.getAuthenticationToken().run();

        // assert
        expect(
          actual,
          completion(
            isA<Some<String>>().having(
              (some) => some.value,
              'Authentication token',
              testAuthInfo.token,
            ),
          ),
        );
      },
    );
    test(
      'GIVEN no stored authentication info '
      'WHEN getAuthenticationToken is called '
      'THEN none is returned',
      () {
        // arrange
        when(crate.get(any)).thenReturn(TaskOption.none());

        // act
        final actual = repo.getAuthenticationToken().run();

        // assert
        expect(actual, completion(isA<None>()));
      },
    );
  });

  group('clearAuthenticationInfo', () {
    test(
      'GIVEN a stored authentication info '
      'WHEN clearAuthenticationInfo is called '
      'THEN store.clear() is called and a log message is written',
      () async {
        // arrange
        when(crate.get(any))
            .thenReturn(TaskOption.of(json.encode(testAuthInfo.toJson())));

        // act
        await repo.clearAuthenticationInfo().run();

        // assert
        verify(crate.clear()).called(1);
        verify(logger.d(any)).called(1);
      },
    );
  });
}
