import 'dart:convert';

import 'package:coffeecard/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:coffeecard/features/authentication/data/models/authenticated_user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'authentication_local_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FlutterSecureStorage>(), MockSpec<Logger>()])
void main() {
  late AuthenticationLocalDataSource dataSource;
  late MockFlutterSecureStorage storage;
  late MockLogger logger;

  setUp(() {
    storage = MockFlutterSecureStorage();
    logger = MockLogger();
    dataSource =
        AuthenticationLocalDataSource(storage: storage, logger: logger);
  });

  const user = AuthenticatedUserModel(
    email: 'email',
    token: 'token',
    encodedPasscode: 'encodedPasscode',
  );

  group('saveAuthenticatedUser', () {
    test(
      'should save user object',
      () async {
        // arrange

        // act
        await dataSource.saveAuthenticatedUser(user);

        // assert
        final jsonString = json.encode(user);

        verifyInOrder([
          storage.write(key: anyNamed('key'), value: jsonString),
          logger.d(any),
        ]);
      },
    );
  });

  group('getAuthenticatedUser', () {
    test(
      'should return user when storage contains key',
      () async {
        // arrange
        when(storage.read(key: anyNamed('key')))
            .thenAnswer((_) async => json.encode(user));

        // act
        final actual = await dataSource.getAuthenticatedUser();

        // assert
        expect(actual!.email, user.email);
        expect(actual.token, user.token);
        expect(actual.encodedPasscode, user.encodedPasscode);
      },
    );
    test(
      'should return null when storage does not contains key',
      () async {
        // arrange
        when(storage.read(key: anyNamed('key'))).thenAnswer((_) async => null);

        // act
        final actual = await dataSource.getAuthenticatedUser();

        // assert
        expect(actual, isNull);
      },
    );
  });

  group('clearAuthenticatedUser', () {
    test(
      'should delete key',
      () async {
        // act
        await dataSource.clearAuthenticatedUser();

        // assert
        verify(storage.delete(key: anyNamed('key')));
      },
    );
  });

  group('updateToken', () {
    test(
      'should update token in storage',
      () async {
        // arrange
        const token = 'new_token';
        when(storage.read(key: anyNamed('key')))
            .thenAnswer((_) async => json.encode(user));

        // act
        await dataSource.updateToken(token);

        // assert
        const expected = AuthenticatedUserModel(
          email: 'email',
          token: token,
          encodedPasscode: 'encodedPasscode',
        );

        verify(
          storage.write(key: anyNamed('key'), value: json.encode(expected)),
        );
      },
    );
  });
}
