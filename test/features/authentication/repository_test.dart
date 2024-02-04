import 'package:coffeecard/features/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Box<AuthenticationInfo>>(), MockSpec<Logger>()])
void main() {
  late AuthenticationRepository repo;
  late MockBox store;
  late MockLogger logger;

  setUp(() {
    store = MockBox();
    logger = MockLogger();
    repo = AuthenticationRepository(store: store, logger: logger);
  });

  const testAuthInfo = AuthenticationInfo(
    email: 'email',
    token: 'token',
    encodedPasscode: 'encodedPasscode',
  );

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
          store.put(any, testAuthInfo),
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
        when(store.get(any)).thenAnswer((_) => testAuthInfo);

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
        when(store.get(any)).thenAnswer((_) => null);

        // act
        final actual = repo.getAuthenticationInfo().run();

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
        when(store.get(any)).thenAnswer((_) => testAuthInfo);

        // act
        await repo.clearAuthenticationInfo().run();

        // assert
        verify(store.clear()).called(1);
        verify(logger.d(any)).called(1);
      },
    );
  });
}
