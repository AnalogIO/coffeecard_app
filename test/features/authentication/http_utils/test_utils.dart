import 'package:chopper/chopper.dart';
import 'package:flutter_test/flutter_test.dart';

/// Asynchronously matches a [Request] with an Authorization header that
/// matches the given [authHeaderMatcher].
Matcher requestHavingAuthHeader(dynamic authHeaderMatcher) {
  return completion(
    isA<Request>().having(
      (request) => request.headers['Authorization'],
      'Authorization header',
      authHeaderMatcher,
    ),
  );
}
