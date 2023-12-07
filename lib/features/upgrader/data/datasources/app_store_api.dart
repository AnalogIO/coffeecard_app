import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:logger/logger.dart';

class AppStoreAPI {
  final Client client;
  final Logger logger;

  final String lookupPrefixURL = 'https://itunes.apple.com/lookup';

  AppStoreAPI({
    required this.client,
    required this.logger,
  });

  Future<Map?> lookupByBundleId(
    String bundleId, {
    String? country = 'US',
    bool useCacheBuster = true,
  }) async {
    assert(bundleId.isNotEmpty);
    if (bundleId.isEmpty) {
      return null;
    }

    final url = lookupURLByBundleId(
      bundleId,
      country: country ?? '',
      useCacheBuster: useCacheBuster,
    )!;
    logger.d('upgrader: download: $url');

    try {
      final response = await client.get(Uri.parse(url));

      logger.d('upgrader: response statusCode: ${response.statusCode}');

      final decodedResults = _decodeResults(response.body);
      return decodedResults;
    } catch (e) {
      logger.d('upgrader: lookupByBundleId exception: $e');

      return null;
    }
  }

  String? lookupURLByBundleId(
    String bundleId, {
    String country = 'US',
    bool useCacheBuster = true,
  }) {
    if (bundleId.isEmpty) {
      return null;
    }

    return lookupURLByQSP(
      {'bundleId': bundleId, 'country': country.toUpperCase()},
      useCacheBuster: useCacheBuster,
    );
  }

  String? lookupURLByQSP(
    Map<String, String?> qsp, {
    bool useCacheBuster = true,
  }) {
    if (qsp.isEmpty) {
      return null;
    }

    final parameters = <String>[];
    qsp.forEach((key, value) => parameters.add('$key=$value'));
    if (useCacheBuster) {
      parameters.add('_cb=${DateTime.now().microsecondsSinceEpoch}');
    }
    final finalParameters = parameters.join('&');

    return '$lookupPrefixURL?$finalParameters';
  }

  Map? _decodeResults(String jsonResponse) {
    if (jsonResponse.isNotEmpty) {
      final decodedResults = json.decode(jsonResponse);
      if (decodedResults is Map) {
        final resultCount = decodedResults['resultCount'];
        if (resultCount == 0) {
          logger.d(
            'upgrader.ITunesSearchAPI: results are empty: $decodedResults',
          );
        }
        return decodedResults;
      }
    }
    return null;
  }

  String? version(Map response) {
    String? value;
    try {
      // ignore: avoid_dynamic_calls
      value = response['results'][0]['version'] as String;
    } catch (e) {
      logger.d('upgrader.ITunesResults.version: $e');
    }
    return value;
  }
}
