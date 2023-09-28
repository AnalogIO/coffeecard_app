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
  const emailKey = 'email';
  const tokenKey = 'authentication_token';
  const encodedPasscodeKey = 'encoded_passcode';

  late AuthenticationLocalDataSource secureStorage;
  late MockFlutterSecureStorage mockStorage;
  late MockLogger mockLogger;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    mockLogger = MockLogger();
    secureStorage =
        AuthenticationLocalDataSource(storage: mockStorage, logger: mockLogger);
  });

  group('saveAuthenticatedUser', () {
    test(
      'GIVEN user credentials '
      'WHEN saveAuthenticatedUser is called '
      'THEN it should save the user credentials to secure storage',
      () async {
        // arrange
        const user = AuthenticatedUserModel(
          email: 'test@example.com',
          token: 'token',
          encodedPasscode: 'encodedPasscode',
        );

        // act
        await secureStorage.saveAuthenticatedUser(user);

        // assert
        final jsonString = json.encode(user);

        verifyInOrder([
          mockStorage.write(key: emailKey, value: jsonString),
          mockLogger.d(any),
        ]);
      },
    );
  });

  group('getAuthenticatedUser', () {
    test(
      'GIVEN user credentials in secure storage '
      'WHEN getAuthenticatedUser is called '
      'THEN it should return the authenticated user',
      () async {
        // arrange
        const email = 'test@example.com';
        const token = 'token';

        when(mockStorage.read(key: emailKey)).thenAnswer((_) async => email);
        when(mockStorage.read(key: tokenKey)).thenAnswer((_) async => token);

        // act
        final actual = await secureStorage.getAuthenticatedUser();

        // assert
        expect(actual, isNotNull);
        expect(actual?.email, email);
        expect(actual?.token, token);
      },
    );
    test(
      'GIVEN missing token in secure storage '
      'WHEN getAuthenticatedUser is called '
      'THEN it should return null',
      () async {
        // arrange
        const email = 'test@example.com';

        // act
        when(mockStorage.read(key: emailKey)).thenAnswer((_) async => email);
        when(mockStorage.read(key: tokenKey)).thenAnswer((_) async => null);

        final actual = await secureStorage.getAuthenticatedUser();

        // assert
        expect(actual, isNull);
      },
    );
  });

  group('clearAuthenticatedUser', () {
    test(
      'GIVEN user credentials in secure storage '
      'WHEN clearAuthenticatedUser is called '
      'THEN it should remove the user credentials from secure storage',
      () async {
        // arrange
        when(mockStorage.read(key: emailKey))
            .thenAnswer((_) async => 'test@example.com');
        when(mockStorage.read(key: encodedPasscodeKey))
            .thenAnswer((_) async => 'encodedPasscode');
        when(mockStorage.read(key: tokenKey)).thenAnswer((_) async => 'token');

        // act
        await secureStorage.clearAuthenticatedUser();

        // assert
        verifyInOrder([
          mockStorage.delete(key: emailKey),
          mockStorage.delete(key: encodedPasscodeKey),
          mockStorage.delete(key: tokenKey),
          mockLogger.d(any),
        ]);
      },
    );

    test(
      'GIVEN missing email in secure storage '
      'WHEN clearAuthenticatedUser is called '
      'THEN it should not remove any user credentials',
      () async {
        // arrange
        when(mockStorage.read(key: emailKey)).thenAnswer((_) async => null);

        // act
        await secureStorage.clearAuthenticatedUser();

        // assert
        verifyInOrder([
          mockStorage.read(key: emailKey),
          mockStorage.read(key: tokenKey),
        ]);
        verifyNever(mockStorage.delete(key: anyNamed('key')));
      },
    );
  });

  group('updateToken', () {
    test(
      'GIVEN a new token '
      'WHEN updateToken is called '
      'THEN it should update the token in secure storage',
      () async {
        // arrange
        const token = 'new_token';

        // act
        await secureStorage.updateToken(token);

        // assert
        verify(mockStorage.write(key: tokenKey, value: token));
        verify(mockLogger.d('Token updated in Secure Storage'));
      },
    );
  });
}
