import 'package:chopper/chopper.dart' as chopper;
import 'package:http/http.dart' as http;

/// Create a response for testing
chopper.Response<T> responseFromStatusCode<T>(
  int statusCode, {
  T? body,
}) {
  return chopper.Response(
    http.Response('', statusCode),
    body,
  );
}
