import 'package:chopper/chopper.dart' as chopper;
import 'package:coffeecard/core/errors/failures.dart';
import 'package:coffeecard/features/authentication/data/datasources/authentication_local_data_source.dart';
import 'package:coffeecard/features/authentication/data/models/authenticated_user_model.dart';
import 'package:coffeecard/features/authentication/domain/entities/authenticated_user.dart';
import 'package:coffeecard/features/authentication/presentation/cubits/authentication_cubit.dart';
import 'package:coffeecard/features/login/data/datasources/account_remote_data_source.dart';
import 'package:coffeecard/features/reactivation/data/reactivation_authenticator.dart';
import 'package:coffeecard/generated/api/coffeecard_api.swagger.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'reactivation_authenticator_test.mocks.dart';

@GenerateMocks([
  AuthenticationCubit,
  AccountRemoteDataSource,
  AuthenticationLocalDataSource,
  Logger,
])
void main() {
  late _FakeGetIt serviceLocator;
  late MockAuthenticationCubit authenticationCubit;
  late MockAccountRemoteDataSource accountRemoteDataSource;
  late MockAuthenticationLocalDataSource secureStorage;

  late ReactivationAuthenticator authenticator;

  setUp(() {
    serviceLocator = _FakeGetIt.fromMockedObjects(
      authenticationCubit: MockAuthenticationCubit(),
      accountRemoteDataSource: MockAccountRemoteDataSource(),
      authenticationLocalDataSource: MockAuthenticationLocalDataSource(),
      mockLogger: MockLogger(),
    );

    authenticationCubit = serviceLocator.getMock<MockAuthenticationCubit>();
    accountRemoteDataSource =
        serviceLocator.getMock<MockAccountRemoteDataSource>();
    secureStorage = serviceLocator.getMock<MockAuthenticationLocalDataSource>();

    authenticator =
        ReactivationAuthenticator.uninitialized(serviceLocator: serviceLocator);
    authenticator.initialize(accountRemoteDataSource);

    provideDummy<Option<AuthenticatedUserModel>>(none());

    provideDummy<Either<Failure, AuthenticatedUser>>(
      const Left(ConnectionFailure()),
    );
  });

  test(
    'GIVEN a response with status code other than 401 '
    'WHEN authenticate is called '
    'THEN it should return null',
    () async {
      // Arrange
      final request = _requestFromMethod('GET');
      final response = _responseFromStatusCode(200);

      // Act
      final result = await authenticator.authenticate(request, response);

      // Assert
      expect(result, isNull);
    },
  );

  test(
    'GIVEN '
    '1) a response with status code 401, '
    '2) no prior calls to authenticate, '
    'and 3) no stored login credentials '
    'WHEN authenticate is called '
    'THEN it should return null',
    () async {
      // Arrange
      final request = _requestFromMethod('GET');
      final response = _responseFromStatusCode(401);

      when(secureStorage.getAuthenticatedUser())
          .thenAnswer((_) async => none());

      // Act
      final result = await authenticator.authenticate(request, response);

      // Assert
      expect(result, isNull);
    },
  );

  test(
    'GIVEN '
    '1) response with status code 401, '
    '2) no prior calls to authenticate, '
    'and 3) stored login credentials that are invalid '
    'WHEN authenticate is called '
    'THEN '
    '1) AccountRemoteDataSource.login should be called with the stored credentials, '
    '2) AuthenticationCubit.unauthenticated should be called, '
    'and 3) it should return null',
    () async {
      // Arrange
      const email = 'email';
      const encodedPasscode = 'encodedPasscode';
      const token = 'token';
      const reason = 'invalid credentials';
      final loginRequest = chopper.Request(
        'method',
        Uri.parse('test'),
        Uri.parse('basetest'),
        body: const LoginDto(
          email: 'email',
          password: 'encodedPasscode',
          version: 'verison',
        ),
      );

      when(secureStorage.getAuthenticatedUser()).thenAnswer(
        (_) async => some(
          AuthenticatedUserModel(
            email: email,
            token: token,
            encodedPasscode: 'encodedPasscode',
            lastLogin: none(),
            sessionTimeout: none(),
          ),
        ),
      );
      when(accountRemoteDataSource.login(email, encodedPasscode)).thenAnswer(
        (_) async {
          //  Simulate a failed login attempt through the NetworkRequestExecutor
          final _ = await authenticator.authenticate(
            loginRequest,
            _responseFromStatusCode(401),
          );
          return left(const ServerFailure(reason, 500));
        },
      );

      final request = _requestFromMethod('GET');
      final response = _responseFromStatusCode(401);

      // Act
      final result = await authenticator.authenticate(request, response);

      // Assert
      verify(accountRemoteDataSource.login(email, encodedPasscode)).called(1);
      verify(authenticationCubit.unauthenticated()).called(1);
      expect(result, isNull);
      verifyNoMoreInteractions(accountRemoteDataSource);
      verifyNoMoreInteractions(authenticationCubit);
    },
  );

  test(
    'GIVEN '
    '1) a response with status code 401, '
    '2) no prior calls to authenticate, '
    'and 3) valid stored login credentials '
    'WHEN authenticate is called '
    'THEN '
    '1) AccountRemoteDataSource.login should be called with the stored credentials, '
    '2) SecureStorage.updateToken should be called, '
    'and 3) it should return a new request with the updated token',
    () async {
      // Arrange
      const email = 'email';
      const encodedPasscode = 'encodedPasscode';
      const oldToken = 'oldToken';
      const newToken = 'newToken';

      when(secureStorage.getAuthenticatedUser()).thenAnswer(
        (_) async => some(
          AuthenticatedUserModel(
            email: email,
            token: oldToken,
            encodedPasscode: encodedPasscode,
            lastLogin: none(),
            sessionTimeout: none(),
          ),
        ),
      );

      when(accountRemoteDataSource.login(email, encodedPasscode)).thenAnswer(
        (_) async => right(
          AuthenticatedUser(
            email: email,
            token: newToken,
            encodedPasscode: 'encodedPasscode',
            lastLogin: none(),
            sessionTimeout: none(),
          ),
        ),
      );

      final request = _requestFromMethod('GET');
      final response = _responseFromStatusCode(401);

      // Act
      final result = await authenticator.authenticate(request, response);

      // Assert
      verify(accountRemoteDataSource.login(email, encodedPasscode)).called(1);
      verifyNoMoreInteractions(accountRemoteDataSource);

      verify(secureStorage.getAuthenticatedUser()).called(1);
      verify(secureStorage.updateToken(newToken)).called(1);
      verifyNoMoreInteractions(secureStorage);

      expect(result, isNotNull);
      expect(result!.headers['Authorization'], 'Bearer $newToken');
    },
  );

  test(
    'GIVEN '
    '1) a response with status code 401, '
    '2) a prior call to authenticate is running, '
    'and 3) and stored valid login credentials exist '
    'WHEN authenticate is called '
    'THEN it should return a new request with the updated token',
    () async {
      // Arrange
      const email = 'email';
      const encodedPasscode = 'encodedPasscode';
      const oldToken = 'oldToken';

      int counter = 0;
      String getNewToken() => '${++counter}';

      when(secureStorage.getAuthenticatedUser()).thenAnswer(
        (_) async => some(
          AuthenticatedUserModel(
            email: email,
            token: oldToken,
            encodedPasscode: encodedPasscode,
            lastLogin: none(),
            sessionTimeout: none(),
          ),
        ),
      );

      when(accountRemoteDataSource.login(email, encodedPasscode)).thenAnswer(
        (_) async => right(
          AuthenticatedUser(
            email: email,
            token: getNewToken(),
            encodedPasscode: 'encodedPasscode',
            lastLogin: none(),
            sessionTimeout: none(),
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
      final result1 = await call1;
      expect(result1, isNotNull);
      expect(result1!.headers['Authorization'], 'Bearer 1');

      // Both calls should have the same new token
      final result2 = await call2;
      expect(result2, isNotNull);
      expect(result2!.headers['Authorization'], 'Bearer 1');
    },
  );

  test(
    'GIVEN a response with status code 401, '
    'and stored valid login credentials exist '
    'WHEN authenticate is called '
    'THEN it should return a new request with the updated token',
    () async {
      // Arrange
      const email = 'email';
      const encodedPasscode = 'encodedPasscode';
      const newToken = 'newToken';

      when(secureStorage.getAuthenticatedUser()).thenAnswer(
        (_) async => some(
          AuthenticatedUserModel(
            email: email,
            token: newToken,
            encodedPasscode: encodedPasscode,
            lastLogin: none(),
            sessionTimeout: none(),
          ),
        ),
      );

      when(accountRemoteDataSource.login(email, encodedPasscode)).thenAnswer(
        (_) async => right(
          AuthenticatedUser(
            email: email,
            token: newToken,
            encodedPasscode: 'encodedPasscode',
            lastLogin: none(),
            sessionTimeout: none(),
          ),
        ),
      );

      final request = _requestFromMethod('GET');
      final response = _responseFromStatusCode(401);

      // Act
      final result = await authenticator.authenticate(request, response);

      // Assert
      expect(result, isNotNull);
      expect(result!.headers['Authorization'], 'Bearer $newToken');
    },
  );
}

chopper.Response<T> _responseFromStatusCode<T>(
  int statusCode, {
  T? body,
}) {
  return chopper.Response(
    http.Response('', statusCode),
    body,
  );
}

chopper.Request _requestFromMethod(String method) {
  return chopper.Request(method, Uri.parse('test'), Uri.parse('basetest'));
}

class _FakeGetIt extends Fake implements GetIt {
  _FakeGetIt.fromMockedObjects({
    required this.authenticationCubit,
    required this.accountRemoteDataSource,
    required this.authenticationLocalDataSource,
    required this.mockLogger,
  });

  final MockAuthenticationCubit authenticationCubit;
  final MockAccountRemoteDataSource accountRemoteDataSource;
  final MockAuthenticationLocalDataSource authenticationLocalDataSource;
  final MockLogger mockLogger;

  @override
  // We don't care about the parameter types, so we can ignore the warning
  // ignore: type_annotate_public_apis
  T call<T extends Object>({String? instanceName, param1, param2, Type? type}) {
    return get<T>(
      instanceName: instanceName,
      param1: param1,
      param2: param2,
      type: type,
    );
  }

  @override
  // We don't care about the parameter types, so we can ignore the warning
  // ignore: type_annotate_public_apis
  T get<T extends Object>({String? instanceName, param1, param2, Type? type}) {
    return switch (T) {
      const (AuthenticationCubit) => authenticationCubit,
      const (AccountRemoteDataSource) => accountRemoteDataSource,
      const (AuthenticationLocalDataSource) => authenticationLocalDataSource,
      const (Logger) => mockLogger,
      _ => throw UnimplementedError('Mock for $T not implemented.'),
    } as T;
  }

  /// Given a mocked type, get the mocked object for the given type.
  T getMock<T extends Mock>() {
    return switch (T) {
      const (MockAuthenticationCubit) => authenticationCubit,
      const (MockAccountRemoteDataSource) => accountRemoteDataSource,
      const (MockAuthenticationLocalDataSource) =>
        authenticationLocalDataSource,
      const (MockLogger) => mockLogger,
      _ => throw UnimplementedError('Mock for $T not implemented.'),
    } as T;
  }
}
