class CoffeeCardApiConstants {
  static const String _productionUrl = 'https://analogio.dk/clippy';
  static const String _testUrl = 'https://beta.analogio.dk/api/clippy';

  static const String shiftyUrl = 'https://shifty.analogio.dk/shiftplanning';

  static const String apiVersion = '1';

  static const String minAppVersion = '2.1.0';

  static Uri analogIOGitHub = Uri.parse('https://github.com/AnalogIO/');

  // mobilepay urls
  static Uri mobilepayAndroid =
      Uri.parse('market://details?id=dk.danskebank.mobilepay');
  static Uri mobilepayIOS =
      Uri.parse('itms-apps://itunes.apple.com/app/id624499138');

  static String getCoffeeCardUrl() {
    const isProd = bool.fromEnvironment('IS_PROD');

    if (isProd) {
      return _productionUrl;
    }

    return _testUrl;
  }
}
