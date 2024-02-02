import 'package:chopper/chopper.dart';
import 'package:coffeecard/features/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'authentication_interceptor_test.mocks.dart';

@GenerateMocks([AuthenticationRepository])
void main() {
  late MockAuthenticationRepository repo;
  late AuthenticationInterceptor interceptor;
  late Request request;

  setUp(() async {
    provideDummy<TaskOption<AuthenticationInfo>>(TaskOption.none());

    repo = MockAuthenticationRepository();
    interceptor = AuthenticationInterceptor(repo);
    request = Request('POST', Uri.parse('url'), Uri.parse('baseurl'));
  });

  test(
    'GIVEN a token in SecureStorage '
    'WHEN calling onRequest '
    'THEN Authorization Header is added to the request',
    () async {
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';

      when(repo.getAuthenticationInfo()).thenAnswer(
        (_) => TaskOption.some(
          const AuthenticationInfo(
            email: 'email',
            token: token,
            encodedPasscode: 'encodedPasscode',
          ),
        ),
      );

      final result = await interceptor.onRequest(request);

      expect(result.headers.containsKey('Authorization'), isTrue);
      expect(result.headers['Authorization'], equals('Bearer $token'));
    },
  );

  test(
    'GIVEN no token in SecureStorage '
    'WHEN calling onRequest '
    'THEN no Authorization Header is added to the request',
    () async {
      when(repo.getAuthenticationInfo()).thenAnswer((_) => TaskOption.none());
      final result = await interceptor.onRequest(request);
      expect(result.headers.containsKey('Authorization'), isFalse);
    },
  );
}
