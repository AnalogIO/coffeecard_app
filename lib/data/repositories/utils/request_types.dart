import 'package:chopper/chopper.dart';

/// Empty success class.
class RequestSuccess {}

class RequestFailure {
  RequestFailure(this.message);
  final String message;
}

class RequestHttpFailure extends RequestFailure {
  RequestHttpFailure(super.message, this.code);
  final int code;

  RequestHttpFailure.fromResponse(Response response)
      : assert(!response.isSuccessful),
        code = response.statusCode,
        super(response.error.toString());
}
