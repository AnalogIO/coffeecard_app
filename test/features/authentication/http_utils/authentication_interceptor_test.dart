import 'package:chopper/chopper.dart';
import 'package:coffeecard/features/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'authentication_interceptor_test.mocks.dart';
import 'test_utils.dart';

@GenerateNiceMocks([MockSpec<AuthenticationRepository>()])
void main() {
  late MockAuthenticationRepository repository;
  late AuthenticationInterceptor interceptor;
  late Request request;

  setUp(() {
    provideDummy<TaskOption<AuthenticationInfo>>(TaskOption.none());

    repository = MockAuthenticationRepository();
    interceptor = AuthenticationInterceptor(repository);
    request = Request('POST', Uri.parse('url'), Uri.parse('baseurl'));
  });

  test(
    'GIVEN stored authentication info in AuthenticationRepository '
    'WHEN calling onRequest '
    'THEN Authorization Header is added to the request',
    () {
      // arrange
      const token = 'a';
      when(repository.getAuthenticationInfo()).thenReturn(
        TaskOption.some(
          const AuthenticationInfo(
            email: 'email',
            token: token,
            encodedPasscode: 'encodedPasscode',
          ),
        ),
      );

      // act
      final result = interceptor.onRequest(request);

      // assert
      expect(result, requestHavingAuthHeader(equals('Bearer $token')));
    },
  );

  test(
    'GIVEN no stored authentication info in AuthenticationRepository '
    'WHEN calling onRequest '
    'THEN no Authorization Header is added to the request',
    () {
      // arrange
      when(repository.getAuthenticationInfo()).thenReturn(TaskOption.none());

      // act
      final result = interceptor.onRequest(request);

      // assert
      expect(result, requestHavingAuthHeader(isNull));
    },
  );
}
