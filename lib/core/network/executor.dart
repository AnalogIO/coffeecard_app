import 'package:chopper/chopper.dart' show Response;
import 'package:coffeecard/core/errors/exceptions.dart';
import 'package:logger/logger.dart';

class Executor {
  final Logger logger;

  const Executor(this.logger);

  /// Executes a network request.
  ///
  /// Throws a [ServerException] if the API call was unsuccessful.
  Future<Result?> call<Result>(
    Future<Response<Result>> Function() request,
  ) async {
    final response = await request();

    if (!response.isSuccessful) {
      logger.e(response.toString());
      throw ServerException.fromResponse(response);
    }

    return response.body;
  }
}
