import 'dart:io';

abstract class AppFont {
  static final String heading = Platform.isIOS ? 'SF UI Display' : 'Roboto';
  static final String body = Platform.isIOS ? 'SF UI Text' : 'Roboto';
  static const String mono = 'RobotoMono';
}
