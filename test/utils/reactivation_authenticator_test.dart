import 'package:chopper/chopper.dart' as chopper;
import 'package:coffeecard/cubits/authentication/authentication_cubit.dart';
import 'package:coffeecard/data/repositories/shared/account_repository.dart';
import 'package:coffeecard/data/storage/secure_storage.dart';
import 'package:coffeecard/utils/reactivation_authenticator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'package:mockito/mockito.dart';

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

class _MockAuthenticationCubit extends Mock implements AuthenticationCubit {}

class _MockAccountRepository extends Mock implements AccountRepository {}

class _MockSecureStorage extends Mock implements SecureStorage {}

class _MockLogger extends Mock implements Logger {}

class _FakeGetIt extends Fake implements GetIt {
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
      AuthenticationCubit => _MockAuthenticationCubit(),
      AccountRepository => _MockAccountRepository(),
      SecureStorage => _MockSecureStorage(),
      Logger => _MockLogger(),
      _ => throw UnimplementedError('Mock for $T not implemented.'),
    } as T;
  }
}

void main() {
  group('ReactivationAuthenticator', () {
    late _FakeGetIt serviceLocator;
    late _MockAuthenticationCubit authenticationCubit;
    late _MockAccountRepository accountRepository;
    late _MockSecureStorage secureStorage;
    late _MockLogger logger;

    late ReactivationAuthenticator authenticator;

    setUp(() {
      serviceLocator = _FakeGetIt();
      authenticationCubit = _MockAuthenticationCubit();
      accountRepository = _MockAccountRepository();
      secureStorage = _MockSecureStorage();
      logger = _MockLogger();

      authenticator = ReactivationAuthenticator(serviceLocator);
    });

    test(
      'authenticate should return null if response status code is not 401',
      () async {
        final request = _requestFromMethod('GET');
        final response = _responseFromStatusCode(200);
        final result = await authenticator.authenticate(request, response);

        expect(result, isNull);
      },
    );
  });
}
