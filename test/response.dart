import 'package:chopper/chopper.dart' as chopper;
import 'package:http/http.dart' as http;

class Response {
  static chopper.Response<T> fromStatusCode<T>(int statusCode, {T? body}) {
    return chopper.Response(
      http.Response('', statusCode),
      body,
    );
  }
}
