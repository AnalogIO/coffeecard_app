import 'package:fpdart/fpdart.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:version/version.dart';

class PlayStoreAPI {
  final Client client;
  final Logger logger;

  static const prefixUrl = 'play.google.com';

  PlayStoreAPI({
    required this.client,
    required this.logger,
  });

  Future<Option<String>> lookupVersion(String id) async {
    final document = await _lookupById(id);

    return document.match(
      () => none(),
      (document) => _version(document),
    );
  }

  Future<Option<Document>> _lookupById(
    String id, {
    String? country = 'US', //FIXME: validate this works
    String? language = 'en',
  }) async {
    if (id.isEmpty) return none();

    final url = _lookupURLById(
      id,
      country: country,
      language: language,
    );

    logger.d('upgrader lookupById url: $url');

    return url.match(
      () => none(),
      (url) async {
        try {
          final response = await client.get(Uri.parse(url));
          if (response.statusCode < 200 || response.statusCode >= 300) {
            logger.d(
              "upgrader Can't find an app in the Play Store with the id: $id",
            );

            return none();
          }

          final decodedResults = _decodeResults(response.body);

          return decodedResults;
        } on Exception catch (e) {
          logger.d('upgrader lookupById exception: $e');
          return none();
        }
      },
    );
  }

  Option<String> _lookupURLById(
    String id, {
    String? country = 'US',
    String? language = 'en',
  }) {
    if (id.isEmpty) {
      return none();
    }

    final Map<String, dynamic> parameters = {'id': id};
    if (country != null && country.isNotEmpty) {
      parameters['gl'] = country;
    }
    if (language != null && language.isNotEmpty) {
      parameters['hl'] = language;
    }

    parameters['_cb'] = DateTime.now().microsecondsSinceEpoch.toString();

    final url =
        Uri.https(prefixUrl, '/store/apps/details', parameters).toString();

    return some(url);
  }

  Option<Document> _decodeResults(String jsonResponse) {
    if (jsonResponse.isEmpty) {
      return none();
    }

    final decodedResults = parse(jsonResponse);
    return some(decodedResults);
  }

  Option<String> _version(Document response) {
    try {
      final additionalInfoElements = response.getElementsByClassName('hAyfc');
      final versionElement = additionalInfoElements.firstWhere(
        (elm) => elm.querySelector('.BgcNfc')!.text == 'Current Version',
      );
      final storeVersion = versionElement.querySelector('.htlgb')!.text;
      // storeVersion might be: 'Varies with device', which is not a valid version.
      final version = Version.parse(storeVersion).toString();
      return some(version);
    } catch (e) {
      return _redesignedVersion(response);
    }
  }

  Option<String> _redesignedVersion(Document response) {
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
      final version = Version.parse(storeVersion).toString();
      return some(version);
    } catch (e) {
      logger.d('upgrader PlayStoreResults.redesignedVersion exception: $e');
    }

    return none();
  }
}
