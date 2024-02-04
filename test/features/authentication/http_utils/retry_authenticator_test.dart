import 'package:chopper/chopper.dart' as chopper;
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/authentication.dart';
import 'package:coffeecard/features/login/data/datasources/account_remote_data_source.dart';
import 'package:coffeecard/generated/api/coffeecard_api.models.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'retry_authenticator_test.mocks.dart';
import 'test_utils.dart';

@GenerateNiceMocks([
  MockSpec<AuthenticationCubit>(),
  MockSpec<AccountRemoteDataSource>(),
  MockSpec<AuthenticationRepository>(),
  MockSpec<Logger>(),
])
void main() {
  late MockAuthenticationCubit authenticationCubit;
  late MockAccountRemoteDataSource accountRemoteDataSource;
  late MockAuthenticationRepository repository;
  late MockLogger logger;

  late RetryAuthenticator authenticator;

  setUp(() {
    authenticationCubit = MockAuthenticationCubit();
    accountRemoteDataSource = MockAccountRemoteDataSource();
    repository = MockAuthenticationRepository();
    logger = MockLogger();

    authenticator = RetryAuthenticator.uninitialized(
      repository: repository,
      cubit: authenticationCubit,
      logger: logger,
    )..initialize(accountRemoteDataSource);

    provideDummy(TaskOption<AuthenticationInfo>.none());
    provideDummy(
      Either<Failure, AuthenticationInfo>.left(const ConnectionFailure()),
    );
    provideDummy(Task.of(unit));

    when(repository.clearAuthenticationInfo()).thenReturn(Task.of(unit));
    when(repository.saveAuthenticationInfo(any)).thenReturn(Task.of(unit));
  });

  test(
    'GIVEN an uninitialized RetryAuthenticator '
    'WHEN authenticate is called '
    'THEN it should throw a StateError',
    () {
      // Arrange
      final authenticator = RetryAuthenticator.uninitialized(
        repository: repository,
        cubit: authenticationCubit,
        logger: logger,
      );
      final request = _requestFromMethod('GET');
      final response = _responseFromStatusCode(401);

      // Act
      final result = authenticator.authenticate(request, response);

      // Assert
      expect(result, throwsStateError);
    },
  );

  test(
    'GIVEN a 401 response stemming from a request with a LoginDto body '
    'WHEN authenticate is called '
    'THEN it should return null',
    () async {
      // Arrange
      final request = _requestFromMethod('POST');
      final response = _responseFromStatusCode(
        401,
        body: const LoginDto(email: 'a', password: 'b', version: 'c'),
      );

      // Act
      final result = authenticator.authenticate(request, response);

      // Assert
      expect(result, completion(isNull));
    },
  );

  test(
    'GIVEN a response with status code other than 401 '
    'WHEN authenticate is called '
    'THEN it should return null',
    () async {
      // Arrange
      final request = _requestFromMethod('GET');
      final response = _responseFromStatusCode(200);

      // Act
      final result = authenticator.authenticate(request, response);

      // Assert
      expect(result, completion(isNull));
    },
  );

  test(
    'GIVEN '
    '1) a response with status code 401, '
    '2) no prior calls to authenticate, '
    '3) no stored login credentials '
    'WHEN authenticate is called '
    'THEN it should return null',
    () async {
      // Arrange
      final request = _requestFromMethod('GET');
      final response = _responseFromStatusCode(401);

      when(repository.getAuthenticationInfo()).thenReturn(TaskOption.none());

      // Act
      final result = authenticator.authenticate(request, response);

      // Assert
      expectLater(result, completion(isNull));
    },
  );

  test(
    'GIVEN '
    '1) response with status code 401, '
    '2) no prior calls to authenticate, '
    '3) stored login credentials that are invalid '
    'WHEN authenticate is called '
    'THEN '
    '1) AccountRemoteDataSource.login should be called with the stored credentials, '
    '2) AuthenticationCubit.unauthenticated should be called, '
    '3) authenticate should return null',
    () async {
      // Arrange
      const email = 'a';
      const encodedPasscode = 'b';
      const token = 'c';

      when(repository.getAuthenticationInfo()).thenReturn(
        TaskOption.some(
          const AuthenticationInfo(
            email: email,
            token: token,
            encodedPasscode: encodedPasscode,
          ),
        ),
      );
      when(accountRemoteDataSource.login(email, encodedPasscode)).thenAnswer(
        (_) async => Either.left(const ConnectionFailure()),
      );

      final request = _requestFromMethod('GET');
      final response = _responseFromStatusCode(401);

      // Act
      final result = authenticator.authenticate(request, response);

      // Assert
      await result;
      // 1
      verify(accountRemoteDataSource.login(email, encodedPasscode)).called(1);
      verifyNoMoreInteractions(accountRemoteDataSource);
      // 2
      verify(authenticationCubit.unauthenticated()).called(1);
      verifyNoMoreInteractions(authenticationCubit);
      // 3
      expect(result, completion(isNull));
    },
  );

  test(
    'GIVEN '
    '1) a response with status code 401, '
    '2) no prior calls to authenticate, '
    '3) valid stored login credentials '
    'WHEN authenticate is called '
    'THEN '
    '1) AccountRemoteDataSource.login should be called with the stored credentials, '
    '2) repository should save the new authentication info, '
    '3) authenticate should return a new request with the updated token',
    () async {
      // Arrange
      const email = 'a';
      const encodedPasscode = 'b';
      const oldToken = 'c';
      const newToken = 'd';

      when(repository.getAuthenticationInfo()).thenReturn(
        TaskOption.some(
          const AuthenticationInfo(
            email: email,
            token: oldToken,
            encodedPasscode: encodedPasscode,
          ),
        ),
      );

      when(accountRemoteDataSource.login(email, encodedPasscode)).thenAnswer(
        (_) async => Either.of(
          const AuthenticationInfo(
            email: email,
            token: newToken,
            encodedPasscode: encodedPasscode,
          ),
        ),
      );

      final request = _requestFromMethod('GET');
      final response = _responseFromStatusCode(401);

      // Act
      final result = authenticator.authenticate(request, response);

      // Assert
      await result;
      // 1
      verify(accountRemoteDataSource.login(email, encodedPasscode)).called(1);
      verifyNoMoreInteractions(accountRemoteDataSource);
      // 2
      verify(repository.getAuthenticationInfo().run()).called(1);
      verify(repository.saveAuthenticationInfo(any).run()).called(1);
      verifyNoMoreInteractions(repository);
      // 3
      expect(result, requestHavingAuthHeader(equals('Bearer $newToken')));
    },
  );

  test(
    'GIVEN '
    '1) a response with status code 401, '
    '2) a prior call to authenticate is running, '
    '3) and stored valid login credentials exist '
    'WHEN authenticate is called '
    'THEN '
    '1) it should return a new request with the updated token '
    '2) it should not call the login method again',
    () async {
      // Arrange
      const email = 'a';
      const encodedPasscode = 'b';
      const oldToken = 'c';

      int counter = 0;
      String getNewToken() => '${++counter}';

      when(repository.getAuthenticationInfo()).thenReturn(
        TaskOption.some(
          const AuthenticationInfo(
            email: email,
            token: oldToken,
            encodedPasscode: encodedPasscode,
          ),
        ),
      );

      when(accountRemoteDataSource.login(email, encodedPasscode)).thenAnswer(
        (_) async => right(
          AuthenticationInfo(
            email: email,
            token: getNewToken(),
            encodedPasscode: encodedPasscode,
          ),
        ),
      );

      final request = _requestFromMethod('GET');
      final response = _responseFromStatusCode(401);

      // Simulate a prior call to authenticate is running
      final call1 = authenticator.authenticate(request, response);

      // Act
      final call2 = authenticator.authenticate(request, response);

      // Assert
      // 1
      expect(call1, requestHavingAuthHeader(equals('Bearer 1')));
      expect(call2, requestHavingAuthHeader(equals('Bearer 1')));
      // 2
      await Future.wait([call1, call2]);
      verify(accountRemoteDataSource.login(email, encodedPasscode)).called(1);
      verifyNoMoreInteractions(accountRemoteDataSource);
    },
  );

  test(
    'GIVEN a response with status code 401, '
    'and stored valid login credentials exist '
    'WHEN authenticate is called '
    'THEN it should return a new request with the updated token',
    () async {
      // Arrange
      const email = 'a';
      const encodedPasscode = 'b';
      const newToken = 'c';

      when(repository.getAuthenticationInfo()).thenAnswer(
        (_) => TaskOption.some(
          const AuthenticationInfo(
            email: email,
            token: newToken,
            encodedPasscode: encodedPasscode,
          ),
        ),
      );

      when(accountRemoteDataSource.login(email, encodedPasscode)).thenAnswer(
        (_) async => right(
          const AuthenticationInfo(
            email: email,
            token: newToken,
            encodedPasscode: encodedPasscode,
          ),
        ),
      );

      final request = _requestFromMethod('GET');
      final response = _responseFromStatusCode(401);

      // Act
      final result = authenticator.authenticate(request, response);

      // Assert
      expect(result, requestHavingAuthHeader(equals('Bearer $newToken')));
    },
  );
}

chopper.Response<T> _responseFromStatusCode<T>(int statusCode, {T? body}) {
  return chopper.Response(http.Response('', statusCode), body);
}

chopper.Request _requestFromMethod(String method) {
  return chopper.Request(method, Uri.parse('test'), Uri.parse('basetest'));
}
