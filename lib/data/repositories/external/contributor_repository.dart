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
      final jsonList = jsonDecode(response.body) as List<dynamic>;
      final List<Contributor> contributors = [];

      for (final json in jsonList) {
        final githubUsername = json['login']! as String;

        final either = await getContributorName(githubUsername);

        contributors.add(
          Contributor(
            avatarUrl: json['avatar_url']! as String,
            githubUrl: json['html_url']! as String,
            name: either.isRight ? either.right : githubUsername,
          ),
        );
      }

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

  Future<Either<ApiError, String>> getContributorName(
    String contributor,
  ) async {
    final url =
        Uri.parse('${CoffeeCardApiConstants.githubApiUserUrl}$contributor');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as dynamic;

      final String name = json['name']! as String;

      return Right(name);
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
