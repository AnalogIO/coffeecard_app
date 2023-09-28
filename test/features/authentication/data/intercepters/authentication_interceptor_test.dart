import 'package:chopper/chopper.dart';
import 'package:coffeecard/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:coffeecard/features/authentication/data/intercepters/authentication_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'authentication_interceptor_test.mocks.dart';

@GenerateMocks([AuthenticationLocalDataSource])
void main() {
  test(
    'GIVEN a token in SecureStorage WHEN calling onRequest THEN Authorization Header is added to the request',
    () async {
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';

      final mockSecureStorage = MockAuthenticationLocalDataSource();
      when(mockSecureStorage.readToken())
          .thenAnswer((_) => Future<String>.value(token));

      final interceptor = AuthenticationInterceptor(mockSecureStorage);
      final request = Request('POST', Uri.parse('url'), Uri.parse('baseurl'));

      final result = await interceptor.onRequest(request);

      expect(result.headers.containsKey('Authorization'), isTrue);
      expect(result.headers['Authorization'], equals('Bearer $token'));
    },
  );

  test(
    'GIVEN no token in SecureStorage WHEN calling onRequest THEN no Authorization Header is added to the request',
    () async {
      final mockSecureStorage = MockAuthenticationLocalDataSource();
      when(mockSecureStorage.readToken()).thenAnswer((_) async => null);

      final interceptor = AuthenticationInterceptor(mockSecureStorage);
      final request = Request('POST', Uri.parse('url'), Uri.parse('baseurl'));

      final result = await interceptor.onRequest(request);

      expect(result.headers.containsKey('Authorization'), isFalse);
    },
  );
}
