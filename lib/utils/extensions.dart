import 'package:chopper/chopper.dart';

extension FormatExtension on Response {
  String formatError() {
    return 'API Error $statusCode $error';
  }
}
