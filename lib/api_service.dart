//FIXME: this is surely wrong, how do we refactor this into the current pattern?

import 'dart:collection';

import 'package:http/http.dart';

class APIService {
  AppConfig? ac;
  final String betaUrl = 'https://beta.analogio.dk/api/clippy/api/v1/';
  final String prodUrl = '?';

  Future<Response> getJSON(String endpoint) async {
    final url = Uri.parse('$betaUrl$endpoint');

    final Map<String, String> headers = HashMap();

    headers.putIfAbsent('Accept', () => 'application/json');

    return get(
      url,
      headers: headers,
    );
  }

  Future<bool> isProduction() async {
    if (ac == null) {
      final Response r = await getJSON('AppConfig');
      ac = AppConfig.fromJson(r.body as Map<String, dynamic>);
    }

    return ac?.environmentType == 'Production';
  }
}

class AppConfig {
  String environmentType;
  String merchantId;

  AppConfig({required this.environmentType, required this.merchantId});

  AppConfig.fromJson(Map<String, dynamic> json)
      : environmentType = json['environmentType'] as String,
        merchantId = json['merchantId'] as String;
}
