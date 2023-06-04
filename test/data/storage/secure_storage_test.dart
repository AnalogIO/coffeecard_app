import 'package:coffeecard/data/storage/secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'secure_storage_test.mocks.dart';

@GenerateNiceMocks([MockSpec<FlutterSecureStorage>(), MockSpec<Logger>()])
void main() {
  group('SecureStorage', () {
    const emailKey = 'email';
    const tokenKey = 'authentication_token';
    const encodedPasscodeKey = 'encoded_passcode';

    late SecureStorage secureStorage;
    late MockFlutterSecureStorage mockStorage;
    late MockLogger mockLogger;

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      mockLogger = MockLogger();
      secureStorage = SecureStorage(storage: mockStorage, logger: mockLogger);
    });

    test(
      'GIVEN user credentials '
      'WHEN saveAuthenticatedUser is called '
      'THEN it should save the user credentials to secure storage',
      () async {
        const email = 'test@example.com';
        const encodedPasscode = 'encodedPasscode';
        const token = 'token';

        await secureStorage.saveAuthenticatedUser(
          email,
          encodedPasscode,
          token,
        );

        verifyInOrder([
          mockStorage.write(key: emailKey, value: email),
          mockStorage.write(key: encodedPasscodeKey, value: encodedPasscode),
          mockStorage.write(key: tokenKey, value: token),
          mockLogger.d(any),
        ]);
      },
    );

    test(
      'GIVEN user credentials in secure storage '
      'WHEN getAuthenticatedUser is called '
      'THEN it should return the authenticated user',
      () async {
        const email = 'test@example.com';
        const token = 'token';

        when(mockStorage.read(key: emailKey)).thenAnswer((_) async => email);
        when(mockStorage.read(key: tokenKey)).thenAnswer((_) async => token);

        final user = await secureStorage.getAuthenticatedUser();

        expect(user, isNotNull);
        expect(user?.email, email);
        expect(user?.token, token);
      },
    );

    test(
      'GIVEN missing token in secure storage '
      'WHEN getAuthenticatedUser is called '
      'THEN it should return null',
      () async {
        const email = 'test@example.com';

        when(mockStorage.read(key: emailKey)).thenAnswer((_) async => email);
        when(mockStorage.read(key: tokenKey)).thenAnswer((_) async => null);

        final user = await secureStorage.getAuthenticatedUser();

        expect(user, isNull);
      },
    );

    test(
      'GIVEN user credentials in secure storage '
      'WHEN clearAuthenticatedUser is called '
      'THEN it should remove the user credentials from secure storage',
      () async {
        when(mockStorage.read(key: emailKey))
            .thenAnswer((_) async => 'test@example.com');
        when(mockStorage.read(key: encodedPasscodeKey))
            .thenAnswer((_) async => 'encodedPasscode');
        when(mockStorage.read(key: tokenKey)).thenAnswer((_) async => 'token');

        await secureStorage.clearAuthenticatedUser();

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
        when(mockStorage.read(key: emailKey)).thenAnswer((_) async => null);

        await secureStorage.clearAuthenticatedUser();

        verifyInOrder([
          mockStorage.read(key: emailKey),
          mockStorage.read(key: tokenKey),
        ]);
        verifyNever(mockStorage.delete(key: anyNamed('key')));
      },
    );

    test(
      'GIVEN a new token '
      'WHEN updateToken is called '
      'THEN it should update the token in secure storage',
      () async {
        const token = 'new_token';

        await secureStorage.updateToken(token);

        verify(mockStorage.write(key: tokenKey, value: token));
        verify(mockLogger.d('Token updated in Secure Storage'));
      },
    );

    test(
      'GIVEN email stored in secure storage '
      'WHEN readEmail is called '
      'THEN it should return the email',
      () async {
        const email = 'test@example.com';

        when(mockStorage.read(key: emailKey)).thenAnswer((_) async => email);

        final result = await secureStorage.readEmail();

        expect(result, email);
      },
    );

    test(
      'GIVEN encoded passcode stored in secure storage '
      'WHEN readEncodedPasscode is called '
      'THEN it should return the encoded passcode',
      () async {
        const encodedPasscode = 'encodedPasscode';

        when(mockStorage.read(key: encodedPasscodeKey))
            .thenAnswer((_) async => encodedPasscode);

        final result = await secureStorage.readEncodedPasscode();

        expect(result, encodedPasscode);
      },
    );

    test(
      'GIVEN token stored in secure storage '
      'WHEN readToken is called '
      'THEN it should return the token',
      () async {
        const token = 'token';

        when(mockStorage.read(key: tokenKey)).thenAnswer((_) async => token);

        final result = await secureStorage.readToken();

        expect(result, token);
      },
    );
  });
}
