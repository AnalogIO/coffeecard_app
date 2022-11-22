import 'package:chopper/chopper.dart';

/// Empty success class.
class RequestSuccess {}

class RequestFailure {
  RequestFailure(this.message);
  final String message;
}

class RequestHttpFailure extends RequestFailure {
  RequestHttpFailure(super.message, this.statusCode);
  final int statusCode;

  RequestHttpFailure.fromResponse(Response response)
      : assert(!response.isSuccessful),
        statusCode = response.statusCode,
        super(response.error.toString());
}
