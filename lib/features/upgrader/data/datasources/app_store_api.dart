import 'dart:async';
import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class AppStoreAPI {
  final Client client;
  final Logger logger;

  static const prefixUrl = 'https://itunes.apple.com/lookup';

  AppStoreAPI({
    required this.client,
    required this.logger,
  });

  Future<Option<String>> lookupVersion(String id) async {
    final response = await _lookupByBundleId(id);

    return response.match(
      () => none(),
      (response) => version(response),
    );
  }

  Future<Option<Map>> _lookupByBundleId(
    String bundleId, {
    String country = 'EU', //FIXME: validate this works
  }) async {
    if (bundleId.isEmpty) {
      return none();
    }

    final url = _lookupURLByBundleId(
      bundleId,
      country: country,
    );

    return url.match(
      () => none(),
      (url) async {
        try {
          final response = await client.get(Uri.parse(url));

          logger.d('upgrader response statusCode: ${response.statusCode}');

          return _decodeResults(response.body);
        } catch (e) {
          logger.d('upgrader lookupByBundleId exception: $e');

          return none();
        }
      },
    );
  }

  Option<String> _lookupURLByBundleId(
    String bundleId, {
    String country = 'US',
  }) {
    if (bundleId.isEmpty) {
      return none();
    }

    return _lookupURLByQSP(
      {'bundleId': bundleId, 'country': country.toUpperCase()},
    );
  }

  Option<String> _lookupURLByQSP(Map<String, String?> qsp) {
    if (qsp.isEmpty) {
      return none();
    }

    final parameters = <String>[];
    qsp.forEach((key, value) => parameters.add('$key=$value'));

    parameters.add('_cb=${DateTime.now().microsecondsSinceEpoch}');

    final allParameters = parameters.join('&');

    return some('$prefixUrl?$allParameters');
  }

  Option<Map> _decodeResults(String jsonResponse) {
    if (jsonResponse.isEmpty) {
      return none();
    }

    final decodedResults = json.decode(jsonResponse);

    if (decodedResults is! Map) {
      return none();
    }

    return some(decodedResults);
  }

  Option<String> version(Map response) {
    try {
      // ignore: avoid_dynamic_calls
      final version = response['results'][0]['version'] as String;
      return some(version);
    } catch (e) {
      logger.d('upgrader version exception: $e');
    }

    return none();
  }
}
