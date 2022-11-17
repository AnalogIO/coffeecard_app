import 'package:chopper/chopper.dart';
import 'package:coffeecard/base/strings.dart';

/// Empty success class.
class RequestSuccess {}

class RequestError {
  RequestError(this.message, this.code);
  final String message;
  final int code;

  RequestError.fromResponse(Response response)
      : assert(!response.isSuccessful),
        message = response.error.toString(),
        code = response.statusCode;

  RequestError.clientNetworkError()
      : message = Strings.noInternet,
        code = 0;
}
