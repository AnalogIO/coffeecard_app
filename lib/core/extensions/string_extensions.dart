extension StringExtensions on String {
  /// capitalize the first letter of the string
  String capitalize() {
    // ignore: avoid-substring
    //TODO: check for emojis
    return this[0].toUpperCase() + substring(1);
  }
}
