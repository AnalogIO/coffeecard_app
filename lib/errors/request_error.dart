import 'package:coffeecard/base/strings.dart';

class RequestError {
  const RequestError(this.message, this.code);
  final String message;
  final int code;
}

class ClientNetworkError extends RequestError {
  ClientNetworkError() : super(Strings.noInternet, 0);
}
