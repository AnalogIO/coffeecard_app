import 'package:screen_brightness/screen_brightness.dart' as sb;

class ScreenBrightness {
  Future<void> setScreenBrightness(double brightness) =>
      sb.ScreenBrightness().setApplicationScreenBrightness(brightness);
  Future<void> resetScreenBrightness() =>
      sb.ScreenBrightness().resetApplicationScreenBrightness();
}
