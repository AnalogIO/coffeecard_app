import 'package:chopper/chopper.dart';

extension RequestX on Request {
  /// Returns a copy of this [Request] with the given [token] added to the
  /// `Authorization` header.
  Request withBearerToken(String token) =>
      this..headers['Authorization'] = 'Bearer $token';
}
