/*
 * Copyright (c) 2021 William Kwabla. All rights reserved.
 */

import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:version/version.dart';

class PlayStoreSearchAPI {
  final Client client;
  final Logger logger;

  final String playStorePrefixURL = 'play.google.com';

  PlayStoreSearchAPI({
    required this.client,
    required this.logger,
  });

  /// Look up by id.
  Future<Document?> lookupById(
    String id, {
    String? country = 'US',
    String? language = 'en',
    bool useCacheBuster = true,
  }) async {
    assert(id.isNotEmpty);
    if (id.isEmpty) return null;

    final url = lookupURLById(
      id,
      country: country,
      language: language,
      useCacheBuster: useCacheBuster,
    )!;

    logger.d('upgrader: lookupById url: $url');

    try {
      final response = await client.get(Uri.parse(url));
      if (response.statusCode < 200 || response.statusCode >= 300) {
        logger.d(
          "upgrader: Can't find an app in the Play Store with the id: $id",
        );

        return null;
      }

      final decodedResults = _decodeResults(response.body);

      return decodedResults;
    } on Exception catch (e) {
      logger.d('upgrader: lookupById exception: $e');
      return null;
    }
  }

  String? lookupURLById(
    String id, {
    String? country = 'US',
    String? language = 'en',
    bool useCacheBuster = true,
  }) {
    assert(id.isNotEmpty);
    if (id.isEmpty) return null;

    final Map<String, dynamic> parameters = {'id': id};
    if (country != null && country.isNotEmpty) {
      parameters['gl'] = country;
    }
    if (language != null && language.isNotEmpty) {
      parameters['hl'] = language;
    }
    if (useCacheBuster) {
      parameters['_cb'] = DateTime.now().microsecondsSinceEpoch.toString();
    }
    final url = Uri.https(playStorePrefixURL, '/store/apps/details', parameters)
        .toString();

    return url;
  }

  Document? _decodeResults(String jsonResponse) {
    if (jsonResponse.isNotEmpty) {
      final decodedResults = parse(jsonResponse);
      return decodedResults;
    }
    return null;
  }
}

extension PlayStoreResults on PlayStoreSearchAPI {
  /// Return field version from Play Store results.
  String? version(Document response) {
    String? version;
    try {
      final additionalInfoElements = response.getElementsByClassName('hAyfc');
      final versionElement = additionalInfoElements.firstWhere(
        (elm) => elm.querySelector('.BgcNfc')!.text == 'Current Version',
      );
      final storeVersion = versionElement.querySelector('.htlgb')!.text;
      // storeVersion might be: 'Varies with device', which is not a valid version.
      version = Version.parse(storeVersion).toString();
    } catch (e) {
      return redesignedVersion(response);
    }

    return version;
  }

  /// Return field version from Redesigned Play Store results.
  String? redesignedVersion(Document response) {
    String? version;
    try {
      const patternName = ',"name":"';
      const patternVersion = ',[[["';
      const patternCallback = 'AF_initDataCallback';
      const patternEndOfString = '"';

      final scripts = response.getElementsByTagName('script');
      final infoElements =
          scripts.where((element) => element.text.contains(patternName));
      final additionalInfoElements =
          scripts.where((element) => element.text.contains(patternCallback));
      final additionalInfoElementsFiltered = additionalInfoElements
          .where((element) => element.text.contains(patternVersion));

      final nameElement = infoElements.first.text;
      final storeNameStartIndex =
          nameElement.indexOf(patternName) + patternName.length;
      final storeNameEndIndex = storeNameStartIndex +
          nameElement
              .substring(storeNameStartIndex)
              .indexOf(patternEndOfString);
      final storeName =
          nameElement.substring(storeNameStartIndex, storeNameEndIndex);

      final versionElement = additionalInfoElementsFiltered
          .where((element) => element.text.contains('"$storeName"'))
          .first
          .text;
      final storeVersionStartIndex =
          versionElement.lastIndexOf(patternVersion) + patternVersion.length;
      final storeVersionEndIndex = storeVersionStartIndex +
          versionElement
              .substring(storeVersionStartIndex)
              .indexOf(patternEndOfString);
      final storeVersion = versionElement.substring(
        storeVersionStartIndex,
        storeVersionEndIndex,
      );

      // storeVersion might be: 'Varies with device', which is not a valid version.
      version = Version.parse(storeVersion).toString();
    } catch (e) {
      logger.d('upgrader: PlayStoreResults.redesignedVersion exception: $e');
    }

    return version;
  }
}
