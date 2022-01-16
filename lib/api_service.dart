//FIXME: this is surely wrong, how do we refactor this into the current pattern?

import 'dart:convert';

import 'package:http/http.dart';

class APIService {
  static AppConfig? ac;
  static const String betaUrl = 'https://beta.analogio.dk/api/clippy/api/v1/';
  static const String prodUrl = '?';

  static Future<Response> getJSON(String endpoint) async {
    final url = Uri.parse('$betaUrl$endpoint');

    final Map<String, String> headers = {
      'Authorization':
          'bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJmcmVtQGl0dS5kayIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiJmcmVtIiwiVXNlcklkIjoiNDQiLCJuYmYiOjE2NDIyNDUzOTUsImV4cCI6MTY0MjMzMTc5NSwiaXNzIjoiQW5hbG9nSU8iLCJhdWQiOiJFdmVyeW9uZSJ9.vN-bZ6XFvV5KCj-dFu68cYqK7LcvsAUMTmrfZNoZdfE'
    };

    headers.putIfAbsent('Accept', () => 'application/json');

    return get(
      url,
      headers: headers,
    );
  }

  static Future<Response> postJSON(
    String endpoint,
    Map<String, dynamic> body,
  ) {
    final url = Uri.parse('$betaUrl$endpoint');

    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization':
          'bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiJmcmVtQGl0dS5kayIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiJmcmVtIiwiVXNlcklkIjoiNDQiLCJuYmYiOjE2NDIyNDUzOTUsImV4cCI6MTY0MjMzMTc5NSwiaXNzIjoiQW5hbG9nSU8iLCJhdWQiOiJFdmVyeW9uZSJ9.vN-bZ6XFvV5KCj-dFu68cYqK7LcvsAUMTmrfZNoZdfE'
    };

    return post(url, headers: headers, body: jsonEncode(body));
  }

  static Future<bool> isProduction() async {
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
