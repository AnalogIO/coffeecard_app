import 'package:flutter/widgets.dart';

extension StringExtensions on String {
  /// Capitalize the first letter of the string.
  ///
  /// If the first letter is an emoji, the string will not be capitalized.
  String capitalize() =>
      (characters.take(1).toUpperCase() + characters.skip(1)).string;
}
