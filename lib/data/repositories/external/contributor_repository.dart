// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:coffeecard/base/strings.dart';
import 'package:coffeecard/data/api/coffee_card_api_constants.dart';
import 'package:coffeecard/models/api/api_error.dart';
import 'package:coffeecard/models/contributor.dart';
import 'package:coffeecard/utils/either.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ContributorRepository {
  final Logger _logger;

  ContributorRepository(this._logger);

  Future<Either<ApiError, List<Contributor>>> getContributors() async {
    final url = Uri.parse(CoffeeCardApiConstants.analogIOmembersUrl);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List<dynamic>;
      final List<Contributor> contributors = json
          .map(
            (json) => Contributor(
              avatarUrl: json['avatar_url']! as String,
              githubUrl: json['html_url']! as String,
              name: json['login']! as String,
            ),
          )
          .toList();

      return Right(contributors);
    } else {
      _logger.e(
        Strings.formatApiError(
          response.statusCode,
          response.reasonPhrase,
        ),
      );
      return Left(ApiError(response.reasonPhrase!));
    }
  }
}
