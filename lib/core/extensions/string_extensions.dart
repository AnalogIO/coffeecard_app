extension StringExtensions on String {
  /// capitalize the first letter of the string
  String capitalize() {
    // TODO: check for emojis
    // ignore: avoid-substring
    return this[0].toUpperCase() + substring(1);
  }
}
