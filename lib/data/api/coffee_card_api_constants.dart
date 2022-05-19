class CoffeeCardApiConstants {
  static const String productionUrl = 'https://analogio.dk/clippy';
  static const String testUrl = 'https://beta.analogio.dk/api/clippy';
  static const String betav2Url = 'https://api-test.analogio.dk/coffeecard';
  static const String shiftyUrl = 'https://shifty.analogio.dk/shiftplanning';

  static const String apiVersion = '1';

  static const String minAppVersion = '2.1.0';

  static Uri analogIOGitHub = Uri.parse('https://github.com/AnalogIO/');

  // mobilepay urls
  static Uri mobilepayAndroid =
      Uri.parse('market://details?id=dk.danskebank.mobilepay');
  static Uri mobilepayIOS =
      Uri.parse('itms-apps://itunes.apple.com/app/id624499138');
}
