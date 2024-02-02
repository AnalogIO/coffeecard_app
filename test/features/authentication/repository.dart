import 'package:coffeecard/features/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'repository.mocks.dart';

@GenerateNiceMocks([MockSpec<Box<AuthenticationInfo>>(), MockSpec<Logger>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthenticationRepository repo;
  late MockBox store;
  late MockLogger logger;

  setUp(() {
    store = MockBox();
    logger = MockLogger();
    repo = AuthenticationRepository(store: store, logger: logger);
  });

  const authenticationInfo = AuthenticationInfo(
    email: 'email',
    token: 'token',
    encodedPasscode: 'encodedPasscode',
  );

  group('saveAuthenticationInfo', () {
    test(
      'should save user object',
      () async {
        // arrange

        // act
        await repo.saveAuthenticationInfo(authenticationInfo).run();

        // assert
        verifyInOrder([
          store.put(any, authenticationInfo),
          logger.d(any),
        ]);
      },
    );
  });

  group('getAuthenticationInfo', () {
    test(
      'should return user when storage contains key',
      () async {
        // arrange
        when(store.get(any)).thenAnswer((_) => authenticationInfo);

        // act
        final actual = await repo.getAuthenticationInfo().run();

        // assert
        expect(actual.isSome(), true);

        actual.match(
          () {},
          (actual) {
            expect(actual.email, authenticationInfo.email);
            expect(actual.token, authenticationInfo.token);
            expect(actual.encodedPasscode, authenticationInfo.encodedPasscode);
          },
        );
      },
    );
    test(
      'should return none when storage does not contains key',
      () async {
        // arrange
        when(store.get(any)).thenAnswer((_) => null);

        // act
        final actual = await repo.getAuthenticationInfo().run();

        // assert
        expect(actual, none());
      },
    );
  });

  group('clearAuthenticationInfo', () {
    test(
      'should delete key',
      () async {
        // act
        await repo.clearAuthenticationInfo().run();

        // assert
        verify(store.clear());
      },
    );
  });
}
